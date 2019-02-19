//
//  ExploreLocationTopView.swift
//  Thread
//
//  Created by Michael Onjack on 2/18/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ExploreLocationExpandedView: UIView {
    
    var locationImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    var detailsView: ExploreLocationDetailsView = {
        let v = ExploreLocationDetailsView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.alpha = 0
        
        return v
    }()
    
    var closeButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.alpha = 0
        b.setImage(UIImage(named: "X"), for: .normal)
        
        return b
    }()
    
    var originalCellFrame: CGRect!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        originalCellFrame = frame
        locationImageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        locationImageView.layer.cornerRadius = frame.height / 5.0
        locationImageView.clipsToBounds = true
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        
        backgroundColor = .clear
        
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        addSubview(locationImageView)
        addSubview(closeButton)
        addSubview(detailsView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        
        NSLayoutConstraint.activate([
            locationImageView.topAnchor.constraint(equalTo: topAnchor),
            locationImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            locationImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            closeButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            
            detailsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            detailsView.topAnchor.constraint(equalTo: locationImageView.bottomAnchor),
            detailsView.heightAnchor.constraint(equalTo: locationImageView.heightAnchor)
        ])
    }
    
    @objc func close() {
        animateClosing()
    }
    
    func removeParentConstraints() {
        guard let superview = superview else { return }
        
        // Deactivate the current constraints
        superview.constraints.forEach { (constraint) in
            guard let firstItem = constraint.firstItem as? UIView else { return }
            guard let secondItem = constraint.secondItem as? UIView else { return }
            
            if firstItem == self || secondItem == self {
                constraint.isActive = false
            }
        }
    }
    
    func setOpenConstraints() {
        guard let superview = superview else { return }
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }
    
    func setClosedConstraints() {
        guard let superview = superview else { return }
        
        removeParentConstraints()
        
        // Activate new constraints to set it in the original position
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: originalCellFrame.minY),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: originalCellFrame.minX),
            widthAnchor.constraint(equalToConstant: originalCellFrame.width),
            heightAnchor.constraint(equalToConstant: originalCellFrame.height)
        ])
    }
    
    func animateOpening() {
        guard let superview = superview else { return }
        
        setOpenConstraints()
        
        UIView.animate(withDuration: 1.5, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.closeButton.alpha = 1
            superview.layoutIfNeeded()
        }, completion: { (_) in
            
            self.detailsView.alpha = 1
            
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
                let viewHeight = self?.frame.height ?? 600
                let translationY = viewHeight * 0.55
                
                self?.detailsView.transform = CGAffineTransform(translationX: 0, y: -translationY)
                self?.locationImageView.transform = CGAffineTransform(translationX: 0, y: -translationY / 2)
            })
        })
    }
    
    func animateClosing() {
        guard let superview = superview else { return }
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            
            self?.detailsView.transform = .identity
            self?.locationImageView.transform = .identity
            
        }) { [weak self] (_) in
            
            self?.detailsView.alpha = 0
            self?.setClosedConstraints()
            
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
                self?.closeButton.alpha = 0
                superview.layoutIfNeeded()
                }, completion: { [weak self ](_) in
                    self?.removeFromSuperview()
            })
        }
    }
}
