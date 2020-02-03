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
    
    /// The different styles that `CountiesViewController` can display as.
    ///
    /// * `allCounties` - Shows all counties.
    /// * `favourites` - Shows only the user's favourite counties.
    enum Style {
        case allCounties
        case favourites
    }
    
    private let style: Style
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CountyCell.self, forCellWithReuseIdentifier: "CountyCell")
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dragDelegate = UIApplication.shared.supportsMultipleScenes ? self : nil
        return collectionView
    }()
    private let flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 32
        return flowLayout
    }()
    private lazy var dataSource: UICollectionViewDiffableDataSource<CollectionSection, County> = {
        return UICollectionViewDiffableDataSource<CollectionSection, County>(collectionView: collectionView) { [weak self] (collectionView, indexPath, county) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            let countyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountyCell", for: indexPath) as! CountyCell
            countyCell.county = county
            countyCell.displayStyle = self.cellStyleForTraitCollection(self.traitCollection)
            return countyCell
        }
    }()
    private let emptyCountiesNoticeView = EmptyCountiesNoticeView()
    private var spotlightSearchController = SpotlightSearchController()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    init(style: Style) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = style.navigationItemTitle
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(emptyCountiesNoticeView)
        emptyCountiesNoticeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyCountiesNoticeView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            emptyCountiesNoticeView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            emptyCountiesNoticeView.centerYAnchor.constraint(equalTo: view.readableContentGuide.centerYAnchor)
        ])
        
        reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: FavouritesController.favouriteCountiesDidChangeNotification, object: FavouritesController.shared)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let previousTraitCollection = previousTraitCollection else { return }
        if cellStyleForTraitCollection(traitCollection) != cellStyleForTraitCollection(previousTraitCollection) {
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
    
    private func cellStyleForTraitCollection(_ traitCollection: UITraitCollection) -> CountyCellDisplayStyle {
        return traitCollection.horizontalSizeClass == .regular ? .grid : .table
    }
    
    @objc private func reloadData() {
        dataSource.apply(snapshotForCurrentState(), animatingDifferences: false)
        collectionView.isHidden = dataSource.snapshot().numberOfItems(inSection: .counties) == 0
        emptyCountiesNoticeView.configuration = EmptyCountiesNoticeView.Configuration(style: style, searchQuery: searchController.searchBar.text)
        emptyCountiesNoticeView.isHidden = !collectionView.isHidden
    }
    
    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<CollectionSection, County> {
        var snapshot = NSDiffableDataSourceSnapshot<CollectionSection, County>()
        snapshot.appendSections([.counties])
        if let searchText = searchController.searchBar.text, searchText.count > 0 {
            snapshot.appendItems(spotlightSearchController.searchResults)
        } else {
            snapshot.appendItems(style.countyList)
        }
        return snapshot
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CountiesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellStyleForTraitCollection(traitCollection).itemSizeInCollectionView(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return cellStyleForTraitCollection(traitCollection).collectionViewEdgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellStyleForTraitCollection(traitCollection).collectionViewLineSpacing
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
        spotlightSearchController.search(withQuery: SpotlightSearchController.Query(queryString: searchText ?? "", filter: style.searchQueryFilter)) { [unowned self] in
            self.reloadData()
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

private extension CountiesViewController.Style {
    var navigationItemTitle: String {
        switch self {
        case .allCounties:
            return NSLocalizedString("Counties", comment: "Counties view \"All Counties\" navigation title")
        case .favourites:
            return NSLocalizedString("Favourites", comment: "Counties view \"Favourites\" navigation title")
        }
    }
    
    var countyList: [County] {
        switch self {
        case .allCounties:
            return County.allCounties
        case .favourites:
            return FavouritesController.shared.favouriteCounties
        }
    }
    
    var searchQueryFilter: SpotlightSearchController.Query.Filter {
        switch self {
        case .allCounties:
            return .allCounties
        case .favourites:
            return .favouritesOnly
        }
    }
}

private extension CountiesViewController {
    
    /// The sections displayed in the collection view.
    private enum CollectionSection: Hashable {
        case counties
    }
}
