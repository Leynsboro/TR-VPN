//
//  SettingsTableViewCell.swift
//  TR VPN
//
//  Created by Илья Гусаров on 27.10.2022.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(mainLabel)
        addSubview(secondLabel)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(mainText: String, secondText: String) {
        mainLabel.text = mainText
        secondLabel.text = secondText
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainLabel.trailingAnchor.constraint(equalTo: secondLabel.leadingAnchor, constant: 10),
            secondLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            secondLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

}
