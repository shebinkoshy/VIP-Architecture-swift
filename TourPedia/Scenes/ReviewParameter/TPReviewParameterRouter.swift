//
//  TPReviewParameterRouter.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import Foundation


@objc protocol TPReviewParameterRoutingLogic
{
    func routeToListReview()
}

protocol TPReviewParameterDataPassing {
    var dataStore: TPReviewParameterDataStore? { get }
}

class TPReviewParameterRouter: NSObject, TPReviewParameterDataPassing, TPReviewParameterRoutingLogic {
    
    weak var viewController: TPReviewParameterViewController?
    var dataStore: TPReviewParameterDataStore?
    
    // MARK: - Routing
    
    func routeToListReview() {
        let destinationVC = TPReviewListViewController(style: .plain)
        var destinationDS = destinationVC.router!.dataStore!
        passDataToReviewList(source: dataStore!, destination: &destinationDS)
        navigateToListReview(source: viewController!, destination: destinationVC)
    }
    
    // MARK: - Navigation
    
    func navigateToListReview(source: TPReviewParameterViewController, destination: TPReviewListViewController)
    {
        source.show(destination, sender: nil)
    }
    
    // MARK: - Passing data
    
    func passDataToReviewList(source: TPReviewParameterDataStore, destination: inout TPReviewListDataStore)
    {
        destination.reviewParameter = source.reviewParameter!
    }
    
}

