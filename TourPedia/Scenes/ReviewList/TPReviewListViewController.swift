//
//  TPReviewListViewController.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import UIKit

protocol TPReviewListDisplayLogic: class
{
    func displayReviewList(viewModel: TPReviewList.FetchReview.ViewModel)
    
    func displayReviewSortedList(viewModel: TPReviewList.SortReview.ViewModel)
    
    func displayReviewSearchList(viewModel: TPReviewList.SearchReview.ViewModel)
}

class TPReviewListViewController: UITableViewController {
    
    var router: (TPReviewListDataPassing & TPReviewListRoutingLogic)?
    var interactor: TPReviewListInteractor?
    var presenter: TPReviewListPresentationLogic?
    var displayedReviews: [TPReviewList.DisplayedReview]?
    var searchResult: [TPReviewList.DisplayedReview]?
    var searchBar: UISearchBar?
    var sortBarButton: UIBarButtonItem?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = TPReviewListInteractor()
        let presenter = TPReviewListPresenter()
        let router = TPReviewListRouter()
        viewController.interactor = interactor
        viewController.router = router
        
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reviews"
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.tableView.register(TPReviewListTableViewCell.self)
        createSearchBar()
        createSortButton()
        fetchReview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Misc
    
    func createSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        searchBar!.placeholder = "Search Anagram"
        self.tableView.tableHeaderView = searchBar
        searchBar!.delegate = self
        searchBar?.inputAccessoryView = toolBar(barButtonTitle: "Done", barButtonTarget: self, barButtonAction: #selector(buttonActionForDone))
    }
    
    func createSortButton() {
        sortBarButton = UIBarButtonItem(title: "Ascending", style: .plain, target: self, action: #selector(barButtonActionForSort(sender:)))
        self.navigationItem.rightBarButtonItem = sortBarButton
    }
    
    func currentDataSource() -> [TPReviewList.DisplayedReview]? {
        
        if isSearching() == true {
            return searchResult
        } else {
            return displayedReviews
        }
        
    }
    
    func isSearching() -> Bool {
        if searchBar == nil {
            return false
        }
        let count = searchBar!.text?.count ?? 0
        if count == 0 {
            return false
        }
        return true
    }
    
    func isShowingAscending() -> Bool {
        if sortBarButton!.title != TPString.ascending() {
            return true
        }
        return false
    }
    
    
    // MARK: - Fetch Review
    
    func fetchReview()
    {
        showActivityIndicator()
        let request = TPReviewList.FetchReview.Request(reviewParameterFields: interactor!.reviewParameter!)
        interactor?.fetchReview(request: request)
    }
    
    // MARK: - Sort Review
    
    func sortReview(isAscending: Bool, displayedReviews:[TPReviewList.DisplayedReview]?) {
        if displayedReviews == nil {
            return;
        }
        let request = TPReviewList.SortReview.Request(isAscending: isAscending, displayedReviews: displayedReviews!)
        interactor?.sortReview(request: request)
    }
    
    // MARK: - Action Events
    
    @objc func buttonActionForDone() {
        searchBar?.resignFirstResponder()
    }
    
    @objc func barButtonActionForSort(sender:UIBarButtonItem) {
        
        var isNeedAscending: Bool = false
        if  isShowingAscending() == false {
            sender.title = "Descending"
            isNeedAscending = true
        } else {
            sender.title = TPString.ascending()
        }
        if currentDataSource() == nil {
            return;
        }
        sortReview(isAscending: isNeedAscending, displayedReviews: currentDataSource())
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDataSource()?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let displayedReview = currentDataSource()![indexPath.row]
        let cell:TPReviewListTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.titleLabel.text = displayedReview.title
        cell.dateLabel.text = displayedReview.dateString
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar!.resignFirstResponder()
        router?.routeToDetailReview()
    }
    
    // MARK: - SearchBar delegate
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        searchBar!.resignFirstResponder()
    }
    
}

extension TPReviewListViewController: TPReviewListDisplayLogic {
    
    func displayReviewList(viewModel: TPReviewList.FetchReview.ViewModel) {
        hideActivityIndicator()
        if viewModel.errorMessage != nil {
            showAlert(title: nil, message: viewModel.errorMessage!, showInViewController: self, defaultButtonNames: ["OK"], destructiveButtonNames: nil, cancelButtonNames: nil, completionAction: nil)
            return;
        }
        let request = TPReviewList.SortReview.Request(isAscending: false, displayedReviews: viewModel.displayedReviews!)
        interactor?.sortReview(request: request)
    }
    
    func displayReviewSortedList(viewModel: TPReviewList.SortReview.ViewModel) {
        if isSearching() == true {
            searchResult = viewModel.displayedReviews
        } else {
            displayedReviews = viewModel.displayedReviews
        }
        self.tableView.reloadData()
    }
    
    func displayReviewSearchList(viewModel: TPReviewList.SearchReview.ViewModel) {
        searchResult = viewModel.displayedReviews
        self.tableView.reloadData()
    }
}

extension TPReviewListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText.count == 0 {
            // Also in close button action
            sortReview(isAscending: isShowingAscending(), displayedReviews: displayedReviews)
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let searchText = searchBar.text ?? ""
        if displayedReviews == nil || searchText.count == 0 {
            self.tableView.reloadData()
            return;
        }
        let request = TPReviewList.SearchReview.Request(searchText: searchText, displayedReviews: displayedReviews!)
        interactor?.searchReview(request: request)
    }
}

