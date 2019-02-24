//
//  SettingsPasswordViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/24/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class SettingsPasswordViewController: UIViewController {
    
    weak var coordinator: ActiveUserCoordinator?
    
    var navigationHeader: NavigationHeaderView = {
        let navHeader = NavigationHeaderView()
        navHeader.translatesAutoresizingMaskIntoConstraints = false
        navHeader.previousViewLabel.text = "Settings"
        navHeader.currentViewLabel.text = "Update Password"
        
        return navHeader
    }()
    
    var currentPasswordTextField: UnderlinedTextFieldView = {
        var tf = UnderlinedTextFieldView(contentType: UITextContentType.password, placeHolder: "current password")
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textField.textAlignment = .left
        tf.textField.autocapitalizationType = .none
        
        return tf
    }()
    
    var newPasswordTextField: UnderlinedTextFieldView = {
        var tf = UnderlinedTextFieldView(contentType: UITextContentType.password, placeHolder: "new password")
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textField.textAlignment = .left
        tf.textField.autocapitalizationType = .none
        
        return tf
    }()
    
    var confirmTextField: UnderlinedTextFieldView = {
        var tf = UnderlinedTextFieldView(contentType: UITextContentType.password, placeHolder: "confirm new password")
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textField.textAlignment = .left
        tf.textField.autocapitalizationType = .none
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    fileprivate func setupView() {
        view.backgroundColor = .white
        
        navigationHeader.backButton.addTarget(self, action: #selector(cancelUpdate), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(finishUpdatingPassword), for: .touchUpInside)
        
        updateButton.layer.cornerRadius = view.frame.height * 0.1 / 5
        
        view.addSubview(navigationHeader)
        view.addSubview(currentPasswordTextField)
        view.addSubview(newPasswordTextField)
        view.addSubview(confirmTextField)
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
            
            currentPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currentPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            currentPasswordTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.2),
            currentPasswordTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
            
            newPasswordTextField.leadingAnchor.constraint(equalTo: currentPasswordTextField.leadingAnchor),
            newPasswordTextField.trailingAnchor.constraint(equalTo: currentPasswordTextField.trailingAnchor),
            newPasswordTextField.topAnchor.constraint(equalTo: currentPasswordTextField.bottomAnchor, constant: 20),
            newPasswordTextField.heightAnchor.constraint(equalTo: currentPasswordTextField.heightAnchor),
            
            confirmTextField.leadingAnchor.constraint(equalTo: currentPasswordTextField.leadingAnchor),
            confirmTextField.trailingAnchor.constraint(equalTo: currentPasswordTextField.trailingAnchor),
            confirmTextField.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 20),
            confirmTextField.heightAnchor.constraint(equalTo: currentPasswordTextField.heightAnchor),
            
            updateResultLabel.leadingAnchor.constraint(equalTo: currentPasswordTextField.leadingAnchor),
            updateResultLabel.trailingAnchor.constraint(equalTo: currentPasswordTextField.trailingAnchor),
            updateResultLabel.topAnchor.constraint(equalTo: confirmTextField.bottomAnchor, constant: 10),
            
            updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            updateButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            updateButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            updateButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ])
    }
    
    @objc func cancelUpdate() {
        coordinator?.pop()
    }
    
    @objc func finishUpdatingPassword() {
        updateResultLabel.text = ""
        let currentPassword = currentPasswordTextField.textField.text ?? ""
        let newPassword = newPasswordTextField.textField.text ?? ""
        let confirmPassword = confirmTextField.textField.text ?? ""
        
        if currentPassword.isEmpty {
            DispatchQueue.main.async {
                self.updateResultLabel.text = "Current Password is required."
            }
            return
        }
        
        if newPassword.isEmpty {
            DispatchQueue.main.async {
                self.updateResultLabel.text = "New Password is required."
            }
            return
        }
        
        if confirmPassword.isEmpty {
            DispatchQueue.main.async {
                self.updateResultLabel.text = "You must confirm your new password to continue."
            }
            return
        }
        
        if newPassword != confirmPassword {
            DispatchQueue.main.async {
                self.updateResultLabel.text = "Your confirmed password does not match your new password."
            }
            return
        }
        
        coordinator?.finishEditingPassword(currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword)
    }
}
