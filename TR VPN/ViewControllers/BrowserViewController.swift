//
//  BrowserViewController.swift
//  TR VPN
//
//  Created by Илья Гусаров on 27.10.2022.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let webURL = URL(string:  "https://instagram.com/ilia.leynsboro") else { return }
        
        UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
    }

}
