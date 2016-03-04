//
//  MasterViewController+UIViewControllerPreviewing.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 22/02/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import UIKit

extension MasterViewController : UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView.indexPathForItemAtPoint(collectionView.convertPoint(location, fromView: view)), let cell = collectionView.cellForItemAtIndexPath(indexPath) else {
            return nil
        }
        
        let countyViewController = storyboard?.instantiateViewControllerWithIdentifier("CountyViewController") as! CountyViewController
        selectedCounty = countiesToDisplay[indexPath.item]
        countyViewController.county = selectedCounty
        countyViewController.delegate = self
        countyViewController.preferredContentSize = CGSize(width: 0, height: 360)
        previewingContext.sourceRect = collectionView.convertRect(cell.frame, toView: collectionView.superview!)
        return countyViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewControllerToCommit)
        showViewController(navigationController, sender: self)
        history?.viewed(selectedCounty!)
    }
}
