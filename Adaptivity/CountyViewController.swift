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
    var county: County?
    var delegate: CountyViewControllerDelegate?
    
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var populationLabel: UILabel!
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
        
        if let county = county {
            flagImageView.image = county.flagImage
            nameLabel.text = county.name
            populationLabel.text = county.populationDescription
            userActivity = county.userActivity
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.window?.windowScene?.userActivity = userActivity
        guard let county = county else { return }
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

/// The view used to draw an overlay over the county map view so that the county
/// details are legible.
@IBDesignable class CountyMapOverlayView: UIView {
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        // Draw a gradient below our bounds
        gradientLayer.frame = CGRect(x: bounds.minX, y: bounds.maxY, width: bounds.width, height: 200)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            configureGradientColours()
        }
    }
    
    private func commonSetup() {
        layer.addSublayer(gradientLayer)
        backgroundColor = UIColor(dynamicProvider: { (traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor.black.withAlphaComponent(0.4)
            default:
                return UIColor.black.withAlphaComponent(0.2)
            }
        })
    }
    
    private func configureGradientColours() {
        guard let backgroundColor = backgroundColor else { return }
        gradientLayer.colors = [backgroundColor.cgColor, backgroundColor.withAlphaComponent(0).cgColor]
    }
}
