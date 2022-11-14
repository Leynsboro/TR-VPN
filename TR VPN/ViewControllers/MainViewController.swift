//
//  ViewController.swift
//  TR VPN
//
//  Created by Ilia Gusarov on 18.10.2022.
//

import UIKit
import Lottie

protocol ServerListViewControllerDelegate {
    func updateChosenServer(server: Server)
}

class MainViewController: UIViewController {
    
    private var server: Server!
            
    private let disconnectedNetworkAnimationView = LottieAnimationView()
    private let connectedNetworkAnimationView = LottieAnimationView()
    private let connectingToNetworkAnimationView = LottieAnimationView()
    private let succesfullyConnectedAnimationView = LottieAnimationView()
    private let succesfullyDisconnectedAnimationView = LottieAnimationView()
    
    private let connectButtonTapped: UIButton = {
        let button = UIButton()
        button.setTitle("Connect", for: .normal)
        button.backgroundColor = UIColor(red: 0/255, green: 106/255, blue: 183/255, alpha: 1)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let locationArrow: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "arrowtriangle.down.circle.fill"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .white
        return image
    }()
    
    private let locationChangeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 73/255, green: 137/255, blue: 183/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0/255, green: 42/255, blue: 72/255, alpha: 1)
        
        server = StorageManager.shared.fetchServer()
        
        configureNavbar()
        setupUI()
                            
        NotificationCenter.default.addObserver(self, selector: #selector(restartAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restartAnimation()
    }
    
    @objc private func restartAnimation() {
        disconnectedNetworkAnimationView.play()
        connectingToNetworkAnimationView.play()
        connectedNetworkAnimationView.play()
    }
}

// MARK: Button Actions

extension MainViewController {
    
    @objc private func connectButtonAction() {
        connectButtonTapped.animationButtonPressed()
        
        if VpnManager.shared.connectionStatus == .none || VpnManager.shared.connectionStatus == .disconnected {
            VpnManager.shared.establishVPNConnection(configName: server.configFile)
            
            print("Connecting")
            
            connectingToNetworkAnimationView.isHidden = false
            
            connectButtonTapped.setTitle("Connecting...", for: .normal)
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                if VpnManager.shared.connectionStatus == .connected {
                    timer.invalidate()
                    
                    self.changeAnimation(with: true)
                    
                    self.connectingToNetworkAnimationView.isHidden = true
                    self.succesfullyConnectedAnimationView.play() { _ in
                        self.succesfullyConnectedAnimationView.stop()
                    }
                    self.connectButtonTapped.setTitle("Connected", for: .normal)
                    print("Connected!")
                } else if VpnManager.shared.connectionStatus == .disconnected {
                    timer.invalidate()
                }
            }
        } else if VpnManager.shared.connectionStatus == .connected || VpnManager.shared.connectionStatus == .connecting {
            VpnManager.shared.stopConnection()

            print("Disconnecting")

            connectingToNetworkAnimationView.isHidden = true

            succesfullyDisconnectedAnimationView.play() { _ in
                self.succesfullyDisconnectedAnimationView.stop()
            }

            connectButtonTapped.setTitle("Disconnecting...", for: .normal)

            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if VpnManager.shared.connectionStatus == .disconnected {
                    timer.invalidate()
                    
                    self.changeAnimation(with: false)
                    
                    self.connectButtonTapped.setTitle("Connect", for: .normal)
                    print("Disconnected")
                }
            }
        }
        
    }
    
    @objc private func showServerList() {
        locationChangeButton.animationButtonPressed()
        let slVC = ServerListViewController()
        slVC.delegate = self
        present(slVC, animated: true)
    }
    
    @objc private func showSettings() {
        let slVC = SettingsViewController()
        navigationController?.pushViewController(slVC, animated: true)
    }
}

// MARK: Setup UI

extension MainViewController {
    
