//
//  TPReviewListRouter.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import Foundation
import UIKit

protocol TPReviewListRoutingLogic {
    func routeToDetailReview()
}

protocol TPReviewListDataPassing {
    var dataStore: TPReviewListDataStore? { get }
}

class TPReviewListRouter: NSObject, TPReviewListDataPassing, TPReviewListRoutingLogic {
    weak var viewController: TPReviewListViewController?
    var dataStore: TPReviewListDataStore?
    
    // MARK: - Routing
    
    func routeToDetailReview() {
        let destinationVC = TPReviewDetailViewController.instance(storyboardName: "TPMain", bundle: nil) as! TPReviewDetailViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToReviewDetail(source: dataStore!, destination: &destinationDS)
        navigateToDetailReview(source: viewController!, destination: destinationVC)
    }
    
    // MARK: - Navigation
    
    func navigateToDetailReview(source: TPReviewListViewController, destination: TPReviewDetailViewController)
    {
        source.show(destination, sender: nil)
    }
    
    
    // MARK: - Passing data
    
    func passDataToReviewDetail(source: TPReviewListDataStore, destination: inout TPReviewDetailDataStore)
    {
        let selectedRow = viewController?.tableView.indexPathForSelectedRow?.row
        let selectedReview =  viewController?.currentDataSource()![selectedRow!]
        destination.detailUrl = selectedReview!.detailUrl
    }
    
}

