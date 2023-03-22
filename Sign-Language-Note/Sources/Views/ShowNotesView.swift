//
//  ShowNotesView.swift
//  Sign-Language-Note
//
//  Created by 홍세은 on 2022/11/07.
//

import Foundation
import UIKit

class ShowNotesView: UIView {
    
    private lazy var navigationBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hexString: "BCBCBC").cgColor
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "전체노트"
        label.font = UIFont(name: "dovemayo_gothic", size: 20)
        label.textColor = .textColor
        return label
    }()
    
    var backBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private var noteList: [NoteModel] = []
    private let viewModel = ShowNotesViewModel.shared
    
    override init(frame: CGRect){
        super.init(frame: frame)
        fetchTableView()
        setTableView()
        setupViews()
        viewModel.fetchNoteList()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nibName = UINib(nibName: "NoteCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "NoteCell")
        tableView.separatorStyle = .none
    }
    
    func fetchTableView() {
        viewModel.onUpdated = {[weak self] in
            DispatchQueue.main.async {
                self?.noteList = self?.viewModel.noteList ?? []
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setupViews() {
        backgroundColor = .white
        setUpNavigationBarView()
        setUpBackBtn()
        setUpTitleLabel()
        setUpTableView()
    }
    
    private func setUpNavigationBarView() {
        addSubview(navigationBarView)
        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            navigationBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            navigationBarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            navigationBarView.heightAnchor.constraint(equalToConstant: 93)
        ])
    }
    
    private func setUpTitleLabel() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: navigationBarView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: navigationBarView.bottomAnchor, constant: -10)
        ])
    }
    
    private func setUpBackBtn() {
        addSubview(backBtn)
        NSLayoutConstraint.activate([
            backBtn.bottomAnchor.constraint(equalTo: navigationBarView.bottomAnchor, constant: -10),
            backBtn.leadingAnchor.constraint(equalTo: navigationBarView.leadingAnchor, constant: 15)
        ])
    }
    
    private func setUpTableView() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
}

extension ShowNotesView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        cell.dateLabel.text = noteList[indexPath.row].date
        cell.contentLabel.text = noteList[indexPath.row].content
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            if editingStyle == .delete {
                noteList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                UserDefaultsManager.shared.save(noteList)
            }
        }
}
