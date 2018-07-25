//
//  TPReviewDetailWorker.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import Foundation

typealias reviewDetailResponseHandler = (_ response:TPReviewDetailModels.FetchReviewDetail.Response) ->()

class TPReviewDetailWorker {
    
    func fetchReviewDetail(request:TPReviewDetailModels.FetchReviewDetail.Request, success: @escaping reviewDetailResponseHandler, fail: @escaping reviewDetailResponseHandler) {
        let url = request.detailUrl
        
        TPServiceManager.webservice(urlString: url, httpMethod: "GET", headerFields: [], body: nil) { (result, isSuccess) in
            if isSuccess == true && result != nil {
                do {
                    let decoder = JSONDecoder()
                    let reviewDetailObj = try decoder.decode(TPReviewDetailModels.TPReviewDetail.self, from: result!)
                    let response = TPReviewDetailModels.FetchReviewDetail.Response(reviewDetail: reviewDetailObj, errorMessage: nil)
                    DispatchQueue.main.async {
                        success(response)
                    }
                    return;
                } catch let error {
                    print("Error:", error)
                }
            }
            
            DispatchQueue.main.async {
                let response = TPReviewDetailModels.FetchReviewDetail.Response(reviewDetail: nil, errorMessage: "Something went wrong")
                fail(response)
            }
        }
    }
    
}

