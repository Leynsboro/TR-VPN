//
//  SettingsViewController.swift
//  TR VPN
//
//  Created by Ilia Gusarov on 26.10.2022.
//

import UIKit

class SettingsViewController: UIViewController {
        
    private let versionImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        image.image = UIImage(named: "logo")
        return image
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "ver. \(UIApplication.appVersion ?? "0.0.0")"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private let supportTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 15
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.tintColor = .white
        return tableView
    }()
    
    private let buttonsNames = ["Write a review", "Watch ads", "Privacy Policy", "Terms & Conditions", "Follow instagram", "Hello"]
    
    private let tableRowHeight = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.mainBackgroundColor
        
        supportTableView.delegate = self
        supportTableView.dataSource = self
        
        title = "Application"
        
        view.addSubview(versionImage)
        view.addSubview(versionLabel)
        view.addSubview(supportTableView)
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        let tableHeight = tableRowHeight * buttonsNames.count
        
        NSLayoutConstraint.activate([
            versionImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            versionImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            versionImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4),
            versionImage.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4)
        ])
        
        NSLayoutConstraint.activate([
            versionLabel.topAnchor.constraint(equalTo: versionImage.bottomAnchor, constant: 15),
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            supportTableView.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 50),
            supportTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            supportTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            supportTableView.heightAnchor.constraint(equalToConstant: CGFloat(tableHeight))
        ])
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        buttonsNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        let text = buttonsNames[indexPath.row]
        
        cell.configureSettings(mainText: text)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(tableRowHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Here is the implementation of the buttons
    }
}
