//
//  TPReviewParameterViewController.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import UIKit


protocol TPReviewParameterDisplayLogic: class
{
    func displayReviewParameter(viewModel: TPReviewParameter.ValidateReviewFields.ViewModel)
}

class TPReviewParameterViewController: UITableViewController {
    
    var interactor: TPReviewParameterInteractor?
    var router: (NSObjectProtocol & TPReviewParameterDataPassing & TPReviewParameterRoutingLogic)?
    var presenter: TPReviewParameterPresentationLogic?
    
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
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = TPReviewParameterInteractor()
        let presenter = TPReviewParameterPresenter()
        let router = TPReviewParameterRouter()
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
        self.title = "Tour Pedia"
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.tableFooterView = UIView()
        self.locationTextField.delegate = self
        self.categoryTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        self.tableView.addGestureRecognizer(tapGesture)
        configurePickers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Location and category
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    var locationPicker: UIPickerView!
    var categoryPicker: UIPickerView!
    
    func configurePickers()
    {
        
        let (locationPicker, toolbarLocation) = pickerViewAndToolbar(toolBarButtonTitle: "Next", pickerViewDelegateAndDataSource: self, barButtonTarget: self, barButtonAction: #selector(barButtonActionForNext))
        
        let (categoryPicker, toolbarCategory) = pickerViewAndToolbar(toolBarButtonTitle: "Done", pickerViewDelegateAndDataSource: self, barButtonTarget: self, barButtonAction: #selector(barButtonActionForDone))
        
        locationTextField.inputView = locationPicker
        locationTextField.inputAccessoryView = toolbarLocation
        categoryTextField.inputView = categoryPicker
        categoryTextField.inputAccessoryView = toolbarCategory
    }
    
    func assignTextFieldValue(index:NSInteger) {
        if locationTextField.isFirstResponder == true {
            locationTextField.text = interactor?.locations[index]
        }
        
        if categoryTextField.isFirstResponder == true {
            categoryTextField.text = interactor?.categories[index]
        }
    }
    
    // MARK: - Action Events
    
    @IBAction func buttonActionForGetReview(_ sender: Any) {
        self.view.endEditing(true)
        locationTextField.text = locationTextField.text?.trimmingCharacters(in: .whitespaces)
        categoryTextField.text = categoryTextField.text?.trimmingCharacters(in: .whitespaces)
        let reviewFields = TPReviewParameter.TPReviewParameterFields(location: locationTextField.text ?? "", category: categoryTextField.text ?? "")
        interactor?.validateParameter(fields: reviewFields)
    }
    
    @objc func barButtonActionForNext() {
        if locationTextField.isFirstResponder == true {
            locationTextField.resignFirstResponder()
            categoryTextField.becomeFirstResponder()
        }
    }
    
    @objc func barButtonActionForDone() {
        if categoryTextField.isFirstResponder == true {
            categoryTextField.resignFirstResponder()
        }
    }
    
    @objc func tapGestureAction() {
        self.tableView.endEditing(true)
    }
    
}

extension TPReviewParameterViewController: TPReviewParameterDisplayLogic {
    
    func displayReviewParameter(viewModel: TPReviewParameter.ValidateReviewFields.ViewModel) {
        if  viewModel.errorLocationMessage != nil {
            showAlert(title: nil, message: viewModel.errorLocationMessage!, showInViewController: self, defaultButtonNames: ["OK"], destructiveButtonNames: nil, cancelButtonNames: nil, completionAction: {[weak self] (selectedTitle) in
                self?.locationTextField.becomeFirstResponder()
                
            })
            return;
        }
        
        if viewModel.errorCategoryMessage != nil {
            showAlert(title: nil, message: viewModel.errorCategoryMessage!, showInViewController: self, defaultButtonNames: ["OK"], destructiveButtonNames: nil, cancelButtonNames: nil, completionAction: {[weak self] (selectedTitle) in
                self?.categoryTextField.becomeFirstResponder()
            })
            return;
        }
        
        router?.routeToListReview()
    }
}

extension TPReviewParameterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if locationTextField.isFirstResponder == true {
            return interactor?.locations.count ?? 0
        }
        
        if categoryTextField.isFirstResponder == true {
            return interactor?.categories.count ?? 0
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if locationTextField.isFirstResponder == true {
            return interactor?.locations[row]
        }
        
        if categoryTextField.isFirstResponder == true {
            return interactor?.categories[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        assignTextFieldValue(index: row)
    }
    
}

extension TPReviewParameterViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text?.count == 0 && (textField == locationTextField || textField == categoryTextField) {
            assignTextFieldValue(index: 0)
        }
    }
    
}

extension TPReviewParameterViewController: TPStoryboardProtocol {
    
    static func instance(storyboardName:String, bundle:Bundle?) -> UIViewController {
        let viewController = UIStoryboard(name: storyboardName, bundle: bundle).instantiateViewController(withIdentifier: self.className())
        return viewController
    }
    
}

