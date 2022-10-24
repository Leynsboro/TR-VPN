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
        label.text = "Moscow, Russia"
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
    
    lazy var locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [self.locationImage,
            self.locationLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0/255, green: 42/255, blue: 72/255, alpha: 1)
        
        setupUI()
        
        configureNavbar()
                
        NotificationCenter.default.addObserver(self, selector: #selector(restartAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func restartAnimation() {
        animationView.play()
        connectingView.play()
    }
    
    // MARK: Button Action
    
    @objc private func buttonAction() {
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
                    self.animationView.animation = LottieAnimation.named("95680-purple-circle")
                    self.animationView.play()
                    timer.invalidate()
                    self.connectButtonTapped.setTitle("Connect", for: .normal)
                    print("Disconnected")
                }
            }
        }
        
    }
    
    private func changeAnimation(with connect: Bool) {
        if connect {
            animationView.fadeOut(2, delay: 0) { _ in
                self.animationView.animation = LottieAnimation.named("7227-vui-animation")
                self.animationView.play()
                self.animationView.fadeIn()
            }
        } else {
            animationView.animation = LottieAnimation.named("95680-purple-circle")
        }
    }
}

// MARK: Setup UI

extension MainViewController {
    
    private func configureNavbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "TR VPN", style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .done, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupUI() {
        
        setupAnimationView()
        setupConnectingView()
        setupConnectedView()
        setupCloseConnectionView()
        
        view.addSubview(locationStackView)
        
        connectButtonTapped.addTarget(self, action: #selector(buttonAction), for: .touchDown)
        view.addSubview(connectButtonTapped)
        
        applyConstraints()
    }
    
    private func setupAnimationView() {
        animationView.animation = LottieAnimation.named("95680-purple-circle")
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.play()
        
        view.addSubview(animationView)
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
            locationStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationStackView.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 50),
            locationStackView.heightAnchor.constraint(equalToConstant: 20),
            locationStackView.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            NSLayoutConstraint.activate([
                connectButtonTapped.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                connectButtonTapped.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
                connectButtonTapped.topAnchor.constraint(equalTo: locationStackView.bottomAnchor, constant: 50),
                connectButtonTapped.heightAnchor.constraint(equalToConstant: 50)
            ])
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            let width = view.frame.size.width / 3
            NSLayoutConstraint.activate([
                connectButtonTapped.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                connectButtonTapped.topAnchor.constraint(equalTo: locationStackView.bottomAnchor, constant: 50),
                connectButtonTapped.heightAnchor.constraint(equalToConstant: 50),
                connectButtonTapped.widthAnchor.constraint(equalToConstant: width)
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
