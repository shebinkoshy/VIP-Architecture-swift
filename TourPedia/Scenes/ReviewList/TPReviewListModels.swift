//
//  TPReviewListModels.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import Foundation


func ==(lhs: TPReviewList.TPReview, rhs: TPReviewList.TPReview) -> Bool {
    return lhs.title == rhs.title && lhs.detailUrl == rhs.detailUrl && lhs.date == rhs.date && lhs.dateString == rhs.dateString
}


func ==(lhs: TPReviewList.DisplayedReview, rhs: TPReviewList.DisplayedReview) -> Bool {
    return lhs.title == rhs.title && lhs.detailUrl == rhs.detailUrl && lhs.date == rhs.date && lhs.dateString == rhs.dateString
}


enum TPReviewList
{
    
    struct TPReview: Equatable, Codable {
        
        var date: Date?
        var dateString: String?
        var title: String?
        var detailUrl: String?
        
        private enum CodingKeys: String, CodingKey {
            case date
            case dateString = "time"
            case title = "text"
            case detailUrl = "details"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            title = try values.decode(String.self, forKey: .title)
            detailUrl = try values.decode(String.self, forKey: .detailUrl)
            dateString = try values.decode(String.self, forKey: .dateString)
        }
    }
    
    
    struct DisplayedReview: Equatable {
        var date: Date
        var dateString: String
        var title: String?
        var detailUrl: String
    }
    
    // MARK: Use cases
    
    
    enum SearchReview {
        struct Request
        {
            var searchText: String
            var displayedReviews: [DisplayedReview]
        }
        struct Response
        {
            var displayedReviews: [DisplayedReview]?
        }
        struct ViewModel
        {
            var displayedReviews: [DisplayedReview]?
        }
    }
    
    enum SortReview {
        struct Request
        {
            var isAscending:Bool
            var displayedReviews: [DisplayedReview]
        }
        struct Response
        {
            var displayedReviews: [DisplayedReview]
        }
        struct ViewModel
        {
            var displayedReviews: [DisplayedReview]?
        }
    }
    
    enum FetchReview {
        struct Request {
            var reviewParameterFields:TPReviewParameter.TPReviewParameterFields
        }
        struct Response {
            var errorMessage:String?
            var reviews: [TPReview]?
        }
        struct ViewModel {
            var errorMessage:String?
            var displayedReviews: [DisplayedReview]?
        }
    }
}

