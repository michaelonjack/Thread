//
//  UnderlinedTextFieldView.swift
//  Thread
//
//  Created by Michael Onjack on 2/7/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class UnderlinedTextFieldView: UIView {
    
    var textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.adjustsFontSizeToFitWidth = true
        field.borderStyle = UITextField.BorderStyle.none
        field.textAlignment = .center
        field.tintColor = .black
        field.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
        
        return field
    }()
    
    var textFieldUnderlineTrace: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        return view
    }()
    
    var textFieldUnderlineWidthConstraint: NSLayoutConstraint!
    var textFieldUnderline: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        
        return view
    }()
    
    init(contentType: UITextContentType, placeHolder: String) {
        super.init(frame: CGRect.zero)
        
        textField.placeholder = placeHolder
        textField.textContentType = contentType
        if contentType == UITextContentType.password {
            textField.isSecureTextEntry = true
        }
        
        textField.delegate = self
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textField.delegate = self
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        
        addSubview(textField)
        addSubview(textFieldUnderlineTrace)
        addSubview(textFieldUnderline)
        
        textFieldUnderlineWidthConstraint = textFieldUnderline.widthAnchor.constraint(equalToConstant: 0)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: textFieldUnderline.topAnchor),
            
            textFieldUnderlineTrace.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            textFieldUnderlineTrace.widthAnchor.constraint(equalTo: textField.widthAnchor),
            textFieldUnderlineTrace.bottomAnchor.constraint(equalTo: bottomAnchor),
            textFieldUnderlineTrace.heightAnchor.constraint(equalToConstant: 2.0),
            
            textFieldUnderline.leadingAnchor.constraint(equalTo: textFieldUnderlineTrace.leadingAnchor),
            textFieldUnderlineWidthConstraint,
            textFieldUnderline.bottomAnchor.constraint(equalTo: textFieldUnderlineTrace.bottomAnchor),
            textFieldUnderline.heightAnchor.constraint(equalTo: textFieldUnderlineTrace.heightAnchor)
        ])
    }
}



extension UnderlinedTextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.textFieldUnderlineWidthConstraint.isActive = false
            self.textFieldUnderlineWidthConstraint = self.textFieldUnderline.widthAnchor.constraint(equalTo: self.textField.widthAnchor)
            self.textFieldUnderlineWidthConstraint.isActive = true
            self.layoutSubviews()
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.textFieldUnderlineWidthConstraint.isActive = false
            self.textFieldUnderlineWidthConstraint = self.textFieldUnderline.widthAnchor.constraint(equalToConstant: 0)
            self.textFieldUnderlineWidthConstraint.isActive = true
            self.layoutSubviews()
        })
    }
}
