//
//  ServerListViewController.swift
//  TR VPN
//
//  Created by Ilia Gusarov on 25.10.2022.
//

import UIKit

class ServerListViewController: UIViewController, UINavigationControllerDelegate {
    
    var delegate: MainViewController?
    
    private var serverList: [Server]!
    
    private let serverListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 15
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tintColor = .white
        tableView.backgroundColor = UIColor(red: 15/255, green: 76/255, blue: 120/255, alpha: 1)
        tableView.separatorColor = .gray
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.mainBackgroundColor
        
        serverListTableView.dataSource = self
        serverListTableView.delegate = self
        
        view.addSubview(serverListTableView)
        
        serverList = Server.getServers()
        
        applyConstraints()
    }
                                                            
    @objc private func closeView() {
        dismiss(animated: true)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            serverListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            serverListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            serverListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            serverListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

}

extension ServerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        serverList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        
        let server = serverList[indexPath.row]
        
        cell.configureServerList(mainText: server.region, countryImage: server.flag)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let server = serverList[indexPath.row]
        
        serverChosen(server: server)
    }
    
    
}

extension ServerListViewController {
    private func serverChosen(server: Server) {
        delegate?.updateChosenServer(server: server)
        dismiss(animated: true)
    }
}
