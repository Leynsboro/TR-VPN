//
//  StorageManager.swift
//  TR VPN
//
//  Created by Ilia Gusarov on 14.11.2022.
//

import Foundation

class StorageManager {
    
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let key = "chosenServer"
    
    func save(server: Server) {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(server)
        userDefaults.set(data, forKey: key)
    }
    
    func fetchServer() -> Server {
        guard let server = userDefaults.object(forKey: key) as? Data else {
            return Server.getServers()[3]
        }
        let decoder = JSONDecoder()
        let data = try! decoder.decode(Server.self, from: server)
        return data
    }
}
