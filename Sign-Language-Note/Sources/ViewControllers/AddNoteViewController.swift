//
//  AddNoteViewController.swift
//  Sign-Language-Note
//
//  Created by 홍세은 on 2022/11/07.
//

import UIKit
import AVFoundation

class AddNoteViewController: UIViewController {
    
    private lazy var addNoteView = AddNoteView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        setupViews()
        setupAction()
    }

    private func setupViews() {
        view.addSubview(addNoteView)
        addNoteView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addNoteView.topAnchor.constraint(equalTo: view.topAnchor),
            addNoteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            addNoteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addNoteView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupAction() {
        addNoteView.setupPopVCHandler {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
