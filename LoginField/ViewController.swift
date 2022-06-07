//
//  ViewController.swift
//  LoginField
//
//  Created by deniss.lobacs on 07/06/2022.
//

import UIKit

class ViewController: UIViewController {
    
    let stackView = UIStackView()
    let loginField = LoginField()
    let passwordField = LoginField()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .systemBackground
        
        configFields()
        configItems()
    }

    func configFields() {
        passwordField.type = .password
    }
    
    func configItems() {
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(loginField)
       
        stackView.addArrangedSubview(passwordField)
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(50)
        }
    }

}

