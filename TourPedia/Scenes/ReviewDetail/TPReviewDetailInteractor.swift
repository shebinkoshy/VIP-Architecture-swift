//
//  TPReviewDetailInteractor.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import Foundation


protocol TPReviewDetailBusinessLogic {
    func fetchReviewDetail(request:TPReviewDetailModels.FetchReviewDetail.Request)
}

protocol TPReviewDetailDataStore {
    var detailUrl: String? { get set }
    var reviewDetail:TPReviewDetailModels.TPReviewDetail? { get set }
}

class TPReviewDetailInteractor: TPReviewDetailBusinessLogic, TPReviewDetailDataStore {
    
    var detailUrl: String?
    var reviewDetail: TPReviewDetailModels.TPReviewDetail?
    var reviewDetailWorker = TPReviewDetailWorker()
    var presenter: TPReviewDetailPresentationLogic?
    
    func fetchReviewDetail(request: TPReviewDetailModels.FetchReviewDetail.Request) {
        reviewDetailWorker.fetchReviewDetail(request: request, success: { (response:TPReviewDetailModels.FetchReviewDetail.Response) in
            self.reviewDetail = response.reviewDetail
            self.presenter?.presentReviewDetail(response: response)
        }) { (response:TPReviewDetailModels.FetchReviewDetail.Response) in
            self.reviewDetail = response.reviewDetail
            self.presenter?.presentReviewDetail(response: response)
        }
    }
    
}

