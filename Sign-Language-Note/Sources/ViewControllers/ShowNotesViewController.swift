//
//  ShowNotesViewController.swift
//  Sign-Language-Note
//
//  Created by 홍세은 on 2022/11/07.
//

import UIKit

class ShowNotesViewController: UIViewController {

    private lazy var showNotesView = ShowNotesView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.isHidden = true
        view.addSubview(showNotesView)
        showNotesView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showNotesView.topAnchor.constraint(equalTo: view.topAnchor),
            showNotesView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            showNotesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            showNotesView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        showNotesView.backBtn.addTarget(self, action: #selector(backBtnSelected), for: .touchUpInside)
    }
    
    @objc private func backBtnSelected() {
        self.navigationController?.popViewController(animated: true)
    }
}
