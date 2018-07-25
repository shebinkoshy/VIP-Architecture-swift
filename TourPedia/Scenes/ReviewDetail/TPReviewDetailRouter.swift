//
//  TPReviewDetailRouter.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import Foundation


protocol TPReviewDetailDataPassing {
    var dataStore: TPReviewDetailDataStore? { get }
}

class TPReviewDetailRouter: NSObject, TPReviewDetailDataPassing {
    
    weak var viewController: TPReviewDetailViewController?
    var dataStore: TPReviewDetailDataStore?
    
}

