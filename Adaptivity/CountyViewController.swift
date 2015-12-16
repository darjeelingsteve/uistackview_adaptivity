//
//  CountyViewController.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 16/12/2015.
//  Copyright © 2015 Darjeeling Apps. All rights reserved.
//

import UIKit

/// The view controller responsible for displaying information aboout a county.
class CountyViewController: UIViewController {
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var populationLabel: UILabel!
    var county: County?
    var delegate: CountyViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let county = county {
            flagImageView.image = UIImage(named: county.name)
            nameLabel.text = county.name
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = .DecimalStyle
            populationLabel.text = "Population: " + numberFormatter.stringFromNumber(county.population)!
        }
    }
    
    @IBAction func doneTapped(sender: AnyObject) {
        self.delegate?.countyViewControllerDidFinish(self)
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
    func countyViewControllerDidFinish(countyViewController: CountyViewController);
}
