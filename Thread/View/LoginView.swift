//
//  LoginView.swift
//  Thread
//
//  Created by Michael Onjack on 2/6/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "log in"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Regular", size: 30.0)
        
        return label
    }()
    
    var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("log in", for: .normal)
        button.backgroundColor = .red
        
        return button
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("cancel", for: .normal)
        
        return button
    }()
    
    var emailField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.adjustsFontSizeToFitWidth = true
        field.borderStyle = UITextField.BorderStyle.none
        field.textContentType = UITextContentType.emailAddress
        field.backgroundColor = .white
        field.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
        
        return field
    }()
    
    var passwordField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.adjustsFontSizeToFitWidth = true
        field.borderStyle = UITextField.BorderStyle.none
        field.textContentType = UITextContentType.password
        field.isSecureTextEntry = true
        field.backgroundColor = .white
        field.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
        
        return field
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 10.0
        clipsToBounds = true
        
        loginButton.layer.cornerRadius = loginButton.frame.height / 2.0
        loginButton.clipsToBounds = true
    }
    
    fileprivate func setupView() {
        
        addSubview(loginLabel)
        addSubview(emailField)
        addSubview(passwordField)
        addSubview(loginButton)
        addSubview(cancelButton)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            loginLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
            loginLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            
            emailField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 30),
            emailField.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 15),
            passwordField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordField.widthAnchor.constraint(equalTo: emailField.widthAnchor),
            
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: passwordField.widthAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            loginButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),
            
            cancelButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            cancelButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor),
            cancelButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15),
            cancelButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.11)
        ])
    }
}
