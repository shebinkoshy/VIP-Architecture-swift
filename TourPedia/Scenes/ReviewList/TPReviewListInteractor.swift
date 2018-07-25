//
//  TPReviewListInteractor.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import Foundation

protocol TPReviewListBusinessLogic {
    func fetchReview(request:TPReviewList.FetchReview.Request)
    func sortReview(request:TPReviewList.SortReview.Request)
    func searchReview(request:TPReviewList.SearchReview.Request)
}

protocol TPReviewListDataStore {
    var reviewParameter: TPReviewParameter.TPReviewParameterFields? { get set }
    var reviews:[TPReviewList.TPReview]? { get set }
}


class TPReviewListInteractor: TPReviewListBusinessLogic, TPReviewListDataStore {
    
    var reviewParameter: TPReviewParameter.TPReviewParameterFields?
    var reviewListWorker = TPReviewListWorker()
    var presenter: TPReviewListPresentationLogic?
    var reviews:[TPReviewList.TPReview]?
    
    // MARK: - Search Review
    
    func searchReview(request:TPReviewList.SearchReview.Request) {
        let searchCharacters = Array(lowerReplaceEmpty(string: request.searchText))
        let searchResult = request.displayedReviews.filter {
            return searchAnagram(fullText: $0.title, searchCharacters: searchCharacters)
        }
        
        let response = TPReviewList.SearchReview.Response(displayedReviews: searchResult)
        presenter?.presentReviewSearchList(response: response)
    }
    
    fileprivate func searchAnagram(fullText: String?, searchCharacters: [Character]) -> Bool {
        if fullText == nil {
            return false;
        }
        
        if searchCharacters.count > fullText!.count {
            return false;
        }
        let fullText = lowerReplaceEmpty(string: fullText!)
        var charactersFullText = Array(fullText)
        var isAnagram : Bool = true
        for character in searchCharacters {
            let index = charactersFullText.index(of: character)
            if index == nil {
                isAnagram = false
                break;
            }
            charactersFullText.remove(at: index!)
        }
        return isAnagram;
    }
    
    fileprivate func lowerReplaceEmpty(string:String) -> String {
        let str = string.replacingOccurrences(of: " ", with: "").lowercased()
        return str
    }
    
    // MARK: - Sort Review
    
    func sortReview(request:TPReviewList.SortReview.Request) {
        
        var sortedReviews : [TPReviewList.DisplayedReview]?
        if request.isAscending {
            sortedReviews = request.displayedReviews.sorted(by: { $0.date < $1.date })
        } else {
            sortedReviews = request.displayedReviews.sorted(by: { $0.date > $1.date })
        }
        let response = TPReviewList.SortReview.Response(displayedReviews: sortedReviews!)
        presenter?.presentReviewSortedList(response: response)
        
    }
    
    // MARK: - Fetch review
    
    func fetchReview(request:TPReviewList.FetchReview.Request) {
        reviewListWorker.fetchReview(location: request.reviewParameterFields.location, category: request.reviewParameterFields.category, success: { (response:TPReviewList.FetchReview.Response) in
            self.reviews = response.reviews
            self.presenter?.presentReviewList(response: response)
        }) { (response:TPReviewList.FetchReview.Response) in
            self.reviews = response.reviews
            self.presenter?.presentReviewList(response: response)
        }
    }
}