    private func configureNavbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "TR VPN", style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .done, target: self, action: #selector(showSettings))
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func setupUI() {
        
        setupAnimationView()
        setupAnimationConnectedView()
        setupConnectingView()
        setupConnectedView()
        setupCloseConnectionView()
                
        view.addSubview(locationChangeButton)
        
        locationLabel.text = server.region
        locationImage.image = UIImage(named: server.flag)
        
        locationChangeButton.addSubview(locationImage)
        locationChangeButton.addSubview(locationLabel)
        locationChangeButton.addSubview(locationArrow)
        locationChangeButton.addTarget(self, action: #selector(showServerList), for: .touchDown)
        
        connectButtonTapped.addTarget(self, action: #selector(connectButtonAction), for: .touchDown)
        view.addSubview(connectButtonTapped)
        
        applyConstraints()
    }
      
    private func setupAnimationView() {
        disconnectedNetworkAnimationView.animation = LottieAnimation.named("disconnectedView")
        disconnectedNetworkAnimationView.loopMode = .loop
        disconnectedNetworkAnimationView.contentMode = .scaleAspectFit
        disconnectedNetworkAnimationView.translatesAutoresizingMaskIntoConstraints = false
        disconnectedNetworkAnimationView.play()
        
        view.addSubview(disconnectedNetworkAnimationView)
    }
    
    private func setupAnimationConnectedView() {
        connectedNetworkAnimationView.animation = LottieAnimation.named("animationConnectedView")
        connectedNetworkAnimationView.loopMode = .loop
        connectedNetworkAnimationView.contentMode = .scaleAspectFit
        connectedNetworkAnimationView.translatesAutoresizingMaskIntoConstraints = false
        connectedNetworkAnimationView.alpha = 0
        connectedNetworkAnimationView.play()
        
        view.addSubview(connectedNetworkAnimationView)
    }
    
    private func setupConnectingView() {
        connectingToNetworkAnimationView.animation = LottieAnimation.named("connectingView")
        connectingToNetworkAnimationView.loopMode = .loop
        connectingToNetworkAnimationView.contentMode = .scaleAspectFit
        connectingToNetworkAnimationView.translatesAutoresizingMaskIntoConstraints = false
        connectingToNetworkAnimationView.play()
        connectingToNetworkAnimationView.isHidden = true
        
        disconnectedNetworkAnimationView.addSubview(connectingToNetworkAnimationView)
    }
    
    private func setupConnectedView() {
        succesfullyConnectedAnimationView.animation = LottieAnimation.named("connectedView")
        succesfullyConnectedAnimationView.loopMode = .repeatBackwards(1)
        succesfullyConnectedAnimationView.contentMode = .scaleAspectFit
        succesfullyConnectedAnimationView.translatesAutoresizingMaskIntoConstraints = false
        
        disconnectedNetworkAnimationView.addSubview(succesfullyConnectedAnimationView)
    }
    
    private func setupCloseConnectionView() {
        succesfullyDisconnectedAnimationView.animation = LottieAnimation.named("closeConnectionView")
        succesfullyDisconnectedAnimationView.contentMode = .scaleAspectFit
        succesfullyDisconnectedAnimationView.loopMode = .repeatBackwards(1)
        succesfullyDisconnectedAnimationView.translatesAutoresizingMaskIntoConstraints = false
        
        disconnectedNetworkAnimationView.addSubview(succesfullyDisconnectedAnimationView)
    }
    
    private func changeAnimation(with connect: Bool) {
        if connect {
            connectedNetworkAnimationView.fadeIn()
        } else {
            connectedNetworkAnimationView.fadeOut()
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            disconnectedNetworkAnimationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height / 6),
            disconnectedNetworkAnimationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            disconnectedNetworkAnimationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            disconnectedNetworkAnimationView.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
        ])
        
        NSLayoutConstraint.activate([
            connectedNetworkAnimationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height / 6),
            connectedNetworkAnimationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            connectedNetworkAnimationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            connectedNetworkAnimationView.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
        ])
        
        NSLayoutConstraint.activate([
            connectingToNetworkAnimationView.leadingAnchor.constraint(equalTo: disconnectedNetworkAnimationView.leadingAnchor, constant: 60),
            connectingToNetworkAnimationView.trailingAnchor.constraint(equalTo: disconnectedNetworkAnimationView.trailingAnchor, constant: -60),
            connectingToNetworkAnimationView.topAnchor.constraint(equalTo: disconnectedNetworkAnimationView.topAnchor, constant: 60),
            connectingToNetworkAnimationView.bottomAnchor.constraint(equalTo: disconnectedNetworkAnimationView.bottomAnchor, constant: -60)
        ])
        
