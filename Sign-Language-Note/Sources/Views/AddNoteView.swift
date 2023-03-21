//
//  AddNoteView.swift
//  Sign-Language-Note
//
//  Created by 홍세은 on 2022/11/07.
//

import Foundation
import UIKit
import AVFoundation
import CoreML

class AddNoteView: UIView {
    
    private lazy var textView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.text = ""
        return label
    }()
    
    var backBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(backBtnSelected), for: .touchUpInside)
        return btn
    }()
    
    private lazy var deleteBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "delete.left.fill"), for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(deleteBtnSelected), for: .touchUpInside)
        return btn
    }()
    
    lazy var cameraView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    lazy var recognizedTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 64, weight: .regular)
        label.textColor = .red
        label.textAlignment = .center
        label.text = "?"
        return label
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    
    private lazy var addBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "icon_add"), for: .normal)
        btn.addTarget(self, action: #selector(addeBtnSelected), for: .touchUpInside)
        return btn
    }()
    
    private lazy var recordBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "plus.app"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(recordBtnSelected), for: .touchUpInside)
        return btn
    }()
    
    private lazy var avCaptureManager = AVCaptureManager()
    let model = ASLHandPoseClassifier()
    let context = CIContext()
    private let userDefault = UserDefaults.standard
    var noteList: [NoteModel] = UserDefaultsManager.shared.load()
    private let dateFormatter = DateFormatter()
    private let notAllowCameraView = NotAllowCameraView()
    var popVCHandler: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        checkCameraAuthorization()
        setupViews()
        sendSubviewToBack(cameraView)
        
        self.avCaptureManager.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPopVCHandler(_ handler: @escaping () -> Void) {
        popVCHandler = handler
    }
    
    private func setupViews() {
        backgroundColor = .black
        setUpTitleView()
        setUpBackBtn()
        setUpDeleteBtn()
        setUpResultLabel()
        setUpCameraView()
        setUpRecognizedTextLabel()
        setUpBottomView()
        setUpAddBtn()
        setUpRecordBtn()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    private func setUpTitleView() {
        addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func setUpBackBtn() {
        textView.addSubview(backBtn)
        NSLayoutConstraint.activate([
            backBtn.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            backBtn.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 9),
            backBtn.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setUpResultLabel() {
        textView.addSubview(resultLabel)
        NSLayoutConstraint.activate([
            resultLabel.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            resultLabel.leadingAnchor.constraint(equalTo: backBtn.trailingAnchor, constant: 10),
            resultLabel.trailingAnchor.constraint(equalTo: deleteBtn.leadingAnchor, constant: -10)
        ])
    }
    
    private func setUpDeleteBtn() {
        textView.addSubview(deleteBtn)
        NSLayoutConstraint.activate([
            deleteBtn.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            deleteBtn.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -15),
            deleteBtn.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setUpCameraView() {
        addSubview(cameraView)
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 0),
            cameraView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            cameraView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            cameraView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -130)
        ])
    }
    
    func setUpRecognizedTextLabel() {
        addSubview(recognizedTextLabel)
        NSLayoutConstraint.activate([
            recognizedTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: 140),
            recognizedTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
    
    private func setUpBottomView() {
        addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: cameraView.bottomAnchor, constant: 0),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            bottomView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    private func setUpAddBtn() {
        bottomView.addSubview(addBtn)
        NSLayoutConstraint.activate([
            addBtn.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            addBtn.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            addBtn.heightAnchor.constraint(equalToConstant: 70),
            addBtn.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func setUpRecordBtn() {
        bottomView.addSubview(recordBtn)
        NSLayoutConstraint.activate([
            recordBtn.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor, constant: 0),
            recordBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -45),
            recordBtn.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("새노트: 카메라 권한 이미 허용")
            avCaptureManager.createVideoPreviewLayer { AVCaptureFailureReason in
                print("previewLayer Error: \(AVCaptureFailureReason)")
            } previewLayerValue: { previewLayerValue in
                self.setupPreviewLayer(previewLayer: previewLayerValue)
            }
            avCaptureManager.startCapturing()
            
            break
        default:
            print("새노트: 카메라 권한 거부")
            setupNotAllowCameraView()
            recognizedTextLabel.isHidden = true
            addBtn.isEnabled = false
            recordBtn.isEnabled = false
            break
        }
    }
    
    func setupNotAllowCameraView() {
        notAllowCameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.addSubview(notAllowCameraView)
        NSLayoutConstraint.activate([
            notAllowCameraView.topAnchor.constraint(equalTo: cameraView.topAnchor),
            notAllowCameraView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
            notAllowCameraView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
            notAllowCameraView.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor)
        ])
    }
    
    func setupPreviewLayer(previewLayer: AVCaptureVideoPreviewLayer) {
        cameraView.layer.insertSublayer(previewLayer, at: 0)
        DispatchQueue.main.async {
            previewLayer.frame = self.cameraView.bounds
            UIView.animate(withDuration: 0.8) {
                self.cameraView.layer.opacity = 1
            }
        }
    }
    
    @objc private func deleteBtnSelected() {
        if let resultText = resultLabel.text, !resultLabel.text!.isEmpty {
            var txt = resultText
            txt.removeLast()
            resultLabel.text = txt
        }
    }
    
    private func saveNote(content: String) {
        let timeStamp =  Date()
        let date = dateFormatter.string(from: timeStamp)
        let note = NoteModel(date: date, content: content)
        noteList.append(note)
        UserDefaultsManager.shared.save(noteList)
    }
    
    @objc private func addeBtnSelected() {
        if let recognizedText = recognizedTextLabel.text, let resultText = resultLabel.text {
            if resultText.count >= 18 {
                saveNote(content: resultText)
                resultLabel.text = recognizedText
            }
            else {
                resultLabel.text = resultText + String(recognizedText)
            }
        }
    }
    
    @objc private func recordBtnSelected() {
        if let resultText = resultLabel.text {
            if resultText.count == 0 { return }
            saveNote(content: resultText)
            resultLabel.text = ""
        }
    }
    
    @objc private func backBtnSelected() {
        popVCHandler?()
    }
}

extension AddNoteView: VideoCaptureDelegate {
    func getPredictionResult(label: String) {
        DispatchQueue.main.async {
            self.recognizedTextLabel.text = label
        }
    }
}
