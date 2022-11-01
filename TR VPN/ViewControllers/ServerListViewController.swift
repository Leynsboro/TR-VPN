//
//  ServerListViewController.swift
//  TR VPN
//
//  Created by Илья Гусаров on 25.10.2022.
//

import UIKit

class ServerListViewController: UIViewController {
    
    private let firstTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Oooops..."
        label.font = label.font.withSize(24)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "So far we have only one server"
        label.font = label.font.withSize(18)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        [firstTitleLabel,
         descriptionLabel].forEach { stack.addArrangedSubview($0) }
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0/255, green: 40/255, blue: 68/255, alpha: 1)
    
        view.addSubview(labelsStackView)        
        
        setNavBar()
        applyConstraints()
    }
                                                            
    @objc private func closeView() {
        dismiss(animated: true)
    }
    
    private func setNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeView))
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            labelsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            labelsStackView.widthAnchor.constraint(equalToConstant: view.frame.width / 2)
        ])
    }
 

}
