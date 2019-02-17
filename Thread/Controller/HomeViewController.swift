//
//  HomeViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/16/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit
import TabbedPageView

class HomeViewController: SlideOutMenuViewController, Storyboarded {

    @IBOutlet weak var tabbedPageView: TabbedPageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabbedPageView()
    }
    
    fileprivate func setupTabbedPageView() {
        tabbedPageView.isManualScrollingEnabled = false
        tabbedPageView.tabBar.position = .bottom
        tabbedPageView.tabBar.sliderColor = .black
        tabbedPageView.tabBar.transitionStyle = .sticky
        tabbedPageView.tabBar.height = 40
        
        tabbedPageView.delegate = self
        tabbedPageView.dataSource = self
        tabbedPageView.reloadData()
    }
}



extension HomeViewController: TabbedPageViewDelegate {
    
}



extension HomeViewController: TabbedPageViewDataSource {
    
    var tabs: [Tab] {
        
        let tabAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 14)!
        ]
        
        let redView = UIView()
        redView.backgroundColor = .ultraLightRed
        
        let blueView = UIView()
        blueView.backgroundColor = .ultraLightBlue
        
        let greenView = UIView()
        greenView.backgroundColor = .ultraLightGreen
        
        return [
            Tab(view: redView, type: .attributedText(NSAttributedString(string: "EXPLORE", attributes: tabAttributes))),
            Tab(view: blueView, type: .attributedText(NSAttributedString(string: "HOME", attributes: tabAttributes))),
            Tab(view: greenView, type: .attributedText(NSAttributedString(string: "AROUND ME", attributes: tabAttributes)))
        ]
    }
    
    func tabbedPageView(_ tabbedPageView: TabbedPageView, tabForIndex index: Int) -> Tab {
        return tabs[index]
    }
    
    func numberOfTabs(in tabbedPageView: TabbedPageView) -> Int {
        return tabs.count
    }
}
