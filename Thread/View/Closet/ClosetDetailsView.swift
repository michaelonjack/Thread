//
//  ClosetDetailsView.swift
//
//
//  Created by Michael Onjack on 2/3/19.
//

import UIKit
import TabbedPageView

class ClosetDetailsView: UIView {
    
    var detailsView: ClosetDetailsTextView = {
        let view = ClosetDetailsTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var tagsView: ClosetDetailsTagsView = {
        let view = ClosetDetailsTagsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var otherView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        return view
    }()
    
    var tabbedView: TabbedPageView!
    var tabs: [Tab]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        let tabAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 10)!
        ]
        
        tabs = [
            Tab(contentSource: .view(detailsView), type: .attributedText(NSAttributedString(string: "DETAILS", attributes: tabAttributes))),
            Tab(contentSource: .view(tagsView), type: .attributedText(NSAttributedString(string: "TAGS", attributes: tabAttributes))),
            Tab(contentSource: .view(otherView), type: .attributedText(NSAttributedString(string: "OTHER", attributes: tabAttributes))),
        ]
        
        tabbedView = TabbedPageView(frame: CGRect.zero)
        tabbedView.translatesAutoresizingMaskIntoConstraints = false
        tabbedView.backgroundColor = .white
        tabbedView.tabBar.position = .top
        tabbedView.tabBar.sliderColor = .black
        tabbedView.tabBar.transitionStyle = .sticky
        tabbedView.tabBar.height = 40
        
        tabbedView.delegate = self
        tabbedView.dataSource = self
        tabbedView.reloadData()
        
        addSubview(tabbedView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            tabbedView.topAnchor.constraint(equalTo: topAnchor),
            tabbedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tabbedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabbedView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}



extension ClosetDetailsView: TabbedPageViewDelegate {
    
}



extension ClosetDetailsView: TabbedPageViewDataSource {
    func tabbedPageView(_ tabbedPageView: TabbedPageView, tabForIndex index: Int) -> Tab {
        return tabs[index]
    }
    
    func numberOfTabs(in tabbedPageView: TabbedPageView) -> Int {
        return tabs.count
    }
    
    
}