        NSLayoutConstraint.activate([
            succesfullyConnectedAnimationView.leadingAnchor.constraint(equalTo: disconnectedNetworkAnimationView.leadingAnchor, constant: 15),
            succesfullyConnectedAnimationView.trailingAnchor.constraint(equalTo: disconnectedNetworkAnimationView.trailingAnchor, constant: -15),
            succesfullyConnectedAnimationView.topAnchor.constraint(equalTo: disconnectedNetworkAnimationView.topAnchor, constant: 15),
            succesfullyConnectedAnimationView.bottomAnchor.constraint(equalTo: disconnectedNetworkAnimationView.bottomAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            succesfullyDisconnectedAnimationView.leadingAnchor.constraint(equalTo: disconnectedNetworkAnimationView.leadingAnchor, constant: 60),
            succesfullyDisconnectedAnimationView.trailingAnchor.constraint(equalTo: disconnectedNetworkAnimationView.trailingAnchor, constant: -60),
            succesfullyDisconnectedAnimationView.topAnchor.constraint(equalTo: disconnectedNetworkAnimationView.topAnchor, constant: 60),
            succesfullyDisconnectedAnimationView.bottomAnchor.constraint(equalTo: disconnectedNetworkAnimationView.bottomAnchor, constant: -60)
        ])
        
        NSLayoutConstraint.activate([
            locationImage.leadingAnchor.constraint(equalTo: locationChangeButton.leadingAnchor, constant: 10),
            locationImage.topAnchor.constraint(equalTo: locationChangeButton.topAnchor, constant: 15),
            locationImage.bottomAnchor.constraint(equalTo: locationChangeButton.bottomAnchor, constant: -15),
            locationImage.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            locationLabel.leadingAnchor.constraint(equalTo: locationImage.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: locationArrow.trailingAnchor, constant: -10),
            locationLabel.topAnchor.constraint(equalTo: locationChangeButton.topAnchor, constant: 5),
            locationLabel.bottomAnchor.constraint(equalTo: locationChangeButton.bottomAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            locationArrow.trailingAnchor.constraint(equalTo: locationChangeButton.trailingAnchor, constant: -15),
            locationArrow.topAnchor.constraint(equalTo: locationChangeButton.topAnchor, constant: 15),
            locationArrow.bottomAnchor.constraint(equalTo: locationChangeButton.bottomAnchor, constant: -15),
            locationArrow.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            NSLayoutConstraint.activate([
                connectButtonTapped.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                connectButtonTapped.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
                connectButtonTapped.topAnchor.constraint(equalTo: locationChangeButton.bottomAnchor, constant: 10),
                connectButtonTapped.heightAnchor.constraint(equalToConstant: 50)
            ])
            
            NSLayoutConstraint.activate([
                locationChangeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                locationChangeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
                locationChangeButton.topAnchor.constraint(equalTo: disconnectedNetworkAnimationView.bottomAnchor, constant: 50),
                locationChangeButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            let width = view.frame.size.width / 3
            NSLayoutConstraint.activate([
                connectButtonTapped.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                connectButtonTapped.topAnchor.constraint(equalTo: locationChangeButton.bottomAnchor, constant: 10),
                connectButtonTapped.heightAnchor.constraint(equalToConstant: 50),
                connectButtonTapped.widthAnchor.constraint(equalToConstant: width)
            ])
            
            NSLayoutConstraint.activate([
                locationChangeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                locationChangeButton.topAnchor.constraint(equalTo: disconnectedNetworkAnimationView.bottomAnchor, constant: 50),
                locationChangeButton.heightAnchor.constraint(equalToConstant: 50),
                locationChangeButton.widthAnchor.constraint(equalToConstant: width)
            ])
        }
        
    }
}

extension MainViewController: ServerListViewControllerDelegate {
    func updateChosenServer(server: Server) {
        locationLabel.text = server.region
        locationImage.image = UIImage(named: server.flag)
        StorageManager.shared.save(server: server)
    }
}
