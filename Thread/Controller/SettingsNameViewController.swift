//
//  SettingsNameViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/23/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class SettingsNameViewController: UIViewController {
    
    weak var coordinator: ActiveUserCoordinator?
    
    var navigationHeader: NavigationHeaderView = {
        let navHeader = NavigationHeaderView()
        navHeader.translatesAutoresizingMaskIntoConstraints = false
        
        return navHeader
    }()
    
    var firstNameTextField: UnderlinedTextFieldView = {
        var tf = UnderlinedTextFieldView()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textField.placeholder = "first name"
        tf.textField.textAlignment = .left
        tf.textField.text = configuration.currentUser?.firstName
        
        return tf
    }()
    
    var lastNameTextField: UnderlinedTextFieldView = {
        var tf = UnderlinedTextFieldView()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textField.placeholder = "last name"
        tf.textField.textAlignment = .left
        tf.textField.text = configuration.currentUser?.lastName
        
        return tf
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
        updateButton.addTarget(self, action: #selector(finishUpdatingName), for: .touchUpInside)
        
        updateButton.layer.cornerRadius = view.frame.height * 0.1 / 5
        navigationHeader.previousViewLabel.text = "Settings"
        navigationHeader.currentViewLabel.text = "Update Name"
        
        view.addSubview(navigationHeader)
        view.addSubview(firstNameTextField)
        view.addSubview(lastNameTextField)
        view.addSubview(updateButton)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            navigationHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationHeader.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.11),
            
            firstNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            firstNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            firstNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.2),
            firstNameTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),

            lastNameTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            lastNameTextField.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 32),
            lastNameTextField.heightAnchor.constraint(equalTo: firstNameTextField.heightAnchor),

            updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            updateButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            updateButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            updateButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ])
    }
    
    @objc func finishUpdatingName() {
        guard let firstName = firstNameTextField.textField.text else { return }
        guard let lastName = lastNameTextField.textField.text else { return }
        
        coordinator?.finishEditingUserName(firstName: firstName, lastName: lastName)
    }
    
    @objc func cancelUpdate() {
        coordinator?.pop()
    }
}
