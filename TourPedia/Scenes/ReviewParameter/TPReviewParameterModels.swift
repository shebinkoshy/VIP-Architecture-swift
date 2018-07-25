//
//  TPReviewParameterModels.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import Foundation

enum TPReviewParameter
{
    struct TPReviewParameterFields {
        var location: String
        var category: String
    }
    
    // MARK: Use cases
    
    enum ValidateReviewFields {
        struct Request {
            var reviewParameterFields:TPReviewParameterFields
        }
        struct Response {
            var errorLocationMessage:String?
            var errorCategoryMessage:String?
        }
        struct ViewModel {
            var errorLocationMessage:String?
            var errorCategoryMessage:String?
        }
    }
}

