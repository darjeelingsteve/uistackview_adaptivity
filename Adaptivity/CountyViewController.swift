//
//  CountyViewController.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 16/12/2015.
//  Copyright © 2015 Darjeeling Apps. All rights reserved.
//

import UIKit
import MapKit

/// The view controller responsible for displaying information about a county.
class CountyViewController: UIViewController {
    var county: County? {
        didSet {
            loadViewIfNeeded()
            flagImageView.image = county?.flagImage
            nameLabel.text = county?.name
            populationLabel.text = county?.populationDescription
        }
    }
    var delegate: CountyViewControllerDelegate?
    
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var populationLabel: UILabel!
    @IBOutlet private weak var detailsContainerView: UIView! {
        didSet {
            detailsContainerView.layer.cornerRadius = 16
            detailsContainerView.layer.cornerCurve = .continuous
        }
    }
    private lazy var detailsContainerShadowView: ShadowView = {
        let detailsContainerShadowView = ShadowView()
        detailsContainerShadowView.translatesAutoresizingMaskIntoConstraints = false
        return detailsContainerShadowView
    }()
    @IBOutlet private weak var mapView: MKMapView!
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .close)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeTapped(_:)), for: .primaryActionTriggered)
        return closeButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            closeButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16)
        ])
        
        view.insertSubview(detailsContainerShadowView, belowSubview: detailsContainerView)
        NSLayoutConstraint.activate([
            detailsContainerShadowView.leadingAnchor.constraint(equalTo: detailsContainerView.leadingAnchor),
            detailsContainerShadowView.trailingAnchor.constraint(equalTo: detailsContainerView.trailingAnchor),
            detailsContainerShadowView.topAnchor.constraint(equalTo: detailsContainerView.topAnchor),
            detailsContainerShadowView.bottomAnchor.constraint(equalTo: detailsContainerView.bottomAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let county = county else { return }
        userActivity = county.userActivity
        view.window?.windowScene?.userActivity = userActivity
        CountyHistory.shared.viewed(county)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.window?.windowScene?.userActivity = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let county = county else { return }
        mapView.region = county.mapRegion
    }
    
    @objc private func closeTapped(_ sender: AnyObject) {
        delegate?.countyViewControllerDidFinish(self)
    }
}

/*!
The protocol for delegates of the county view controller to conform to.
*/
protocol CountyViewControllerDelegate: NSObjectProtocol {
    /*!
    The function called when the county view controller wants to dismiss.
    - parameter countyViewController: The county view controller sending the message.
    */
    func countyViewControllerDidFinish(_ countyViewController: CountyViewController);
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
