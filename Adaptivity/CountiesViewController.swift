//
//  CountiesViewController.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 15/12/2015.
//  Copyright © 2015 Darjeeling Apps. All rights reserved.
//

import UIKit
import CountiesUI
import CountiesModel

/// The view controller responsible for showing a searchable user interface of
/// counties.
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
    private let collectionViewController = CountiesCollectionViewController()
    private let emptyCountiesNoticeView = EmptyCountiesNoticeView()
    private var spotlightSearchController = SpotlightSearchController()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        return searchController
    }()
    private var countiesForCurrentState: [County] {
        if let searchText = searchController.searchBar.text, searchText.count > 0 {
            return spotlightSearchController.searchResults
        } else {
            return style.countyList
        }
    }
    
    init(style: Style) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
        navigationItem.searchController = searchController
        definesPresentationContext = true
        collectionViewController.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = style.navigationItemTitle
        
        addChild(collectionViewController)
        collectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionViewController.view)
        collectionViewController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            collectionViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            collectionViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(emptyCountiesNoticeView)
        emptyCountiesNoticeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyCountiesNoticeView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            emptyCountiesNoticeView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            emptyCountiesNoticeView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -64)
        ])
        
        reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: FavouritesController.favouriteCountiesDidChangeNotification, object: FavouritesController.shared)
    }
    
    func showCounty(_ county: County, animated: Bool) {
        let countyViewController = CountyViewController.viewController(for: county)
        countyViewController.modalPresentationStyle = .formSheet
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
    
    @objc private func reloadData() {
        collectionViewController.counties = countiesForCurrentState
        collectionViewController.view.isHidden = collectionViewController.counties.isEmpty
        emptyCountiesNoticeView.configuration = EmptyCountiesNoticeView.Configuration(style: style, searchQuery: searchController.searchBar.text)
        emptyCountiesNoticeView.isHidden = !collectionViewController.view.isHidden
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

// MARK: CountiesCollectionViewControllerDelegate
extension CountiesViewController: CountiesCollectionViewControllerDelegate {
    func countiesCollectionViewController(_ countiesCollectionViewController: CountiesCollectionViewController, didSelect county: County) {
        showCounty(county, animated: true)
    }
}

// MARK: CountyViewControllerDelegate
extension CountiesViewController: CountyViewControllerDelegate {
    func countyViewControllerDidFinish(_ countyViewController: CountyViewController) {
        parent?.dismiss(animated: true)
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
