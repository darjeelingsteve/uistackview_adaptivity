//
//  MasterViewController+UIViewControllerPreviewing.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 22/02/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import UIKit

extension MasterViewController : UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView.indexPathForItem(at: collectionView.convert(location, from: view)), let cell = collectionView.cellForItem(at: indexPath) else {
            return nil
        }
        
        let countyViewController = storyboard?.instantiateViewController(withIdentifier: "CountyViewController") as! CountyViewController
        selectedCounty = countiesToDisplay[indexPath.item]
        countyViewController.county = selectedCounty
        countyViewController.delegate = self
        countyViewController.preferredContentSize = CGSize(width: 0, height: 360)
        previewingContext.sourceRect = collectionView.convert(cell.frame, to: collectionView.superview!)
        return countyViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewControllerToCommit)
        show(navigationController, sender: self)
        history?.viewed(selectedCounty!)
    }
}
