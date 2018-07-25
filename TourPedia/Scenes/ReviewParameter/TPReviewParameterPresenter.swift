//
//  TPReviewParameterPresenter.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import Foundation


protocol TPReviewParameterPresentationLogic {
    func presentReviewParameter(response:TPReviewParameter.ValidateReviewFields.Response)
}

class TPReviewParameterPresenter:TPReviewParameterPresentationLogic {
    weak var viewController: TPReviewParameterDisplayLogic?
    
    func presentReviewParameter(response:TPReviewParameter.ValidateReviewFields.Response) {
        let viewModel = TPReviewParameter.ValidateReviewFields.ViewModel(errorLocationMessage: response.errorLocationMessage, errorCategoryMessage: response.errorCategoryMessage)
        viewController?.displayReviewParameter(viewModel: viewModel)
    }
    
}

