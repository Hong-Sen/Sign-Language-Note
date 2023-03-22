//
//  HomeView.swift
//  Sign-Language-Note
//
//  Created by 홍세은 on 2022/11/07.
//

import Foundation
import UIKit
import AVFoundation

class HomeView: UIView {
    
    private lazy var titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "수어노트"
        label.font = UIFont(name: "dovemayo_gothic", size: 36)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.text = "조용한 대화, 수어\n소중한 대화를 기록으로 남겨보세요"
        label.font = UIFont(name: "dovemayo", size: 17)
        label.textColor = .textColor
        label.textAlignment = .center
        return label
    }()
    
    var addNoteBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .primary
        btn.layer.cornerRadius = 10
        btn.setTitle("새 노트 추가하기", for: .normal)
        btn.titleLabel?.font = UIFont(name: "dovemayo_gothic", size: 20)
        btn.titleLabel?.tintColor = .textColor
        btn.titleLabel?.textAlignment = .center
        return btn
    }()
    
    var showNotesBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .primary
        btn.layer.cornerRadius = 10
        btn.setTitle("전체 노트 보기", for: .normal)
        btn.titleLabel?.font = UIFont(name: "dovemayo_gothic", size: 20)
        btn.titleLabel?.tintColor = .textColor
        btn.titleLabel?.textAlignment = .center
        return btn
    }()
    
    init() {
        super.init(frame: .zero)
        checkCameraAuthorization()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        setUpTitleView()
        setUpTitleLabel()
        setUpDescriptionLabel()
        setUpAddNoteBtn()
        setUpShowNoteBtn()
    }
    
    private func setUpTitleView() {
        addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleView.topAnchor.constraint(equalTo: topAnchor, constant: 70),
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            titleView.heightAnchor.constraint(equalToConstant: 181)
        ])
    }
    
    private func setUpTitleLabel() {
        titleView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 30)
        ])
    }
    
    private func setUpDescriptionLabel() {
        titleView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -14)
        ])
    }
    
    private func setUpAddNoteBtn() {
        addSubview(addNoteBtn)
        NSLayoutConstraint.activate([
            addNoteBtn.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 58),
            addNoteBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 34),
            addNoteBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -34),
            addNoteBtn.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
    
    private func setUpShowNoteBtn() {
        addSubview(showNotesBtn)
        NSLayoutConstraint.activate([
            showNotesBtn.topAnchor.constraint(equalTo: addNoteBtn.bottomAnchor, constant: 69),
            showNotesBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 34),
            showNotesBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -34),
            showNotesBtn.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
    
    func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("홈: 카메라 권한 이미 허용")
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted else {
                    print("홈: 카메라 권한 거부")
                    return
                }
                print("홈: 카메라 권한 허용")
            }
            break
        default:
            print("홈: 카메라 권한 거부")
            break
        }
    }
    
}
