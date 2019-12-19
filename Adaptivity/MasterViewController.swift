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
    @IBOutlet private var flowLayout: UICollectionViewFlowLayout!
    private var dataSource: UICollectionViewDiffableDataSource<CollectionSection, County>!
    var selectedCounty: County?
    private var spotlightSearchController = SpotlightSearchController()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard dataSource == nil else { return }
        
        /// If we configure the data source in `viewDidLoad` then the search bar
        /// is hidden on first appearance. We do it here to ensure that the
        /// search bar is shown.
        dataSource = UICollectionViewDiffableDataSource<CollectionSection, County>(collectionView: collectionView) { [weak self] (collectionView, indexPath, county) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            let countyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountyCell", for: indexPath) as! CountyCell
            countyCell.county = county
            countyCell.displayStyle = self.styleForTraitCollection(self.traitCollection)
            return countyCell
        }
        dataSource.apply(snapshotForCurrentState(), animatingDifferences: false)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let previousTraitCollection = previousTraitCollection else { return }
        if styleForTraitCollection(traitCollection) != styleForTraitCollection(previousTraitCollection) {
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
    
    func showCounty(_ county: County, animated: Bool) {
        selectedCounty = county
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
    
    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<CollectionSection, County> {
        var snapshot = NSDiffableDataSourceSnapshot<CollectionSection, County>()
        snapshot.appendSections([.counties])
        if let searchText = searchController.searchBar.text, searchText.count > 0 {
            snapshot.appendItems(spotlightSearchController.searchResults)
        } else {
            snapshot.appendItems(County.allCounties)
        }
        return snapshot
    }
    
    private func styleForTraitCollection(_ traitCollection: UITraitCollection) -> CountyCellDisplayStyle {
        return traitCollection.horizontalSizeClass == .regular ? .grid : .table
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
        showCounty(dataSource.itemIdentifier(for: indexPath)!, animated: true)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

// MARK: UISearchResultsUpdating
extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        updateSearchResults(forSearchText: searchController.searchBar.text)
    }
    
    private func updateSearchResults(forSearchText searchText: String?) {
        spotlightSearchController.search(withQueryString: searchText ?? "") { [unowned self] in
            self.dataSource.apply(self.snapshotForCurrentState(), animatingDifferences: false)
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

private extension MasterViewController {
    
    /// The sections displayed in the collection view.
    private enum CollectionSection: Hashable {
        case counties
    }
}
