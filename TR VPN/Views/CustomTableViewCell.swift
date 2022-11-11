//
//  SettingsTableViewCell.swift
//  TR VPN
//
//  Created by Ilia Gusarov on 27.10.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private let descImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .white
        image.image = UIImage(systemName: "checkmark.circle.fill")
        return image
    }()
    
    private let actionImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.image = UIImage(systemName: "chevron.right.circle.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = .white
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(descImage)
        addSubview(mainLabel)
        addSubview(actionImage)
  
        backgroundColor = UIColor(red: 15/255, green: 76/255, blue: 120/255, alpha: 1)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureSettings(mainText: String) {
        mainLabel.text = mainText
    }
    
    func configureServerList(mainText: String, countryImage: String) {
        mainLabel.text = mainText
        descImage.image = UIImage(named: countryImage)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            descImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            descImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            descImage.trailingAnchor.constraint(equalTo: mainLabel.leadingAnchor, constant: -5),
            descImage.widthAnchor.constraint(equalToConstant: 30),
            mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            actionImage.widthAnchor.constraint(equalTo: actionImage.heightAnchor, multiplier: 1/1),
        ])
    }

}
