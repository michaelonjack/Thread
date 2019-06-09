//
//  ClothingItemEditView.swift
//  Thread
//
//  Created by Michael Onjack on 2/9/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ClothingItemEditView: UIView {
    
    var mainLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
        l.adjustsFontSizeToFitWidth = true
        l.textColor = .black
        l.text = "Item Info"
        l.font = UIFont(name: "AvenirNext-Regular", size: 23.0)
        
        return l
    }()
    
    var mainScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.keyboardDismissMode = .onDrag
        
        return sv
    }()
    
    var nameField: UnderlinedTextFieldView = {
        let field = UnderlinedTextFieldView(contentType: .name, placeHolder: "name")
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textField.textAlignment = .left
        
        return field
    }()
    
    var brandField: UnderlinedTextFieldView = {
        let field = UnderlinedTextFieldView(contentType: .name, placeHolder: "brand name")
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textField.textAlignment = .left
        
        return field
    }()
    
    var priceField: UnderlinedTextFieldView = {
        let field = UnderlinedTextFieldView(contentType: UITextContentType.name, placeHolder: "price")
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textField.textAlignment = .left
        field.textField.keyboardType = .decimalPad
        
        return field
    }()
    
    var linkField: UnderlinedTextFieldView = {
        let field = UnderlinedTextFieldView(contentType: .URL, placeHolder: "link to item")
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textField.textAlignment = .left
        field.textField.autocapitalizationType = UITextAutocapitalizationType.none
        
        return field
    }()
    
    var tagsLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
        l.adjustsFontSizeToFitWidth = true
        l.textColor = .black
        l.text = "Tags"
        l.font = UIFont(name: "AvenirNext-Regular", size: 19.0)
        
        return l
    }()
    
    var tagsField: UnderlinedTextFieldView = {
        let field = UnderlinedTextFieldView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textField.placeholder = "tag name"
        field.textField.textAlignment = .left
        field.textField.autocapitalizationType = UITextAutocapitalizationType.none
        
        return field
    }()
    
    var addTagButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 14.0)
        
        return button
    }()
    
    var tagsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        
        var cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isPagingEnabled = false
        cv.backgroundColor = .white
        cv.register(ClosetTagCollectionViewCell.self, forCellWithReuseIdentifier: "TagCell")
        
        return cv
    }()
    
    var detailsLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
        l.adjustsFontSizeToFitWidth = true
        l.textColor = .black
        l.text = "Extra Details"
        l.font = UIFont(name: "AvenirNext-Regular", size: 19.0)
        
        return l
    }()
    
    var detailsField: UITextView = {
        let field = UITextView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textColor = .black
        field.textAlignment = .left
        field.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.borderWidth = 1
        field.tintColor = .black
        
        return field
    }()
    
    var tags: [ClothingItemTag] = []
    
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
        
        mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width, height: mainScrollView.frame.height * 3)
    }
    
    fileprivate func setupView() {
        
        addSubview(mainScrollView)
        mainScrollView.addSubview(mainLabel)
        mainScrollView.addSubview(nameField)
        mainScrollView.addSubview(brandField)
        mainScrollView.addSubview(priceField)
        mainScrollView.addSubview(linkField)
        mainScrollView.addSubview(tagsLabel)
        mainScrollView.addSubview(tagsField)
        mainScrollView.addSubview(addTagButton)
        mainScrollView.addSubview(tagsCollectionView)
        mainScrollView.addSubview(detailsLabel)
        mainScrollView.addSubview(detailsField)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            mainLabel.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 30),
            mainLabel.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: 16),
            mainLabel.widthAnchor.constraint(equalToConstant: frame.width * 0.75),
            mainLabel.heightAnchor.constraint(equalToConstant: 40),
            
            nameField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 15),
            nameField.leadingAnchor.constraint(equalTo: mainLabel.leadingAnchor),
            nameField.widthAnchor.constraint(equalTo: mainLabel.widthAnchor),
            nameField.heightAnchor.constraint(equalTo: mainLabel.heightAnchor),
            
            brandField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 30),
            brandField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            brandField.widthAnchor.constraint(equalTo: nameField.widthAnchor),
            brandField.heightAnchor.constraint(equalTo: nameField.heightAnchor),
            
            priceField.topAnchor.constraint(equalTo: brandField.bottomAnchor, constant: 30),
            priceField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            priceField.widthAnchor.constraint(equalTo: nameField.widthAnchor),
            priceField.heightAnchor.constraint(equalTo: nameField.heightAnchor),
            
            linkField.topAnchor.constraint(equalTo: priceField.bottomAnchor, constant: 30),
            linkField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            linkField.widthAnchor.constraint(equalTo: nameField.widthAnchor),
            linkField.heightAnchor.constraint(equalTo: nameField.heightAnchor),
            
            tagsLabel.topAnchor.constraint(equalTo: linkField.bottomAnchor, constant: 30),
            tagsLabel.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            tagsLabel.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            tagsLabel.heightAnchor.constraint(equalTo: nameField.heightAnchor),
            
            tagsField.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 10),
            tagsField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            tagsField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            tagsField.heightAnchor.constraint(equalTo: nameField.heightAnchor),
            
            addTagButton.centerYAnchor.constraint(equalTo: tagsField.centerYAnchor),
            addTagButton.heightAnchor.constraint(equalTo: tagsField.heightAnchor, multiplier: 0.7),
            addTagButton.widthAnchor.constraint(equalToConstant: frame.width * 0.15),
            addTagButton.leadingAnchor.constraint(equalTo: tagsField.trailingAnchor, constant: 8),
            
            tagsCollectionView.topAnchor.constraint(equalTo: tagsField.bottomAnchor, constant: 10),
            tagsCollectionView.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            tagsCollectionView.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            tagsCollectionView.heightAnchor.constraint(equalToConstant: 100),
            
            detailsLabel.topAnchor.constraint(equalTo: tagsCollectionView.bottomAnchor, constant: 30),
            detailsLabel.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            detailsLabel.widthAnchor.constraint(equalTo: nameField.widthAnchor),
            detailsLabel.heightAnchor.constraint(equalTo: nameField.heightAnchor),
            
            detailsField.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 15),
            detailsField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            detailsField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            detailsField.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
