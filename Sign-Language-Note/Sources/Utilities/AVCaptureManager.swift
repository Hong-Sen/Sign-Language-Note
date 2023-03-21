//
//  AVCaptureManager.swift
//  Sign-Language-Note
//
//  Created by 홍세은 on 2023/02/08.
//

import UIKit
import AVFoundation
import Vision

public protocol VideoCaptureDelegate: AnyObject {
    func getPredictionResult(label: String)
}

public class AVCaptureManager: NSObject {
    public weak var delegate: VideoCaptureDelegate?
    private let captureSession = AVCaptureSession()
    var videoDevice = AVCaptureDevice.DiscoverySession(
        deviceTypes: [.builtInWideAngleCamera],
        mediaType: .video,
        position: .back
    ).devices.first
    var deviceInput: AVCaptureDeviceInput!
    var videoOutput = AVCaptureVideoDataOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!
    let videoOutputQueue = DispatchQueue(
        label: "videoOutput",
        qos: .userInteractive,
        attributes: [],
        autoreleaseFrequency: .workItem)
    var handposeRequest = VNDetectHumanHandPoseRequest()
    var bufferSize: CGSize = .zero
    var lastTimestamp = CMTime()
    let model = ASLHandPoseClassifier()
    
    private func setupAVCapture(completion: @escaping (AVCaptureFailureReason?) -> Void) {
            guard let videoDevice = videoDevice else {
            completion(.deviceNotFound)
            return
        }
        
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice)
        } catch {
            completion(.couldNotCreateDeviceInput)
            return
        }
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high
        
        guard captureSession.canAddInput(deviceInput) else {
            completion(.couldNotAddInputToSession)
            captureSession.commitConfiguration()
            return
        }
        
        captureSession.addInput(deviceInput)
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
            
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : NSNumber(value: kCVPixelFormatType_32BGRA)]
            // DispatchQueue가 사용중일때 도착한 프레임은 폐기처리
            videoOutput.alwaysDiscardsLateVideoFrames = true
            // DispatchQueue로 유입된 프레임을 전달하는 델리게이트 구현
            videoOutput.setSampleBufferDelegate(self, queue: videoOutputQueue)
        }
        else {
            completion(.couldNotAddOutputToSsession)
            captureSession.commitConfiguration()
            return
        }

        let captureConnection = videoOutput.connection(with: .video)
        captureConnection?.isEnabled = true
        captureConnection?.videoOrientation = .portrait
        
        do {
            try videoDevice.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions(videoDevice.activeFormat.formatDescription)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            videoDevice.unlockForConfiguration()
        } catch {
            completion(.failedVideoCaptureLockForConfiguration)
            return
        }
        
        captureSession.commitConfiguration()
        completion(nil)
    }
    
    private func setupCaptureVideoPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    }
    
    func createVideoPreviewLayer(failureReason: @escaping(AVCaptureFailureReason) -> Void, previewLayerValue: @escaping(AVCaptureVideoPreviewLayer) -> Void) {
        setupAVCapture { [weak self] error in
            if let error = error {
                failureReason(error)
                return
            }
            
            self?.setupCaptureVideoPreviewLayer()
            
            guard let previewLayer = self?.previewLayer else {
                failureReason(.unavailablePreviewLayer)
                return
            }
            
            previewLayerValue(previewLayer)
        }
    }
    
    // startRunning 과 stopRunning은 메인 스레드를 block 하기 때문에
    // UI버벅이지 않게 하려면 메인 스레드와 분리해서 실행한다.
    public func startCapturing(completion: (() -> Void)? = nil) {
        videoOutputQueue.async {
            if !self.captureSession.isRunning {
                self.captureSession.startRunning() // startRunning을 호출하면 카메라(입력)으로 부터 델리게이트(출력)까지 데이터 흐름이 시작된다.
            }
            if let completion = completion {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    public func stopCapturing(completion:  (() -> Void)? = nil) {
        if self.captureSession.isRunning {
            self.captureSession.stopRunning()
        }
        if let completion = completion {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

extension AVCaptureManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // output은 AVCaptureVideoDataOutput 형식이고 프레임 관련 출력
        guard let delegate = self.delegate else { return }
        handposeRequest.maximumHandCount = 1
        handposeRequest.revision = VNDetectHumanHandPoseRequestRevision1 // ?
        
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer)
        do {
            try handler.perform([handposeRequest])
        } catch {
            print(error.localizedDescription)
        }
        
        guard let handPoses = handposeRequest.results, !handPoses.isEmpty else { return }
        let observation = handPoses.first
        do {
            guard let keypointsMultiArray = try observation?.keypointsMultiArray() else { fatalError() }
            let output = try model.prediction(poses: keypointsMultiArray)
            let outputLabel = output.label
            let confidence = output.labelProbabilities[outputLabel]!
            if confidence > 0.8 {
                delegate.getPredictionResult(label: output.label)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
