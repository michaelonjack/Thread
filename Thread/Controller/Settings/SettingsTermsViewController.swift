//
//  SettingsTermsViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/24/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class SettingsTermsViewController: UIViewController {
    
    weak var coordinator: ActiveUserCoordinator?
    
    var navigationHeader: NavigationHeaderView = {
        let navHeader = NavigationHeaderView()
        navHeader.translatesAutoresizingMaskIntoConstraints = false
        navHeader.previousViewLabel.text = "Settings"
        navHeader.currentViewLabel.text = "Terms of Service"
        
        return navHeader
    }()
    
    var contentView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = true
        
        return sv
    }()
    
    var termsLabel: UILabel = {
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
        contentView.addSubview(termsLabel)
        
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
            
            termsLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            termsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            termsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            termsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
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
        mutableStr.append(NSAttributedString(string: "By using Thread or any of its associated services, you agree to the Terms of Service. Of course, if you don’t agree with them, then don’t use Thread.\n\n\n", attributes: bodyAttributes))
        mutableStr.append(NSAttributedString(string: "Who Can Use Thread\n", attributes: headerAttributes))
        mutableStr.append(NSAttributedString(string: "By using this application you state that:\n\na) You are not a person who is barred from receiving the Services under the laws of the United States or any other applicable jurisdiction—meaning that you do not appear on the U.S. Treasury Department’s list of Specially Designated Nationals or face any other similar prohibition.\n\nb) You will comply with these Terms and all applicable local, state, national, and international laws, rules, and regulations.\n\n\n", attributes: bodyAttributes))
        mutableStr.append(NSAttributedString(string: "Content\n", attributes: headerAttributes))
        mutableStr.append(NSAttributedString(string: "Much of the content on Thread is produced by users. Whether that content is posted publicly or sent privately, the content is the sole responsibility of the person or organization that submitted it. Although Thread reserves the right to review or remove all content that appears on the application, we do not necessarily review all of it. So we cannot—and do not—take responsibility for any content that others provide through the application.\n\nWe want to make clear that we do not want the application put to bad uses. But because we do not review all content, we cannot guarantee that content on the application will always conform to our preferred guidelines.\n\n\n", attributes: bodyAttributes))
        mutableStr.append(NSAttributedString(string: "Respecting Other People’s Rights\n", attributes: headerAttributes))
        mutableStr.append(NSAttributedString(string: "Thread respects the rights of others. And so should you. You therefore may not use the application, or enable anyone else to use the application, in a manner that:\na) violates or infringes someone else’s rights of publicity, privacy, copyright, trademark, or other intellectual-property right.\nb) bullies, harasses, or intimidates.\nc) defames.\nd) spams or solicits our users.\n\nViolating these conditions may result in the suspension of your account upon review.\n\n\n\n\n\n\n\n\n\n", attributes: bodyAttributes))
        
        termsLabel.attributedText = mutableStr
    }
    
    @objc func returnToSettings() {
        coordinator?.pop()
    }
}
