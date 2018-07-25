//
//  TPReviewListPresenter.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import Foundation

protocol TPReviewListPresentationLogic {
    func presentReviewList(response:TPReviewList.FetchReview.Response)
    func presentReviewSortedList(response:TPReviewList.SortReview.Response)
    func presentReviewSearchList(response:TPReviewList.SearchReview.Response)
}

class TPReviewListPresenter:TPReviewListPresentationLogic {
    weak var viewController: TPReviewListDisplayLogic?
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    // MARK: - Sorted List
    
    func presentReviewSortedList(response:TPReviewList.SortReview.Response) {
        let viewModel = TPReviewList.SortReview.ViewModel(displayedReviews: response.displayedReviews)
        viewController?.displayReviewSortedList(viewModel: viewModel)
    }
    
    
    // MARK: - Review List
    
    func presentReviewList(response:TPReviewList.FetchReview.Response) {
        
        var  displayedReviews: [TPReviewList.DisplayedReview]?
        if response.reviews != nil {
            displayedReviews = [TPReviewList.DisplayedReview]()
            for review in response.reviews! {
                if review.dateString == nil {
                    continue;
                }
                let date = dateFormatter.date(from: review.dateString!)
                if date == nil {
                    continue;
                }
                if review.detailUrl == nil {
                    continue;
                }
                let displayedReview = TPReviewList.DisplayedReview(date: date!, dateString: review.dateString!, title: review.title, detailUrl: review.detailUrl!)
                displayedReviews!.append(displayedReview)
            }
        }
        let viewModel = TPReviewList.FetchReview.ViewModel(errorMessage: response.errorMessage, displayedReviews: displayedReviews)
        viewController?.displayReviewList(viewModel: viewModel)
    }
    
    
    // MARK: - Review Search List
    
    func presentReviewSearchList(response:TPReviewList.SearchReview.Response) {
        let viewModel = TPReviewList.SearchReview.ViewModel(displayedReviews: response.displayedReviews)
        viewController?.displayReviewSearchList(viewModel: viewModel)
    }
    
}

