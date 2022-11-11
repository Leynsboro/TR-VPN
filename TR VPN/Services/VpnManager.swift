//
//  vpnManager.swift
//  TR VPN
//
//  Created by Ilia Gusarov on 9.11.2022.
//

import Foundation
import NetworkExtension

class VpnManager {
    
    var manager: NETunnelProviderManager?
    
    static let shared = VpnManager()
    
    var connectionStatus: NEVPNStatus? {
        manager?.connection.status
    }
    
    private init() {}
    
    func establishVPNConnection(configName: String) {
        let callback = { (error: Error?) -> Void in
            self.manager?.loadFromPreferences(completionHandler: { (error) in
                guard error == nil else {
                    print("\(error!.localizedDescription)")
                    return
                }
                
//                If you set a password on server
//                let options: [String : NSObject] = [
//                    "username": "" as NSString,
//                    "password": "" as NSString
//                ]
                
                do {
                    try self.manager?.connection.startVPNTunnel()
//                    try self.manager?.connection.startVPNTunnel(options: options)
                } catch {
                    print("\(error.localizedDescription)")
                }
            })
        }
        
        configureVPN(configName: configName, callback: callback)
    }
    
    func stopConnection() {
        manager?.connection.stopVPNTunnel()
    }
    
    private func configureVPN(configName: String, callback: @escaping (Error?) -> Void) {
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
