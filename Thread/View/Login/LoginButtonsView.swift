//
//  LoginButtonsView.swift
//  Thread
//
//  Created by Michael Onjack on 2/6/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class LoginButtonsView: UIView {
    
    var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("log in", for: .normal)
        
        return button
    }()
    
    var signupButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("sign up", for: .normal)
        
        return button
    }()
    
    var buttonsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 10.0
        clipsToBounds = true
        
        loginButton.layer.cornerRadius = buttonsContainerView.frame.height / 6.0
        loginButton.clipsToBounds = true
        
        signupButton.layer.cornerRadius = buttonsContainerView.frame.height / 6.0
        signupButton.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        
        buttonsContainerView.addSubview(loginButton)
        buttonsContainerView.addSubview(signupButton)
        addSubview(buttonsContainerView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            buttonsContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            buttonsContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonsContainerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            buttonsContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),
            
            loginButton.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor),
            loginButton.topAnchor.constraint(equalTo: buttonsContainerView.topAnchor),
            loginButton.bottomAnchor.constraint(equalTo: buttonsContainerView.bottomAnchor),
            loginButton.widthAnchor.constraint(equalTo: buttonsContainerView.widthAnchor, multiplier: 0.48),
            
            signupButton.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor),
            signupButton.topAnchor.constraint(equalTo: buttonsContainerView.topAnchor),
            signupButton.bottomAnchor.constraint(equalTo: buttonsContainerView.bottomAnchor),
            signupButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor)
        ])
    }
}
