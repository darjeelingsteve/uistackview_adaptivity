//
//  CountiesViewController.swift
//  CountiesUI
//
//  Created by Stephen Anthony on 15/12/2015.
//  Copyright © 2015 Darjeeling Apps. All rights reserved.
//

import UIKit
import CountiesModel

/// The view controller responsible for showing a searchable user interface of
/// counties.
public final class CountiesViewController: UIViewController {
    
    /// The different styles that `CountiesViewController` can display as.
    ///
    /// * `allCounties` - Shows all counties.
    /// * `favourites` - Shows only the user's favourite counties.
    public enum Style {
        case allCounties
        case favourites
    }
    
    private let style: Style
    private let collectionViewController = CountiesCollectionViewController()
    private let emptyCountiesNoticeView = EmptyCountiesNoticeView()
    #if os(iOS)
    private var spotlightSearchController = SpotlightSearchController()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        return searchController
    }()
    #endif
    private var countiesForCurrentState: [County] {
        #if os(tvOS)
        return style.countyList
        #else
        if let searchText = searchController.searchBar.text, searchText.count > 0 {
            return spotlightSearchController.searchResults
        } else {
            return style.countyList
        }
        #endif
    }
    
    public init(style: Style) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
        #if os(iOS)
        navigationItem.searchController = searchController
        #endif
        collectionViewController.delegate = self
        definesPresentationContext = true
        tabBarItem = style.tabBarItem
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        #if os(iOS)
        view.backgroundColor = .systemBackground
        #endif
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
    
    public func showCounty(_ county: County, animated: Bool) {
        let countyViewController = CountyViewController.viewController(for: county)
        #if os(iOS)
        countyViewController.modalPresentationStyle = .formSheet
        countyViewController.delegate = self
        #endif
        present(countyViewController, animated: animated)
    }
    
    #if os(iOS)
    public func beginSearch(withText searchText: String? = nil) {
        searchController.searchBar.becomeFirstResponder()
        if let searchText = searchText {
            searchController.searchBar.text = searchText
            updateSearchResults(forSearchText: searchText)
        }
    }
    #endif
    
    @objc private func reloadData() {
        collectionViewController.counties = countiesForCurrentState
        collectionViewController.view.isHidden = collectionViewController.counties.isEmpty
        #if os(iOS)
        emptyCountiesNoticeView.configuration = EmptyCountiesNoticeView.Configuration(style: style, searchQuery: searchController.searchBar.text)
        #else
        emptyCountiesNoticeView.configuration = EmptyCountiesNoticeView.Configuration(style: style, searchQuery: nil)
        #endif
        emptyCountiesNoticeView.isHidden = !collectionViewController.view.isHidden
    }
}

#if os(iOS)
// MARK: UISearchResultsUpdating
extension CountiesViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        updateSearchResults(forSearchText: searchController.searchBar.text)
    }
    
    private func updateSearchResults(forSearchText searchText: String?) {
        spotlightSearchController.search(withQuery: SpotlightSearchController.Query(queryString: searchText ?? "", filter: style.searchQueryFilter)) { [unowned self] in
            self.reloadData()
        }
    }
}
#endif

// MARK: CountiesCollectionViewControllerDelegate
extension CountiesViewController: CountiesCollectionViewControllerDelegate {
    func countiesCollectionViewController(_ countiesCollectionViewController: CountiesCollectionViewController, didSelect county: County) {
        showCounty(county, animated: true)
    }
}

#if os(iOS)
// MARK: CountyViewControllerDelegate
extension CountiesViewController: CountyViewControllerDelegate {
    public func countyViewControllerDidFinish(_ countyViewController: CountyViewController) {
        parent?.dismiss(animated: true)
    }
}
#endif

private extension CountiesViewController.Style {
    var navigationItemTitle: String {
        switch self {
        case .allCounties:
            return NSLocalizedString("Counties", comment: "Counties view \"All Counties\" navigation title")
        case .favourites:
            return NSLocalizedString("Favourites", comment: "Counties view \"Favourites\" navigation title")
        }
    }
    
    var tabBarItem: UITabBarItem {
        switch self {
        case .allCounties:
            return UITabBarItem(title: NSLocalizedString("All Counties", comment: "All counties tab bar item title"), image: UIImage(systemName: "list.bullet"), selectedImage: nil)
        case .favourites:
            return UITabBarItem(title: NSLocalizedString("Favourites", comment: "Favourites tab bar item title"), image: UIImage(systemName: "heart.fill"), selectedImage: nil)
        }
    }
    
    var countyList: [County] {
        switch self {
        case .allCounties:
            return Country.unitedKingdom.allCounties
        case .favourites:
            return FavouritesController.shared.favouriteCounties
        }
    }
    
    #if os(iOS)
    var searchQueryFilter: SpotlightSearchController.Query.Filter {
        switch self {
        case .allCounties:
            return .allCounties
        case .favourites:
            return .favouritesOnly
        }
    }
    #endif
}

private extension CountiesViewController {
    
    /// The sections displayed in the collection view.
    private enum CollectionSection: Hashable {
        case counties
    }
}
