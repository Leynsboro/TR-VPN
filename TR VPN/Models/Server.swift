//
//  Server.swift
//  TR VPN
//
//  Created by Ilia Gusarov on 10.11.2022.
//

import Foundation

struct Server: Codable {
    let region: String!
    let configFile: String!
    let flag: String!
    
    static func getServers() -> [Server] {
        let servers: [Server] = [
            Server(region: "Berlin, Germany", configFile: "yourConfig", flag: "germanyFlag"),
            Server(region: "New-York, USA", configFile: "yourConfig", flag: "usaFlag"),
            Server(region: "Madrid, Spain", configFile: "yourConfig", flag: "spainFlag"),
            Server(region: "Moscow, Russia", configFile: "yourConfig", flag: "russiaFlag")
        ]
        return servers
    }
}
