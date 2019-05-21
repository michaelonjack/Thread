//
//  HomeViewController+TabbedPageView.swift
//  Thread
//
//  Created by Michael Onjack on 3/9/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit
import TabbedPageView

extension HomeViewController: TabbedPageViewDelegate {
    
}



extension HomeViewController: TabbedPageViewDataSource {
    
    var tabs: [Tab] {
        
        let tabAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 14)!
        ]
        
        return [
            Tab(contentSource: .view(exploreView), type: .attributedText(NSAttributedString(string: "EXPLORE", attributes: tabAttributes))),
            Tab(contentSource: .view(homeView), type: .attributedText(NSAttributedString(string: "HOME", attributes: tabAttributes))),
            Tab(contentSource: .view(aroundMeView), type: .attributedText(NSAttributedString(string: "AROUND ME", attributes: tabAttributes)))
        ]
    }
    
    func tabbedPageView(_ tabbedPageView: TabbedPageView, tabForIndex index: Int) -> Tab {
        return tabs[index]
    }
    
    func numberOfTabs(in tabbedPageView: TabbedPageView) -> Int {
        return tabs.count
    }
}
