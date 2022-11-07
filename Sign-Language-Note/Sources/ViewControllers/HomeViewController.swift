//
//  HomeViewController.swift
//  Sign-Language-Note
//
//  Created by 홍세은 on 2022/11/07.
//

import UIKit

class HomeViewController: UIViewController {

    private lazy var rootView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(rootView)
        rootView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rootView.topAnchor.constraint(equalTo: view.topAnchor),
            rootView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            rootView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        rootView.addNoteBtn.addTarget(self, action: #selector(presentAddNoteVC), for: .touchUpInside)
        rootView.showNotesBtn.addTarget(self, action: #selector(presentShowNotesVC), for: .touchUpInside)
    }
    
    @objc private func presentAddNoteVC() {
        let addNoteVC = AddNoteViewController()
        self.navigationController?.pushViewController(addNoteVC, animated: true)
    }
    
    @objc private func presentShowNotesVC() {
        let showNotesVC = ShowNotesViewController()
        self.navigationController?.pushViewController(showNotesVC, animated: true)
    }

}
