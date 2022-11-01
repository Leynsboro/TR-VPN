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
        label.textColor = .white
        return label
    }()
    
    private let actionImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "chevron.right.circle.fill")
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.tintColor = .white
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(mainLabel)
        addSubview(actionImage)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(mainText: String) {
        mainLabel.text = mainText
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainLabel.trailingAnchor.constraint(equalTo: actionImage.leadingAnchor, constant: 10),
            actionImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

}
