//
//  Extension+UIApplication.swift
//  TR VPN
//
//  Created by Ilia Gusarov on 28.10.2022.
//

import UIKit

extension UIApplication {
    static var appVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

