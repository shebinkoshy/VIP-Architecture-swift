//
//  TPReviewDetailModels.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import Foundation

func ==(lhs: TPReviewDetailModels.TPReviewPlace, rhs: TPReviewDetailModels.TPReviewPlace) -> Bool {
    return lhs.name == rhs.name && lhs.location == rhs.location && lhs.category == rhs.category
}

func ==(lhs: TPReviewDetailModels.TPReviewDetail, rhs: TPReviewDetailModels.TPReviewDetail) -> Bool {
    return lhs.place == rhs.place && lhs.text == rhs.text && lhs.time == rhs.time
}

enum TPReviewDetailModels
{
    struct TPReviewPlace: Codable, Equatable {
        var name: String?
        var location: String?
        var category: String?
    }
    
    struct TPReviewDetail: Codable, Equatable {
        var place: TPReviewPlace?
        var text: String?
        var time: Date?
        
        private enum CodingKeys: String, CodingKey {
            case text
            case time
            case place
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            text = try values.decode(String.self, forKey: .text)
            let timeSince = try values.decode(TimeInterval.self, forKey: .time)
            time = Date(timeIntervalSince1970: timeSince)
            place = try values.decode(TPReviewPlace.self, forKey: .place)
        }
    }
    
    // MARK: Use cases
    
    enum FetchReviewDetail {
        struct Request {
            var detailUrl: String
        }
        
        struct Response {
            var reviewDetail: TPReviewDetail?
            var errorMessage:String?
        }
        
        struct ViewModel {
            struct DisplayedReviewDetail {
                var placeName: String?
                var location: String?
                var category: String?
                var desc: String?
                var timeStamp: String?
            }
            var displayedReviewDetail: DisplayedReviewDetail?
            var errorMessage:String?
        }
    }
    
}

