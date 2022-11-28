//
//  HomeView.swift
//  Sign-Language-Note
//
//  Created by 홍세은 on 2022/11/07.
//

import Foundation
import UIKit

class HomeView: UIView {
    
    private lazy var titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleBackgroundImg: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "title_background_img")
        return img
    }()
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "수어노트"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.text = "조용한 대화, 수어\n소중한 대화를 기록으로 남겨보세요"
        label.font = .systemFont(ofSize: 15, weight: .regular)
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
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
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
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        btn.titleLabel?.tintColor = .textColor
        btn.titleLabel?.textAlignment = .center
        return btn
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        setUpTitleView()
        setUpTitleBackgroundImg()
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
    
    private func setUpTitleBackgroundImg() {
        titleView.addSubview(titleBackgroundImg)
        NSLayoutConstraint.activate([
            titleBackgroundImg.topAnchor.constraint(equalTo: titleView.topAnchor),
            titleBackgroundImg.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -84),
            titleBackgroundImg.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 0),
            titleBackgroundImg.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: 0),
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
    
}
