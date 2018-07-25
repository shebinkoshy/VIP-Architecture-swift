//
//  TPReviewDetailPresenter.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import Foundation

protocol TPReviewDetailPresentationLogic {
    func presentReviewDetail(response:TPReviewDetailModels.FetchReviewDetail.Response)
}


class TPReviewDetailPresenter:TPReviewDetailPresentationLogic {
    
    weak var viewController: TPReviewDetailDisplayLogic?
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
    
    func presentReviewDetail(response:TPReviewDetailModels.FetchReviewDetail.Response) {
        var displayedReview:TPReviewDetailModels.FetchReviewDetail.ViewModel.DisplayedReviewDetail?
        if response.reviewDetail != nil {
            var timeStamp: String?
            if response.reviewDetail!.time != nil {
                timeStamp = dateFormatter.string(from: response.reviewDetail!.time!)
            }
            displayedReview = TPReviewDetailModels.FetchReviewDetail.ViewModel.DisplayedReviewDetail(placeName: response.reviewDetail!.place?.name, location: response.reviewDetail!.place?.location, category: response.reviewDetail!.place?.category, desc: response.reviewDetail!.text, timeStamp: timeStamp)
        }
        
        let viewModel = TPReviewDetailModels.FetchReviewDetail.ViewModel(displayedReviewDetail: displayedReview, errorMessage: response.errorMessage)
        viewController?.displayReviewDetail(viewModel: viewModel)
    }
}

