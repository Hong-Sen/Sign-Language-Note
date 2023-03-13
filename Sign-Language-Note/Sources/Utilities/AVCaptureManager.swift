//
//  AVCaptureManager.swift
//  Sign-Language-Note
//
//  Created by 홍세은 on 2023/02/08.
//

import Foundation
import AVFoundation

class AVCaptureManager: NSObject {
    private let captureSession = AVCaptureSession()
    var videoDevice = AVCaptureDevice.DiscoverySession(
        deviceTypes: [.builtInWideAngleCamera],
        mediaType: .video,
        position: .back
    ).devices.first
    var deviceInput: AVCaptureDeviceInput!
    var videoOutput = AVCaptureVideoDataOutput()
    var previewLayer: AVCaptureVideoPreviewLayer?
    let videoOutputQueue = DispatchQueue(
        label: "videoOutput",
        qos: .userInteractive,
        attributes: [],
        autoreleaseFrequency: .workItem)
    var bufferSize: CGSize = .zero
    
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
            
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.setSampleBufferDelegate(self, queue: videoOutputQueue)
        }
        else {
            completion(.couldNotAddOutputToSsession)
            captureSession.commitConfiguration()
            return
        }

        let captureConnection = videoOutput.connection(with: .video)
        captureConnection?.isEnabled = true
        
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
}

extension AVCaptureManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //
    }
}
