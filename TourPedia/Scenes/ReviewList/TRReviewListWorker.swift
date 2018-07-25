//
//  TRReviewListWorker.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import Foundation


typealias responseHandler = (_ response:TPReviewList.FetchReview.Response) ->()

class TPReviewListWorker {
    
    func fetchReview(location: String, category: String, success: @escaping responseHandler, fail: @escaping responseHandler) {
        
        let url = "http://tour-pedia.org/api/getReviews?location=\(location)&category=\(category)&language=en"
        
        TPServiceManager.webservice(urlString: url, httpMethod: "GET", headerFields: [], body: nil) { (result, isSuccess) in
            if isSuccess == true && result != nil {
                do {
                    let decoder = JSONDecoder()
                    let reviewObj = try decoder.decode([TPReviewList.TPReview].self, from: result!)
                    let response = TPReviewList.FetchReview.Response(errorMessage: nil, reviews: reviewObj)
                    DispatchQueue.main.async {
                        success(response)
                    }
                    return;
                } catch let error {
                    print("Error:", error)
                }
            }
            DispatchQueue.main.async {
                let response = TPReviewList.FetchReview.Response(errorMessage: "Something went wrong", reviews: nil)
                fail(response)
            }
        }
    }
}

