//
//  ExploreViewController.swift
//  Thread
//
//  Created by Michael Onjack on 5/22/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController, Storyboarded {
    
    weak var coordinator: ActiveUserCoordinator?

    @IBOutlet weak var exploreView: ExploreMainView!
    
    var showLocationAnimationController: UIViewControllerAnimatedTransitioning?
    var hideLocationAnimationController: UIViewControllerAnimatedTransitioning?
    
    var searchResults: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        exploreView.locationsCollectionView.delegate = self
        exploreView.locationsCollectionView.dataSource = self
        exploreView.locationsCollectionView.keyboardDismissMode = .onDrag
        
        exploreView.searchBarView.searchBarView.textField.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
        
        navigationController?.delegate = self
        
        loadPlaces()
    }
    
    fileprivate func loadPlaces() {
        getPlaces { (places) in
            configuration.places = places
            self.searchResults = places
            
            for place in places {
                
                // Update the place's weather data if it's been over 20 minutes since the last update
                if place.minutesSinceLastUpdate > 20 {
                    APIHelper.getCurrentWeather(for: place, completion: { (result) in
                        switch result {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .success(let weatherData):
                            place.updateWeather(using: weatherData)
                        }
                    })
                }
            }
            
            DispatchQueue.main.async {
                self.exploreView.locationsCollectionView.reloadData()
            }
        }
    }
    
    @objc func searchTextChanged(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        var newSearchResults: [Place] = []
        
        // Require at least 3 characters to be entered
        if searchText.count < 3 {
            newSearchResults = configuration.places
        }
        
        else {
            newSearchResults = configuration.places.filter {
                $0.name.lowercased().range(of: searchText.lowercased()) != nil
            }
        }
        
        let difference = Set(searchResults).symmetricDifference( Set(newSearchResults) )
        
        // Only reload the collection if the results have actually changed
        if !difference.isEmpty {
            searchResults = newSearchResults
            DispatchQueue.main.async {
                self.exploreView.locationsCollectionView.reloadData()
            }
        }
    }
}



extension ExploreViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let _ = toVC as? LocationViewController { /* good - the toVC is a LocationViewController */ }
        else if let _ = fromVC as? LocationViewController { /* good - the fromVC is a LocationViewController */ }
        else { return nil }
        
        switch operation {
        case .push:
            return showLocationAnimationController
        case .pop:
            return hideLocationAnimationController
        default:
            return nil
        }
    }
}



extension ExploreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? ExploreLocationCollectionViewCell else { return }
        guard let cvAttributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        
        view.endEditing(true)
        
        let selectedFrame = collectionView.convert(cvAttributes.frame, to: collectionView.superview)
        
        showLocationAnimationController = ShowLocationAnimationController(originFrame: selectedFrame, locationImage: selectedCell.imageView.image)
        hideLocationAnimationController = HideLocationAnimationController(originFrame: selectedFrame)
        
        coordinator?.viewLocation(location: searchResults[indexPath.row])
    }
}



extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCell", for: indexPath)
        
        guard let imageCell = cell as? ExploreLocationCollectionViewCell else { return cell }
        
        let location = searchResults[indexPath.row]
        imageCell.imageView.contentMode = .scaleAspectFill
        
        location.getImage { (image) in
            DispatchQueue.main.async {
                imageCell.imageView.image = image
            }
        }
        
        return imageCell
    }
}



extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.95, height: collectionView.frame.height * 0.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
}
