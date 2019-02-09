//
//  UserProfileSummaryView.swift
//  FirebaseAuth
//
//  Created by Michael Onjack on 2/2/19.
//

import UIKit

class UserProfileSummaryView: UIView {
    
    var lastCheckIn:String = "" {
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
    var status: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.statusLabel.attributedText = self.createSummaryLabelString(title: "Status: ", subtitle: self.status)
            }
        }
    }
    
    var summaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.font = UIFont(name: "AvenirNext-Medium", size: 16.0)
        label.text = "Summary"
        
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
    
    var statusLabel: UILabel = {
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
        statusLabel.attributedText = createSummaryLabelString(title: "Status: ", subtitle: "")
        
        labelStackView = UIStackView(arrangedSubviews: [checkInLabel, locationLabel, statusLabel])
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .vertical
        labelStackView.distribution = .fillEqually
        
        addSubview(summaryLabel)
        addSubview(labelStackView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            summaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            summaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            summaryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            summaryLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
            
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelStackView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 15),
            labelStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.60)
        ])
    }
    
    fileprivate func createSummaryLabelString(title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 13)!
        ]
        
        let subtitleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 13)!
        ]
        
        let mutableStr = NSMutableAttributedString()
        mutableStr.append( NSAttributedString(string: title, attributes: titleAttributes) )
        mutableStr.append( NSAttributedString(string: subtitle, attributes: subtitleAttributes) )
        
        return mutableStr
    }
}
