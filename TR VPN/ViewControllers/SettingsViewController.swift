//
//  SettingsViewController.swift
//  TR VPN
//
//  Created by Илья Гусаров on 26.10.2022.
//

import UIKit
import YandexMobileAds

class SettingsViewController: UIViewController, YMAInterstitialAdDelegate {
    
    var interstitialAd: YMAInterstitialAd!
    
    private let versionImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        image.image = UIImage(named: "AppIcon")
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
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.tintColor = .white
        return tableView
    }()
    
    private let menuButton = ["Write a review", "Watch ads", "Privacy Policy", "Terms & Conditions", "Follow instagram"]
    
    private let tableRowHeight = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0/255, green: 40/255, blue: 68/255, alpha: 1)
        
        supportTableView.delegate = self
        supportTableView.dataSource = self
        
        title = "Application"
        
        view.addSubview(versionImage)
        view.addSubview(versionLabel)
        view.addSubview(supportTableView)
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        let imageWidth = (view.frame.width / 3.5)
        let tableHeight = tableRowHeight * menuButton.count
        
        NSLayoutConstraint.activate([
            versionImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            versionImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            versionImage.widthAnchor.constraint(equalToConstant: imageWidth),
            versionImage.heightAnchor.constraint(equalToConstant: imageWidth)
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
        menuButton.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        
        let text = menuButton[indexPath.row]
        
        cell.configure(mainText: text)

        cell.backgroundColor = UIColor(red: 15/255, green: 76/255, blue: 120/255, alpha: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(tableRowHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            print("review")
        case 1:
            showAd()
        case 2:
            openSite(with: "https://tr-vpn.com/privacy.html")
        case 3:
            openSite(with: "https://tr-vpn.com/terms.html")
        case 4:
            openSite(with: "https://instagram.com/ilia.leynsboro")
        default:
            break
        }
        
    }
}

extension SettingsViewController {
    func interstitialAdDidLoad(_ interstitialAd: YMAInterstitialAd) {
        interstitialAd.present(from: self)
        print("Ad loaded")
    }
    
    private func showAd() {
        interstitialAd = YMAInterstitialAd(adUnitID: "R-M-1998463-1")
        interstitialAd.delegate = self
        interstitialAd.load()
    }
    
    private func openSite(with url: String) {
        guard let webURL = URL(string:  url) else { return }
        UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
    }   
}
