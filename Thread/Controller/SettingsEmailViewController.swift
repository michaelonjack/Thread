//
//  SettingsEmailViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/23/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class SettingsEmailViewController: UIViewController {
    
    weak var coordinator: ActiveUserCoordinator?
    
    var navigationHeader: NavigationHeaderView = {
        let navHeader = NavigationHeaderView()
        navHeader.translatesAutoresizingMaskIntoConstraints = false
        navHeader.previousViewLabel.text = "Settings"
        navHeader.currentViewLabel.text = "Update Email"
        
        return navHeader
    }()
    
    var emailTextField: UnderlinedTextFieldView = {
        var tf = UnderlinedTextFieldView(contentType: UITextContentType.emailAddress, placeHolder: "email")
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textField.textAlignment = .left
        tf.textField.autocapitalizationType = .none
        tf.textField.text = configuration.currentUser?.email
        
        return tf
    }()
    
    var updateResultLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.textColor = .red
        l.numberOfLines = 2
        l.font = UIFont(name: "AvenirNext-Regular", size: 11.0)
        
        return l
    }()
    
    var updateButton: UIButton = {
        var b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Update", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .black
        b.clipsToBounds = true
        
        return b
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func setupView() {
        
        view.backgroundColor = .white
        
        navigationHeader.backButton.addTarget(self, action: #selector(cancelUpdate), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(finishUpdatingEmail), for: .touchUpInside)
        
        updateButton.layer.cornerRadius = view.frame.height * 0.1 / 5
        
        view.addSubview(navigationHeader)
        view.addSubview(emailTextField)
        view.addSubview(updateResultLabel)
        view.addSubview(updateButton)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            navigationHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationHeader.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.11),
            
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.2),
            emailTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
            
            updateResultLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            updateResultLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            updateResultLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5),
            
            updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            updateButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            updateButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            updateButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ])
    }
    
    @objc func finishUpdatingEmail() {
        guard let email = emailTextField.textField.text else { return }
        updateResultLabel.text = ""
        
        coordinator?.finishEditingEmail(email: email)
    }
    
    @objc func cancelUpdate() {
        coordinator?.pop()
    }
}
