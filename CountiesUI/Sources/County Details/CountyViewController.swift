//
//  CountyViewController.swift
//  CountiesUI
//
//  Created by Stephen Anthony on 16/12/2015.
//  Copyright © 2015 Darjeeling Apps. All rights reserved.
//

import UIKit
import MapKit
import CountiesModel
#if os(tvOS)
import TVUIKit
#endif

/// The view controller responsible for displaying information about a county.
public class CountyViewController: UIViewController {
    public var county: County? {
        didSet {
            loadViewIfNeeded()
            flagImageView.image = county?.flagImage
            nameLabel.text = county?.name
            populationLabel.text = county?.populationDescription
        }
    }
    public var delegate: CountyViewControllerDelegate?
    
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var populationLabel: UILabel!
    @IBOutlet private weak var detailsContainerView: UIView? {
        didSet {
            detailsContainerView?.layer.cornerRadius = 16
            detailsContainerView?.layer.cornerCurve = .continuous
        }
    }
    #if os(iOS)
    @IBOutlet private weak var favouriteButton: UIButton! {
        didSet {
            configureFavouriteButton()
        }
    }
    #elseif os(tvOS)
    @IBOutlet private weak var favouriteButton: TVCaptionButtonView! {
        didSet {
            configureFavouriteButton()
        }
    }
    #endif
    private lazy var detailsContainerShadowView: ShadowView = {
        let detailsContainerShadowView = ShadowView()
        detailsContainerShadowView.translatesAutoresizingMaskIntoConstraints = false
        return detailsContainerShadowView
    }()
    @IBOutlet private weak var mapView: MKMapView?
    
    public static func viewController(for county: County) -> CountyViewController {
        guard let countyViewController = UIStoryboard(name: platformValue(foriOS: "CountyViewController", tvOS: "CountyViewController-tvOS"), bundle: Bundle.countiesUIBundle).instantiateInitialViewController() as? CountyViewController else {
            fatalError("Could not instantiate county view controller")
        }
        countyViewController.county = county
        return countyViewController
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if let detailsContainerView = detailsContainerView {
            view.insertSubview(detailsContainerShadowView, belowSubview: detailsContainerView)
            NSLayoutConstraint.activate([
                detailsContainerShadowView.leadingAnchor.constraint(equalTo: detailsContainerView.leadingAnchor),
                detailsContainerShadowView.trailingAnchor.constraint(equalTo: detailsContainerView.trailingAnchor),
                detailsContainerShadowView.topAnchor.constraint(equalTo: detailsContainerView.topAnchor),
                detailsContainerShadowView.bottomAnchor.constraint(equalTo: detailsContainerView.bottomAnchor)
            ])
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(configureFavouriteButton),
                                               name: FavouritesController.favouriteCountiesDidChangeNotification,
                                               object: FavouritesController.shared)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let county = county, let mapView = mapView, let detailsContainerView = detailsContainerView else { return }
        mapView.region = county.mapRegion
        mapView.setVisibleMapRect(mapView.visibleMapRect, edgePadding: UIEdgeInsets(top: detailsContainerView.frame.maxY, left: 0, bottom: 0, right: 0), animated: false)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let county = county else { return }
        userActivity = county.userActivity
        view.window?.windowScene?.userActivity = userActivity
        CountyHistory.shared.viewed(county)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.window?.windowScene?.userActivity = nil
    }
    
    @IBAction private func doneTapped(_ sender: AnyObject) {
        delegate?.countyViewControllerDidFinish(self)
    }
    
    @IBAction private func toggleFavourite(_ sender: AnyObject) {
        guard let county = county else { return }
        if FavouritesController.shared.favouriteCounties.contains(county) {
            FavouritesController.shared.remove(county: county)
        } else {
            FavouritesController.shared.add(county: county)
        }
    }
    
    @objc private func configureFavouriteButton() {
        guard let county = county else { return }
        let isFavourite = FavouritesController.shared.favouriteCounties.contains(county)
        let systemImageName = isFavourite ? "heart.fill" : "heart"
        #if os(tvOS)
        favouriteButton.contentImage = UIImage(systemName: systemImageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .bold, scale: .large))
        favouriteButton.title = isFavourite ? NSLocalizedString("Unfavourite", comment: "Favourite button remove favourite CTA") : NSLocalizedString("Favourite", comment: "Favourite button make favourite CTA")
        #else
        favouriteButton.setImage(UIImage(systemName: systemImageName, withConfiguration: favouriteButton.image(for: .normal)?.symbolConfiguration), for: .normal)
        #endif
    }
}

/*!
The protocol for delegates of the county view controller to conform to.
*/
public protocol CountyViewControllerDelegate: AnyObject {
    /*!
    The function called when the county view controller wants to dismiss.
    - parameter countyViewController: The county view controller sending the message.
    */
    func countyViewControllerDidFinish(_ countyViewController: CountyViewController)
}

private extension County {
    
    /// The region required to show the receiver on a map.
    var mapRegion: MKCoordinateRegion {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let regionDistance: CLLocationDistance = 100000
        return MKCoordinateRegion(center: coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
    }
}

/// A view that draws a shadow behind it.
private class ShadowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        configureShadowOpacity()
    }
    
    private func commonSetup() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 80
        layer.shadowOffset = CGSize(width: 0, height: 40)
        configureShadowOpacity()
    }
    
    private func configureShadowOpacity() {
        switch traitCollection.userInterfaceStyle {
        case .dark:
            layer.shadowOpacity = 0.9
        default:
            layer.shadowOpacity = 0.5
        }
    }
}
