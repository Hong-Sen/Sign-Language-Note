//
//  NoteCell.swift
//  Sign-Language-Note
//
//  Created by 홍세은 on 2022/11/07.
//

import UIKit

class NoteCell: UITableViewCell {
    
    private lazy var cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hexString: "D1D1D1").cgColor
        return view
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "dovemayo_gothic", size: 15)
        label.textColor = .textColor
        return label
    }()
    
    var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "dovemayo_gothic", size: 20)
        label.textColor = .textColor
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpViews()
    }

    private func setUpViews() {
        setUpCellView()
        setUpDateLabel()
        setUpContentLabel()
    }
    
    private func setUpCellView() {
        addSubview(cellView)
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            cellView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    private func setUpDateLabel() {
        cellView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 11)
        ])
    }
    
    private func setUpContentLabel() {
        cellView.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 11),
            contentLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 11),
            contentLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: 11)
        ])
    }
    
}
