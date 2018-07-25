//
//  TPReviewDetailViewController.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import UIKit


protocol TPReviewDetailDisplayLogic: class
{
    func displayReviewDetail(viewModel: TPReviewDetailModels.FetchReviewDetail.ViewModel)
}

class TPReviewDetailViewController: UITableViewController {
    
    var interactor: TPReviewDetailInteractor?
    var router: (NSObjectProtocol & TPReviewDetailDataPassing)?
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
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
        let interactor = TPReviewDetailInteractor()
        let presenter = TPReviewDetailPresenter()
        let router = TPReviewDetailRouter()
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
        self.title = "Review Detail"
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        fetchReviewDetail()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Clear Fields
    
    func clearFields() {
        locationLabel.text = nil
        categoryLabel.text = nil
        placeNameLabel.text = nil
        descLabel.text = nil
        timeStampLabel.text = nil
        tableView.reloadData()
    }
    
    // MARK: - Fetch Review Detail
    
    func fetchReviewDetail()
    {
        clearFields()
        showActivityIndicator()
        let request = TPReviewDetailModels.FetchReviewDetail.Request(detailUrl: interactor!.detailUrl!)
        interactor?.fetchReviewDetail(request: request)
    }
    
}

extension TPReviewDetailViewController: TPReviewDetailDisplayLogic {
    func displayReviewDetail(viewModel: TPReviewDetailModels.FetchReviewDetail.ViewModel) {
        hideActivityIndicator()
        if viewModel.errorMessage != nil {
            showAlert(title: nil, message: viewModel.errorMessage!, showInViewController: self, defaultButtonNames: ["OK"], destructiveButtonNames: nil, cancelButtonNames: nil, completionAction: nil)
            return;
        }
        let reviewDetail = viewModel.displayedReviewDetail!
        locationLabel.text = reviewDetail.location
        categoryLabel.text = reviewDetail.category
        placeNameLabel.text = reviewDetail.placeName
        descLabel.text = reviewDetail.desc
        timeStampLabel.text = reviewDetail.timeStamp
        self.tableView.reloadData()
    }
}

extension TPReviewDetailViewController: TPStoryboardProtocol {
    
    static func instance(storyboardName:String, bundle:Bundle?) -> UIViewController {
        let viewController = UIStoryboard(name: storyboardName, bundle: bundle).instantiateViewController(withIdentifier: self.className())
        return viewController
    }
    
}

