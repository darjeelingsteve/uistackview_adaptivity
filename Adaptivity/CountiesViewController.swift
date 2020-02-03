//
//  CountiesViewController.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 15/12/2015.
//  Copyright © 2015 Darjeeling Apps. All rights reserved.
//

import UIKit

/// The view controller responsible for displaying the counties collection view.
class CountiesViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CountyCell.self, forCellWithReuseIdentifier: "CountyCell")
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        return collectionView
    }()
    private let flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 32
        return flowLayout
    }()
    private var dataSource: UICollectionViewDiffableDataSource<CollectionSection, County>!
    private var spotlightSearchController = SpotlightSearchController()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Counties", comment: "Counties view navigation title")
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        navigationItem.searchController = searchController
        definesPresentationContext = true
        collectionView.dragDelegate = UIApplication.shared.supportsMultipleScenes ? self : nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        flowLayout.invalidateLayout()
    }
    
    func showCounty(_ county: County, animated: Bool) {
        guard let countyViewController = UIStoryboard(name: "CountyViewController", bundle: nil).instantiateInitialViewController() as? CountyViewController else {
            fatalError("Could not instantiate county view controller")
        }
        countyViewController.modalPresentationStyle = .formSheet
        countyViewController.county = county
        countyViewController.delegate = self
        present(countyViewController, animated: animated)
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
extension CountiesViewController: UICollectionViewDelegateFlowLayout {
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
extension CountiesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showCounty(dataSource.itemIdentifier(for: indexPath)!, animated: true)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

// MARK: UICollectionViewDragDelegate
extension CountiesViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let county = dataSource.itemIdentifier(for: indexPath) else { return [] }
        let itemProvider = NSItemProvider()
        itemProvider.registerObject(county.userActivity, visibility: .all)
        return [UIDragItem(itemProvider: itemProvider)]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        collectionView.allowsSelection = false
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        collectionView.allowsSelection = true
    }
}

// MARK: UISearchResultsUpdating
extension CountiesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        updateSearchResults(forSearchText: searchController.searchBar.text)
    }
    
    private func updateSearchResults(forSearchText searchText: String?) {
        spotlightSearchController.search(withQuery: SpotlightSearchController.Query(queryString: searchText ?? "", filter: .allCounties)) { [unowned self] in
            self.dataSource.apply(self.snapshotForCurrentState(), animatingDifferences: false)
        }
    }
}

// MARK: CountyViewControllerDelegate
extension CountiesViewController: CountyViewControllerDelegate {
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
            let availableWidth = collectionView.bounds.width - collectionViewEdgeInsets.left - collectionViewEdgeInsets.right
            let interitemSpacing = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
            let estimatedCellWidth: CGFloat = 220
            let numberOfItemsPerRow = floor(availableWidth / estimatedCellWidth)
            let totalSpacingBetweenAdjacentItems = ((numberOfItemsPerRow - 1) * interitemSpacing)
            
            let itemWidth = floor((availableWidth - totalSpacingBetweenAdjacentItems) / numberOfItemsPerRow)
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
    
    var collectionViewEdgeInsets: UIEdgeInsets {
        switch (self) {
        case .table:
            return UIEdgeInsets.zero
        case .grid:
            return UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
        }
    }
    
    var collectionViewLineSpacing: CGFloat {
        switch (self) {
        case .table:
            return 0
        case .grid:
            return 48
        }
    }
}

private extension CountiesViewController {
    
    /// The sections displayed in the collection view.
    private enum CollectionSection: Hashable {
        case counties
    }
}
