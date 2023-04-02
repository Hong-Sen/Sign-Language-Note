//
//  NotAllowCameraView.swift
//  Sign-Language-Note
//
//  Created by 홍세은 on 2023/03/13.
//

import UIKit

class NotAllowCameraView: UIView {
    
    private var notAllowVideoImg: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(systemName: "video.slash.fill")
        img.tintColor = .white
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private var infoLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "dovemayo_gothic", size: 20)
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Please allow access to the camera"
        return label
    }()

    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .black
        setupInfoLabel()
        setupNotAllowVideoImg()
    }
    
    func setupInfoLabel() {
        addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setupNotAllowVideoImg() {
        addSubview(notAllowVideoImg)
        NSLayoutConstraint.activate([
            notAllowVideoImg.bottomAnchor.constraint(equalTo: infoLabel.topAnchor, constant: -20),
            notAllowVideoImg.centerXAnchor.constraint(equalTo: centerXAnchor),
            notAllowVideoImg.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
   
    
}
