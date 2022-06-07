//
//  LoginField.swift
//  LoginField
//
//  Created by deniss.lobacs on 07/06/2022.
//

import Foundation
import SnapKit
import UIKit

enum FieldType: Int {
    case login = 0
    case password = 1
}

class LoginField: UIView {
    
    var type: FieldType = .login {
        didSet {
            switch self.type.rawValue {
            case 0: useLoginField()
            case 1: usePasswordField()
            default: break
            }
        }
    }
    
    let bottomLine = CALayer()
    let label = UILabel()
    let textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addLabel()
        addTextField()
        
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBottomLine()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 60)
    }
    
    private func useLoginField() {
        textField.isSecureTextEntry = false
        textField.returnKeyType = .next
    }
    
    private func usePasswordField() {
        label.text = "Passowrd"
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.placeholder = "Password"
    }
}

//MARK: - Style

extension LoginField {
    
    func addBottomLine() {
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - 2, width: self.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.systemGray.cgColor
        
        layer.addSublayer(bottomLine)
    }
    
    func addLabel() {
        addSubview(label)
        
        label.text = "Email"
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.isHidden = true
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.left.equalToSuperview()
        }
    }
    
    func addTextField() {
        addSubview(textField)
        
        textField.tintColor = .systemCyan
        textField.textColor = .systemCyan
        textField.placeholder = "Email"
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        textField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
}

//MARK: - Actions

private extension LoginField {
    
    @objc func textFieldDidChange() {
        makeValidation()
    }
    
    func makeLabelAnimated() {
        if textField.text?.count == 0 {
            textField.resignFirstResponder()
            textField.placeholder = ""
            label.fadeIn()
        } else {
            label.isHidden = false
        }
    }
    
    func makeValidation() {
        guard let text = textField.text else { return }
        
        if text.count > 0 {
            
            if type.rawValue == 0 {
                if isValidEmail(text) {
                    bottomLine.backgroundColor = UIColor.systemGreen.cgColor
                    label.textColor = .systemGreen
                } else {
                    bottomLine.backgroundColor = UIColor.systemRed.cgColor
                    label.textColor = .systemRed
                }
                
            } else if type.rawValue == 1 {
                if isValidPassword(text) {
                    bottomLine.backgroundColor = UIColor.systemGreen.cgColor
                    label.textColor = .systemGreen
                } else {
                    bottomLine.backgroundColor = UIColor.systemRed.cgColor
                    label.textColor = .systemRed
                }
            }
        } else {
            bottomLine.backgroundColor = UIColor.systemGray.cgColor
            label.textColor = .black
        }
    }
    
    private func isValidPassword(_ pass: String) -> Bool {
        if pass.count > 5 {
            return true
        } else {
            return false
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}

//MARK: TextField Delegate

extension LoginField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        makeLabelAnimated()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        
        let text = type.rawValue == 0 ? "Email" : "Password"
        label.fadeOut(textField: textField, text: text)

        
        return true
    }
    
}
