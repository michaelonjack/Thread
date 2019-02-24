//
//  SettingsPolicyViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/24/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class SettingsPolicyViewController: UIViewController {
    
    weak var coordinator: ActiveUserCoordinator?
    
    var navigationHeader: NavigationHeaderView = {
        let navHeader = NavigationHeaderView()
        navHeader.translatesAutoresizingMaskIntoConstraints = false
        navHeader.previousViewLabel.text = "Settings"
        navHeader.currentViewLabel.text = "Privacy Policy"
        
        return navHeader
    }()
    
    var contentView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = true
        sv.isScrollEnabled = true
        
        return sv
    }()
    
    var policyLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        
        return l
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
        
        navigationHeader.backButton.addTarget(self, action: #selector(returnToSettings), for: .touchUpInside)
        
        setTermsLabelText()
        
        view.addSubview(navigationHeader)
        view.addSubview(contentView)
        contentView.addSubview(policyLabel)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            navigationHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationHeader.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.11),
            
            contentView.topAnchor.constraint(equalTo: navigationHeader.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            policyLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            policyLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            policyLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            policyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    fileprivate func setTermsLabelText() {
        let headerAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 20)!
        ]
        
        let bodyAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 15)!
        ]
        
        let mutableStr = NSMutableAttributedString()
        mutableStr.append(NSAttributedString(string: "Last updated: February 24, 2019\n\n", attributes: bodyAttributes))
        mutableStr.append(NSAttributedString(string: "When you use Thread, you’ll share some information with us. So we want to be upfront about the information we collect, how we use it and the controls we give you to access, update, and delete your information.\n\n\n", attributes: bodyAttributes))
        mutableStr.append(NSAttributedString(string: "Information We Collect\n", attributes: headerAttributes))
        mutableStr.append(NSAttributedString(string: "When you interact with Thread, we collect the information that you choose to share with us. For example, Thread requires you to set up a basic account, so we need to collect a few important details about you, such as: a name, a password, and an email address. You can also optionally provide a profile picture, your location, and details about your clothing items.\n\nThread does not collect any information about you from third parties.\n\n\n", attributes: bodyAttributes))
        mutableStr.append(NSAttributedString(string: "How We Use the Information\n", attributes: headerAttributes))
        mutableStr.append(NSAttributedString(string: "The information you share with Thread will only be used within the app itself; viewable by you and other users. If you choose to enable Location Services, your location will only be used to find nearby users and only while the app is in use.\n\nYour data will not be shared with third parties in the form of advertising tools or analytic services.\n\n\n", attributes: bodyAttributes))
        mutableStr.append(NSAttributedString(string: "Control Over Your Information\n", attributes: headerAttributes))
        mutableStr.append(NSAttributedString(string: "Thread will retain your data until you decide to remove or modify it. All information we collect on you can be viewed/modified from the Settings screen which is accessed through pressing the cogwheel button. Should you choose to add a profile picture, it can be modified by tapping your picture on the app's home screen.\n\n\n", attributes: bodyAttributes))
        mutableStr.append(NSAttributedString(string: "Revisions to the Privacy Policy\n", attributes: headerAttributes))
        mutableStr.append(NSAttributedString(string: "We may change this Privacy Policy from time to time. But when we do, we’ll let you know one way or another. Sometimes, we’ll let you know by revising the date at the top of the Privacy Policy that’s available here. Other times, we may provide you with additional notice (such as providing you with an in-app notification).\n\n\n\n\n\n\n\n\n", attributes: bodyAttributes))
        
        policyLabel.attributedText = mutableStr
    }
    
    @objc func returnToSettings() {
        coordinator?.pop()
    }
}
