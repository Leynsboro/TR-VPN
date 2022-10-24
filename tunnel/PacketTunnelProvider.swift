//
//  PacketTunnelProvider.swift
//  OpenVPN Tunnel Provider
//
//  Created by Sergey Abramchuk on 18/03/2019.
//  Copyright © 2019 Sergey Abramchuk. All rights reserved.
//

import NetworkExtension
import OpenVPNAdapter

class PacketTunnelProvider: NEPacketTunnelProvider {
    
    var startHandler: ((Error?) -> Void)?
    var stopHandler: (() -> Void)?
    
    let vpnReachability = OpenVPNReachability()
    
    lazy var vpnAdapter: OpenVPNAdapter = {
        return OpenVPNAdapter().then {
            $0.delegate = self
        }
    }()
    
    override func startTunnel(options: [String : NSObject]? = nil, completionHandler: @escaping (Error?) -> Void) {
//        let _ = DispatchSemaphore(value: 0).wait(timeout: .now() + 20)
        
        guard let protocolConfiguration = protocolConfiguration as? NETunnelProviderProtocol else {
            fatalError("protocolConfiguration should be an instance of the NETunnelProviderProtocol class")
        }
        
        // We need providerConfiguration dictionary to retrieve content of the OpenVPN configuration file.
        // Other options related to the tunnel provider also can be stored there.
        guard let providerConfiguration = protocolConfiguration.providerConfiguration else {
            preconditionFailure("providerConfiguration should be provided to the tunnel provider")
        }
        
        //
        guard let fileContent = providerConfiguration["configuration"] as? Data else {
            preconditionFailure("fileContent should be provided to the tunnel provider")
        }
        
        // Create presentation of the OpenVPN configuration. Other properties such as connection timeout or
        // private key password aslo may be provided there.
        let vpnConfiguration = OpenVPNConfiguration().then {
            $0.fileContent = fileContent
            $0.tunPersist = false
        }
        
        // Apply OpenVPN configuration.
        let properties: OpenVPNConfigurationEvaluation
        do {
            properties = try vpnAdapter.apply(configuration: vpnConfiguration)
        } catch {
            completionHandler(error)
            return
        }
        
        if !properties.autologin {
            guard let username = options?["username"] as? String, let password = options?["password"] as? String else {
                fatalError()
            }
            
            let credentials = OpenVPNCredentials().then {
                $0.username = username
                $0.password = password
            }
            
            do {
                try vpnAdapter.provide(credentials: credentials)
            } catch {
                completionHandler(error)
                return
            }
        }
        
        vpnReachability.startTracking { [weak self] status in
            guard status == .reachableViaWiFi else { return }
            self?.vpnAdapter.reconnect(afterTimeInterval: 5)
        }
        
        startHandler = completionHandler
        vpnAdapter.connect(using: self)
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        stopHandler = completionHandler
        vpnAdapter.disconnect()
    }
    
}

extension PacketTunnelProvider: OpenVPNAdapterDelegate {
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, configureTunnelWithNetworkSettings networkSettings: NEPacketTunnelNetworkSettings?, completionHandler: @escaping (Error?) -> Void) {
        networkSettings?.dnsSettings?.matchDomains = [""]
        setTunnelNetworkSettings(networkSettings, completionHandler: completionHandler)
    }
    
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleEvent event: OpenVPNAdapterEvent, message: String?) {
        NSLog("[Event] \(event)")
        
        if let message = message {
            NSLog("[Message] \(message)");
        }
        
        switch event {
        case .connected:
            if reasserting {
                reasserting = false
            }
            
            guard let startHandler = startHandler else {
                return
            }
            
            startHandler(nil)
            self.startHandler = nil
            
        case .disconnected:
            guard let stopHandler = stopHandler else {
                return
            }
            
            stopHandler()
            self.stopHandler = nil
            
        case .reconnecting:
            reasserting = true
            
        default:
            break
        }
    }
    
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleError error: Error) {
        NSLog("[Error] \(error)")
        
        guard let fatal = (error as NSError).userInfo[OpenVPNAdapterErrorFatalKey] as? Bool, fatal == true else {
            return
        }
        
        if let startHandler = startHandler {
            startHandler(error)
            self.startHandler = nil
        } else {
            cancelTunnelWithError(error)
        }
    }
    
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleLogMessage logMessage: String) {
        NSLog("[Log] \(logMessage)")
    }
    
}

extension PacketTunnelProvider: OpenVPNAdapterPacketFlow {
    
    func readPackets(completionHandler: @escaping ([Data], [NSNumber]) -> Void) {
        packetFlow.readPackets(completionHandler: completionHandler)
    }
    
    func writePackets(_ packets: [Data], withProtocols protocols: [NSNumber]) -> Bool {
        return packetFlow.writePackets(packets, withProtocols: protocols)
    }
    
}

