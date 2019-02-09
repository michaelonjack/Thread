//
//  SignUpView.swift
//  Thread
//
//  Created by Michael Onjack on 2/6/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class SignUpView: UIView {
    
    var signupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "sign up"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Regular", size: 30.0)
        
        return label
    }()
    
    var signupButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("sign up", for: .normal)
        button.backgroundColor = .red
        
        return button
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitle("cancel", for: .normal)
        
        return button
    }()
    
    var firstNameField: UnderlinedTextFieldView = {
        let field = UnderlinedTextFieldView(contentType: UITextContentType.givenName, placeHolder: "first name")
        field.translatesAutoresizingMaskIntoConstraints = false
        
        return field
    }()
    
    var lastNameField: UnderlinedTextFieldView = {
        let field = UnderlinedTextFieldView(contentType: UITextContentType.familyName, placeHolder: "last name")
        field.translatesAutoresizingMaskIntoConstraints = false
        
        return field
    }()
    
    var emailField: UnderlinedTextFieldView = {
        let field = UnderlinedTextFieldView(contentType: .emailAddress, placeHolder: "email")
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textField.autocapitalizationType = UITextAutocapitalizationType.none
        
        return field
    }()
    
    var passwordField: UnderlinedTextFieldView = {
        let field = UnderlinedTextFieldView(contentType: .password, placeHolder: "password")
        field.translatesAutoresizingMaskIntoConstraints = false
        
        return field
    }()
    
    var confirmPasswordField: UnderlinedTextFieldView = {
        let field = UnderlinedTextFieldView(contentType: .password, placeHolder: "confirm password")
        field.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        signupButton.layer.cornerRadius = signupButton.frame.height / 6.0
        signupButton.clipsToBounds = true
    }
    
    fileprivate func setupView() {
        
        addSubview(signupLabel)
        addSubview(firstNameField)
        addSubview(lastNameField)
        addSubview(emailField)
        addSubview(passwordField)
        addSubview(confirmPasswordField)
        addSubview(signupButton)
        addSubview(cancelButton)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            signupLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            signupLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
            signupLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            
            firstNameField.topAnchor.constraint(equalTo: signupLabel.bottomAnchor, constant: 30),
            firstNameField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            firstNameField.widthAnchor.constraint(equalTo: emailField.widthAnchor, multiplier: 0.48),
            firstNameField.heightAnchor.constraint(equalToConstant: 30),
            
            lastNameField.topAnchor.constraint(equalTo: firstNameField.topAnchor),
            lastNameField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            lastNameField.widthAnchor.constraint(equalTo: firstNameField.widthAnchor),
            lastNameField.heightAnchor.constraint(equalTo: firstNameField.heightAnchor),
            
            emailField.topAnchor.constraint(equalTo: lastNameField.bottomAnchor, constant: 15),
            emailField.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
            emailField.heightAnchor.constraint(equalTo: firstNameField.heightAnchor),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 15),
            passwordField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordField.widthAnchor.constraint(equalTo: emailField.widthAnchor),
            passwordField.heightAnchor.constraint(equalTo: firstNameField.heightAnchor),
            
            confirmPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 15),
            confirmPasswordField.centerXAnchor.constraint(equalTo: centerXAnchor),
            confirmPasswordField.widthAnchor.constraint(equalTo: passwordField.widthAnchor),
            confirmPasswordField.heightAnchor.constraint(equalTo: firstNameField.heightAnchor),
            
            signupButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signupButton.widthAnchor.constraint(equalTo: confirmPasswordField.widthAnchor),
            signupButton.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: 30),
            signupButton.heightAnchor.constraint(equalToConstant: 60),
            
            cancelButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            cancelButton.widthAnchor.constraint(equalTo: signupButton.widthAnchor),
            cancelButton.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: 10),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            
            bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 30)
        ])
    }
}
