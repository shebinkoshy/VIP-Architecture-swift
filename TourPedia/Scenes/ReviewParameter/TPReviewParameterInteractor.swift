//
//  TPReviewParameterInteractor.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import Foundation

protocol TPReviewParameterBusinessLogic {
    var locations: [String] { get }
    var categories: [String] { get }
    func validateParameter(fields:TPReviewParameter.TPReviewParameterFields)
}

protocol TPReviewParameterDataStore {
    var reviewParameter: TPReviewParameter.TPReviewParameterFields? { get }
}

class TPReviewParameterInteractor: TPReviewParameterBusinessLogic, TPReviewParameterDataStore {
    
    var locations = ["Amsterdam", "Barcelona", "Berlin", "Dubai", "London", "Paris", "Rome", "Tuscany"]
    var categories = ["accommodation", "attraction", "restaurant", "poi"]
    var presenter: TPReviewParameterPresentationLogic?
    var reviewParameter: TPReviewParameter.TPReviewParameterFields?
    
    func validateParameter(fields: TPReviewParameter.TPReviewParameterFields) {
        
        if fields.location.count == 0 {
            let response = TPReviewParameter.ValidateReviewFields.Response(errorLocationMessage: "Enter Location", errorCategoryMessage: nil)
            self.presenter?.presentReviewParameter(response: response)
            return;
        }
        
        if fields.category.count == 0 {
            let response = TPReviewParameter.ValidateReviewFields.Response(errorLocationMessage: nil, errorCategoryMessage: "Enter Category")
            self.presenter?.presentReviewParameter(response: response)
            return;
        }
        
        let review = TPReviewParameter.TPReviewParameterFields(location: fields.location, category: fields.category)
        reviewParameter = review
        let response = TPReviewParameter.ValidateReviewFields.Response(errorLocationMessage: nil, errorCategoryMessage: nil)
        self.presenter?.presentReviewParameter(response: response)
        
    }
    
    
}

