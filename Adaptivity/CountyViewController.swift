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
    
    @objc private func closeTapped(_ sender: AnyObject) {
        delegate?.countyViewControllerDidFinish(self)
    }
    
    // MARK: UIPreviewActionItem
    lazy var previewActions: [UIPreviewActionItem] = {
        let safariAction = UIPreviewAction(title: NSLocalizedString("Show in Safari", comment: ""), style: .default, handler: { (previewAction, viewController) -> Void in
            guard let countyViewController = viewController as? CountyViewController, let county = countyViewController.county else { return }
            UIApplication.shared.open(county.url)
        })
        
        let mapsAction = UIPreviewAction(title: NSLocalizedString("Show in Maps", comment: ""), style: .default, handler: { (previewAction, viewController) -> Void in
            guard let countyViewController = viewController as? CountyViewController, let county = countyViewController.county else { return }
            let coordinate = CLLocationCoordinate2D(latitude: county.latitude, longitude: county.longitude)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
            let regionDistance: CLLocationDistance = 100000
            let regionSpan = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsMapSpanKey : NSValue(mkCoordinateSpan: regionSpan.span)])
        })
        
        return [safariAction, mapsAction]
    }()
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
