//
//  UserProfileSummaryView.swift
//  FirebaseAuth
//
//  Created by Michael Onjack on 2/2/19.
//

import UIKit

class UserProfileSummaryView: UIView {
    
    var status: String = "" {
        didSet {
            if status.count == 0 {
                labelStackView.removeArrangedSubview(statusLabel)
            } else {
                DispatchQueue.main.async {
                    self.statusLabel.text = self.status
                }
            }
        }
    }
    var lastCheckIn: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.checkInLabel.attributedText = self.createSummaryLabelString(title: "Last checked in ", subtitle: self.lastCheckIn)
            }
        }
    }
    var location: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.locationLabel.attributedText = self.createSummaryLabelString(title: "Location: ", subtitle: self.location)
            }
        }
    }
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "AvenirNext-Medium", size: 30.0)
        
        return label
    }()
    
    var statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        
        return label
    }()
    
    var checkInLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    var labelStackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        
        checkInLabel.attributedText = createSummaryLabelString(title: "Last checked in ", subtitle: "")
        locationLabel.attributedText = createSummaryLabelString(title: "Location: ", subtitle: "")
        
        labelStackView = UIStackView(arrangedSubviews: [nameLabel, statusLabel, checkInLabel, locationLabel])
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .vertical
        labelStackView.distribution = .fillEqually
        
        addSubview(labelStackView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.85)
        ])
    }
    
    fileprivate func createSummaryLabelString(title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 15)!
        ]
        
        let subtitleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 14)!
        ]
        
        let mutableStr = NSMutableAttributedString()
        mutableStr.append( NSAttributedString(string: title, attributes: titleAttributes) )
        mutableStr.append( NSAttributedString(string: subtitle, attributes: subtitleAttributes) )
        
        return mutableStr
    }
}
