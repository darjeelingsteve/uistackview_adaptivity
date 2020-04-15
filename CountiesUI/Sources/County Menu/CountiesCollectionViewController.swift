//
//  CountiesCollectionViewController.swift
//  CountiesUI
//
//  Created by Stephen Anthony on 03/02/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit
import CountiesModel

/// The view controller responsible for displaying a collection view populated
/// by a list of counties.
final class CountiesCollectionViewController: UIViewController {
    private static let countyCellIdentifier = "CountyCell"
    private static let regionHeaderIdentifier = "RegionNameHeader"
    
    /// The regions displayed by the receiver.
    var regions = [Region]() {
        didSet {
            reloadData()
        }
    }
    
    /// The delegate of the receiver.
    var delegate: CountiesCollectionViewControllerDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CountyCell.self, forCellWithReuseIdentifier: CountiesCollectionViewController.countyCellIdentifier)
        collectionView.register(SectionHeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CountiesCollectionViewController.regionHeaderIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.preservesSuperviewLayoutMargins = true
        collectionView.delegate = self
        #if os(iOS)
        collectionView.dragDelegate = UIApplication.shared.supportsMultipleScenes ? self : nil
        collectionView.backgroundColor = .systemBackground
        #elseif os(tvOS)
        collectionView.remembersLastFocusedIndexPath = true
        #endif
        return collectionView
    }()
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = cellStyleForTraitCollection(traitCollection).collectionViewInteritemSpacing
        flowLayout.sectionHeadersPinToVisibleBounds = platformValue(foriOS: true, tvOS: false)
        flowLayout.headerReferenceSize = CGSize(width: 20, height: platformValue(foriOS: 40, tvOS: 100))
        return flowLayout
    }()
    private lazy var dataSource: UICollectionViewDiffableDataSource<CollectionSection, County> = {
        let dataSource = UICollectionViewDiffableDataSource<CollectionSection, County>(collectionView: collectionView) { [weak self] (collectionView, indexPath, county) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            let countyCell = collectionView.dequeueReusableCell(withReuseIdentifier: CountiesCollectionViewController.countyCellIdentifier, for: indexPath) as! CountyCell
            countyCell.county = county
            countyCell.displayStyle = self.cellStyleForTraitCollection(self.traitCollection)
            return countyCell
        }
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            guard let self = self, kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CountiesCollectionViewController.regionHeaderIdentifier, for: indexPath) as! SectionHeaderSupplementaryView
            switch self.dataSource.snapshot().sectionIdentifiers[indexPath.section] {
            case .region(let name):
                sectionHeader.title = name
            }
            return sectionHeader
        }
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if os(iOS)
        view.backgroundColor = .systemBackground
        #elseif os(tvOS)
        // Allow the collection view to handle focus restoration.
        restoresFocusAfterTransition = false
        #endif
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData() // Reload in case the trait collection changed when we were not visible.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        flowLayout.invalidateLayout()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let previousTraitCollection = previousTraitCollection else { return }
        if cellStyleForTraitCollection(traitCollection) != cellStyleForTraitCollection(previousTraitCollection) {
            collectionView.reloadData() // Reload cells to adopt the new style
        }
    }
    
    private func cellStyleForTraitCollection(_ traitCollection: UITraitCollection) -> CountyCellDisplayStyle {
        return traitCollection.horizontalSizeClass == .regular ? .grid : .table
    }
    
    @objc private func reloadData() {
        dataSource.apply(snapshotForCurrentState(), animatingDifferences: false)
    }
    
    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<CollectionSection, County> {
        var snapshot = NSDiffableDataSourceSnapshot<CollectionSection, County>()
        regions.forEach { (region) in
            snapshot.appendSections([.region(name: region.name)])
            snapshot.appendItems(region.counties)
        }
        return snapshot
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CountiesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellStyleForTraitCollection(traitCollection).itemSizeInCollectionView(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch cellStyleForTraitCollection(traitCollection) {
        case .table:
            return .zero
        case .grid:
            return UIEdgeInsets(top: 8, left: collectionView.layoutMargins.left, bottom: 24, right: collectionView.layoutMargins.right)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellStyleForTraitCollection(traitCollection).collectionViewLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellStyleForTraitCollection(traitCollection).collectionViewInteritemSpacing
    }
}

// MARK: UICollectionViewDelegate
extension CountiesCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.countiesCollectionViewController(self, didSelect: dataSource.itemIdentifier(for: indexPath)!)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

#if os(iOS)
// MARK: UICollectionViewDragDelegate
extension CountiesCollectionViewController: UICollectionViewDragDelegate {
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
#endif

/// The protocol to conform to for delegates of
/// `CountiesCollectionViewController`.
protocol CountiesCollectionViewControllerDelegate: AnyObject {
    
    /// The message sent when the user taps on one of the sender's county cells.
    /// - Parameters:
    ///   - countiesCollectionViewController: The controller sending the
    ///   message.
    ///   - county: The county that the user tapped on.
    func countiesCollectionViewController(_ countiesCollectionViewController: CountiesCollectionViewController, didSelect county: County)
}

// MARK: - CountyCellDisplayStyle extension to provide collection view layout information based on a display style.
private extension CountyCellDisplayStyle {
    func itemSizeInCollectionView(_ collectionView: UICollectionView) -> CGSize {
        switch (self) {
        case .table:
            return CGSize(width: collectionView.bounds.width, height: 100)
        case .grid:
            let availableWidth = collectionView.bounds.width - collectionView.layoutMargins.left - collectionView.layoutMargins.right
            let interitemSpacing = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
            let numberOfItemsPerRow: Int
            switch columnCountMetric {
            case .fixed(let columnCount):
                numberOfItemsPerRow = columnCount
            case .calculated(let estimatedCellWidth):
                numberOfItemsPerRow = Int(floor(availableWidth / estimatedCellWidth))
            }
            let totalSpacingBetweenAdjacentItems = (CGFloat(numberOfItemsPerRow - 1) * interitemSpacing)
            
            let itemWidth = floor((availableWidth - totalSpacingBetweenAdjacentItems) / CGFloat(numberOfItemsPerRow))
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
    
    var collectionViewLineSpacing: CGFloat {
        switch (self) {
        case .table:
            return 0
        case .grid:
            return platformValue(foriOS: 24, tvOS: 48)
        }
    }
    
    var collectionViewInteritemSpacing: CGFloat {
        #if os(tvOS)
        return 80
        #else
        return 32
        #endif
    }
    
    private var columnCountMetric: ColumnCountMetric {
        #if os(tvOS)
        return .fixed(columnCount: 4)
        #else
        return .calculated(estimatedCellWidth: 220)
        #endif
    }
    
    private enum ColumnCountMetric {
        case fixed(columnCount: Int)
        case calculated(estimatedCellWidth: CGFloat)
    }
}

private extension CountiesCollectionViewController {
    
    /// The sections displayed in the collection view.
    private enum CollectionSection: Hashable {
        case region(name: String)
    }
}
