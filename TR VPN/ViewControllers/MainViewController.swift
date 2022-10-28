//
//  ViewController.swift
//  TR VPN
//
//  Created by Илья Гусаров on 18.10.2022.
//

import UIKit
import NetworkExtension
import Lottie

class MainViewController: UIViewController {
    
    var manager: NETunnelProviderManager?
    
    let animationView = LottieAnimationView()
    let animationConnectedView = LottieAnimationView()
    let connectingView = LottieAnimationView()
    let connectedView = LottieAnimationView()
    let closeConnectionView = LottieAnimationView()
    
    let connectButtonTapped: UIButton = {
        let button = UIButton()
        button.setTitle("Connect", for: .normal)
        button.backgroundColor = UIColor(red: 0/255, green: 106/255, blue: 183/255, alpha: 1)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Russia, Moscow"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "location"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let locationArrow: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "arrowtriangle.down.circle.fill"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .white
        return image
    }()
    
    let locationChangeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 73/255, green: 137/255, blue: 183/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0/255, green: 42/255, blue: 72/255, alpha: 1)
        
        setupUI()
        
        configureNavbar()
                
        NotificationCenter.default.addObserver(self, selector: #selector(restartAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.play()
        connectingView.play()
        animationConnectedView.play()
    }
    
    @objc private func restartAnimation() {
        animationView.play()
        connectingView.play()
        animationConnectedView.play()
    }
    
    // MARK: Button Action
    
    @objc private func buttonAction() {
        connectButtonTapped.buttonPressed()
        if manager?.connection.status == .none || manager?.connection.status == .disconnected {
            establishVPNConnection()
            
            print("Connecting")
            
            connectingView.isHidden = false
            
            connectButtonTapped.setTitle("Connecting...", for: .normal)
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                if self.manager?.connection.status == .connected {
                    
                    self.changeAnimation(with: true)
                    
                    timer.invalidate()
                    self.connectingView.isHidden = true
                    self.connectedView.play() { _ in
                        self.connectedView.stop()
                    }
                    self.connectButtonTapped.setTitle("Connected", for: .normal)
                    print("Connected!")
                } else if self.manager?.connection.status == .disconnected {
                    timer.invalidate()
                }
            }
        } else if manager?.connection.status == .connected || manager?.connection.status == .connecting {
            stopConnection()

            print("Disconnecting")

            connectingView.isHidden = true

            closeConnectionView.play() { _ in
                self.closeConnectionView.stop()
                self.connectedView.stop()
            }

            connectButtonTapped.setTitle("Disconnecting...", for: .normal)

            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if self.manager?.connection.status == .disconnected {
                    
                    self.changeAnimation(with: false)
                    
                    timer.invalidate()
                    self.connectButtonTapped.setTitle("Connect", for: .normal)
                    print("Disconnected")
                }
            }
        }
        
    }
    
    private func changeAnimation(with connect: Bool) {
        
        if connect {
            animationConnectedView.fadeIn()
        } else {
            animationConnectedView.fadeOut()
        }
    }
}

// MARK: Setup UI

extension MainViewController {
    
    private func configureNavbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "TR VPN", style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .done, target: self, action: #selector(showSettings))
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupUI() {
        
        setupAnimationView()
        setupAnimationConnectedView()
        setupConnectingView()
        setupConnectedView()
        setupCloseConnectionView()
                
        view.addSubview(locationChangeButton)
        locationChangeButton.addSubview(locationImage)
        locationChangeButton.addSubview(locationLabel)
        locationChangeButton.addSubview(locationArrow)
        locationChangeButton.addTarget(self, action: #selector(showServerList), for: .touchDown)
        
        connectButtonTapped.addTarget(self, action: #selector(buttonAction), for: .touchDown)
        view.addSubview(connectButtonTapped)
        
        applyConstraints()
    }
    
    @objc private func showServerList() {
        locationChangeButton.buttonPressed()
        let slVC = UINavigationController(rootViewController: ServerListViewController())
        present(slVC, animated: true)
    }
    
    @objc private func showSettings() {
        let slVC = SettingsViewController()
        navigationController?.pushViewController(slVC, animated: true)
    }
    
    private func setupAnimationView() {
        animationView.animation = LottieAnimation.named("95680-purple-circle")
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.play()
        
        view.addSubview(animationView)
    }
    
    private func setupAnimationConnectedView() {
        animationConnectedView.animation = LottieAnimation.named("7227-vui-animation")
        animationConnectedView.loopMode = .loop
        animationConnectedView.contentMode = .scaleAspectFit
        animationConnectedView.translatesAutoresizingMaskIntoConstraints = false
        animationConnectedView.alpha = 0
        animationConnectedView.play()
        
        view.addSubview(animationConnectedView)
    }
    
    private func setupConnectingView() {
        connectingView.animation = LottieAnimation.named("122729-vibecity-loader")
        connectingView.loopMode = .loop
        connectingView.contentMode = .scaleAspectFit
        connectingView.translatesAutoresizingMaskIntoConstraints = false
        connectingView.play()
        connectingView.isHidden = true
        
        animationView.addSubview(connectingView)
    }
    
    private func setupConnectedView() {
        connectedView.animation = LottieAnimation.named("5785-checkmark")
        connectedView.loopMode = .repeatBackwards(1)
        connectedView.contentMode = .scaleAspectFit
        connectedView.translatesAutoresizingMaskIntoConstraints = false
        
        animationView.addSubview(connectedView)
    }
    
    private func setupCloseConnectionView() {
        closeConnectionView.animation = LottieAnimation.named("97670-tomato-error")
        closeConnectionView.contentMode = .scaleAspectFit
        closeConnectionView.loopMode = .repeatBackwards(1)
        closeConnectionView.translatesAutoresizingMaskIntoConstraints = false
        
        animationView.addSubview(closeConnectionView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height / 6),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            animationView.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
        ])
        
        NSLayoutConstraint.activate([
            animationConnectedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height / 6),
            animationConnectedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            animationConnectedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            animationConnectedView.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
        ])
        
