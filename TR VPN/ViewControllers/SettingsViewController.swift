//
//  SettingsViewController.swift
//  TR VPN
//
//  Created by Илья Гусаров on 26.10.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let supportTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 15
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    let supportLabel = ["Write a review", "Watch ad", "Terms and Conditions", "App version"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0/255, green: 40/255, blue: 68/255, alpha: 1)
        
        supportTableView.delegate = self
        supportTableView.dataSource = self
        
        title = "Application"
        
        view.addSubview(supportTableView)
        
        applyConstraints()
    }

}

extension SettingsViewController {
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            supportTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            supportTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            supportTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            supportTableView.heightAnchor.constraint(equalToConstant: 240)
        ])
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        supportLabel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        
        let text = supportLabel[indexPath.row]
        if text == supportLabel.last {
            cell.configure(mainText: text, secondText: UIApplication.appVersion!)
            cell.selectionStyle = .none
        } else {
            cell.configure(mainText: text, secondText: ">")

        }
  
        cell.backgroundColor = UIColor(red: 15/255, green: 76/255, blue: 120/255, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}
