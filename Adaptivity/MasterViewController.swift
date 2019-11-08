//
//  ViewController.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 15/12/2015.
//  Copyright © 2015 Darjeeling Apps. All rights reserved.
//

import UIKit

private let PresentCountyWithAnimationSegueIdentifier = "PresentCountyWithAnimation"
private let PresentCountyWithNoAnimationSegueIdentifier = "PresentCountyWithNoAnimation"

/// The view controller responsible for displaying the county collection view.
class MasterViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet fileprivate var flowLayout: UICollectionViewFlowLayout!
    var selectedCounty: County?
    fileprivate var spotlightSearchController = SpotlightSearchController()
    internal var countiesToDisplay: [County] {
        guard let searchText = searchController.searchBar.text, searchText.count > 0 else {
            return County.allCounties
        }
        return spotlightSearchController.searchResults
    }
    var history: CountyHistory?
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func showCounty(_ county: County, animated: Bool) {
        selectedCounty = county
        history?.viewed(county)
        let segueIdentifier = animated ? PresentCountyWithAnimationSegueIdentifier : PresentCountyWithNoAnimationSegueIdentifier
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    func beginSearch(withText searchText: String? = nil) {
        searchController.searchBar.becomeFirstResponder()
        if let searchText = searchText {
            searchController.searchBar.text = searchText
            updateSearchResults(forSearchText: searchText)
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        if styleForTraitCollection(newCollection) != styleForTraitCollection(traitCollection) {
            collectionView.reloadData() // Reload cells to adopt the new style
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if styleForTraitCollection(traitCollection) == .table {
            flowLayout.invalidateLayout() // Called to update the cell sizes to fit the new collection view width
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
            let countyViewController = navigationController.topViewController as? CountyViewController {
                countyViewController.county = selectedCounty
                countyViewController.delegate = self
        }
    }
    
    // MARK: Private Methods
    fileprivate func styleForTraitCollection(_ traitCollection: UITraitCollection) -> CountyCellDisplayStyle {
        return traitCollection.horizontalSizeClass == .regular ? .grid : .table
    }
}

// MARK: UICollectionViewDataSource
extension MasterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countiesToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let countyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountyCell", for: indexPath) as! CountyCell
        countyCell.county = countiesToDisplay[indexPath.row]
        countyCell.displayStyle = styleForTraitCollection(traitCollection)
        return countyCell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension MasterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return styleForTraitCollection(traitCollection).itemSizeInCollectionView(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return styleForTraitCollection(traitCollection).collectionViewEdgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return styleForTraitCollection(traitCollection).collectionViewLineSpacing
    }
}

// MARK: UICollectionViewDelegate
extension MasterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showCounty(countiesToDisplay[collectionView.indexPathsForSelectedItems!.first!.item], animated: true)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

// MARK: UISearchResultsUpdating
extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        updateSearchResults(forSearchText: searchController.searchBar.text)
    }
    
    fileprivate func updateSearchResults(forSearchText searchText: String?) {
        spotlightSearchController.search(withQueryString: searchText ?? "") { [unowned self] in
            self.collectionView.reloadData()
        }
    }
}

// MARK: CountyViewControllerDelegate
extension MasterViewController: CountyViewControllerDelegate {
    func countyViewControllerDidFinish(_ countyViewController: CountyViewController) {
        parent?.dismiss(animated: true)
    }
}

// MARK: - CountyCellDisplayStyle extension to provide collection view layout information based on a display style.
extension CountyCellDisplayStyle {
    func itemSizeInCollectionView(_ collectionView: UICollectionView) -> CGSize {
        switch (self) {
        case .table:
            return CGSize(width: collectionView.bounds.width, height: 100)
        case .grid:
            return CGSize(width: 150, height: 120)
        }
    }
    
    var collectionViewEdgeInsets: UIEdgeInsets {
        switch (self) {
        case .table:
            return UIEdgeInsets.zero
        case .grid:
            return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
    
    var collectionViewLineSpacing: CGFloat {
        switch (self) {
        case .table:
            return 0
        case .grid:
            return 44
        }
    }
}