        NSLayoutConstraint.activate([
            connectingView.leadingAnchor.constraint(equalTo: animationView.leadingAnchor, constant: 60),
            connectingView.trailingAnchor.constraint(equalTo: animationView.trailingAnchor, constant: -60),
            connectingView.topAnchor.constraint(equalTo: animationView.topAnchor, constant: 60),
            connectingView.bottomAnchor.constraint(equalTo: animationView.bottomAnchor, constant: -60)
        ])
        
        NSLayoutConstraint.activate([
            connectedView.leadingAnchor.constraint(equalTo: animationView.leadingAnchor, constant: 15),
            connectedView.trailingAnchor.constraint(equalTo: animationView.trailingAnchor, constant: -15),
            connectedView.topAnchor.constraint(equalTo: animationView.topAnchor, constant: 15),
            connectedView.bottomAnchor.constraint(equalTo: animationView.bottomAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            closeConnectionView.leadingAnchor.constraint(equalTo: animationView.leadingAnchor, constant: 60),
            closeConnectionView.trailingAnchor.constraint(equalTo: animationView.trailingAnchor, constant: -60),
            closeConnectionView.topAnchor.constraint(equalTo: animationView.topAnchor, constant: 60),
            closeConnectionView.bottomAnchor.constraint(equalTo: animationView.bottomAnchor, constant: -60)
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
        
        
        //Settings of buttons
        if UIDevice.current.userInterfaceIdiom == .phone {
            NSLayoutConstraint.activate([
                connectButtonTapped.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                connectButtonTapped.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
                connectButtonTapped.topAnchor.constraint(equalTo: locationChangeButton.bottomAnchor, constant: 20),
                connectButtonTapped.heightAnchor.constraint(equalToConstant: 50)
            ])
            
            NSLayoutConstraint.activate([
                locationChangeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                locationChangeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
                locationChangeButton.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 50),
                locationChangeButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            let width = view.frame.size.width / 3
            NSLayoutConstraint.activate([
                connectButtonTapped.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                connectButtonTapped.topAnchor.constraint(equalTo: locationChangeButton.bottomAnchor, constant: 20),
                connectButtonTapped.heightAnchor.constraint(equalToConstant: 50),
                connectButtonTapped.widthAnchor.constraint(equalToConstant: width)
            ])
            
            NSLayoutConstraint.activate([
                locationChangeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                locationChangeButton.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 50),
                locationChangeButton.heightAnchor.constraint(equalToConstant: 50),
                locationChangeButton.widthAnchor.constraint(equalToConstant: width)
            ])
        }
        
    }
}

// MARK: Here is connecting to VPN

extension MainViewController {

    private func establishVPNConnection() {
        let callback = { (error: Error?) -> Void in
            self.manager?.loadFromPreferences(completionHandler: { (error) in
                guard error == nil else {
                    print("\(error!.localizedDescription)")
                    return
                }
                
//                let options: [String : NSObject] = [
//                    "username": "" as NSString,
//                    "password": "" as NSString
//                ]
                
                do {
                    try self.manager?.connection.startVPNTunnel()
                } catch {
                    print("\(error.localizedDescription)")
                }
            })
        }
        
        configureVPN(configName: "leyns", callback: callback)
    }
    
    func stopConnection() {
        manager?.connection.stopVPNTunnel()
    }
    
    func configureVPN(configName: String, callback: @escaping (Error?) -> Void) {
        let configurationFile = Bundle.main.url(forResource: configName, withExtension: "ovpn")
        let configurationContent = try! Data(contentsOf: configurationFile!)

        NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
            guard error == nil else {
                print("\(error!.localizedDescription)")
                callback(error)
                return
            }
            
            self.manager = managers?.first ?? NETunnelProviderManager()
            self.manager?.loadFromPreferences(completionHandler: { (error) in
                guard error == nil else {
                    print("\(error!.localizedDescription)")
                    callback(error)
                    return
                }
                
                let tunnelProtocol = NETunnelProviderProtocol()
                tunnelProtocol.serverAddress = ""
                tunnelProtocol.providerBundleIdentifier = "com.iliagusarov.TR-VPN.tunnel"
                tunnelProtocol.providerConfiguration = ["configuration": configurationContent]
                tunnelProtocol.disconnectOnSleep = false
                
                self.manager?.protocolConfiguration = tunnelProtocol
                self.manager?.localizedDescription = "TR VPN"
                
                self.manager?.isEnabled = true
                
                self.manager?.saveToPreferences(completionHandler: { (error) in
                    guard error == nil else {
                        print("\(error!.localizedDescription)")
                        callback(error)
                        return
                    }
                    
                    callback(nil)
                })
            })
        }
    }
    
}
