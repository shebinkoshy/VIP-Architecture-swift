//
//  TPViewController.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import UIKit

// MARK: - Class name
extension UIViewController {
    class func className() -> String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}


// MARK: - Alert controller

extension UIViewController {
    public typealias AlertActionHandler = (String) -> Swift.Void
    
    public func showAlert(title:String?, message:String, showInViewController:UIViewController,defaultButtonNames:[String]?,destructiveButtonNames:[String]?,cancelButtonNames:[String]?,completionAction:AlertActionHandler?){
        
        showAlertActionController(title: title, message: message, showInViewController: showInViewController, defaultButtonNames: defaultButtonNames, destructiveButtonNames: destructiveButtonNames, cancelButtonNames: cancelButtonNames, completionAction: completionAction, preferredStyle: .alert)
    }
    
    fileprivate func showAlertActionController(title:String?, message:String?, showInViewController:UIViewController,defaultButtonNames:[String]?,destructiveButtonNames:[String]?,cancelButtonNames:[String]?,completionAction:AlertActionHandler?, preferredStyle: UIAlertControllerStyle){
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        if defaultButtonNames != nil {
            for btnName in (defaultButtonNames)! {
                let action = UIAlertAction(title: btnName, style: .default, handler: { (act) in
                    if completionAction == nil {
                        return
                    }
                    completionAction!(act.title!)
                })
                alert.addAction(action)
            }
            
        }
        
        
        if destructiveButtonNames != nil {
            for btnName in (destructiveButtonNames)! {
                let action = UIAlertAction(title: btnName, style: .destructive, handler: { (act) in
                    if completionAction == nil {
                        return
                    }
                    completionAction!(act.title!)
                })
                alert.addAction(action)
            }
        }
        
        
        if cancelButtonNames != nil {
            for btnName in (cancelButtonNames)! {
                let action = UIAlertAction(title: btnName, style: .cancel, handler: { (act) in
                    if completionAction == nil {
                        return
                    }
                    completionAction!(act.title!)
                })
                alert.addAction(action)
            }
        }
        
        showInViewController.present(alert, animated: true, completion: nil)
    }
    
    
    public func showActionSheet(title:String?,showInViewController:UIViewController,defaultButtonNames:[String]?,destructiveButtonNames:[String]?,cancelButtonNames:[String]?,completionAction:AlertActionHandler?){
        
        showAlertActionController(title: title, message: nil, showInViewController: showInViewController, defaultButtonNames: defaultButtonNames, destructiveButtonNames: destructiveButtonNames, cancelButtonNames: cancelButtonNames, completionAction: completionAction, preferredStyle: .actionSheet)
    }
}


// MARK: - Picker View used as input view of fields

extension UIViewController {
    
    func pickerViewAndToolbar(toolBarButtonTitle:String, pickerViewDelegateAndDataSource:Any?, barButtonTarget: Any, barButtonAction:Selector) -> (UIPickerView,UIToolbar) {
        let pickerView = UIPickerView.init(frame: CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:200))
        pickerView.delegate = pickerViewDelegateAndDataSource as? UIPickerViewDelegate
        pickerView.dataSource = pickerViewDelegateAndDataSource as? UIPickerViewDataSource
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        let toolbarWithBarButton = self.toolBar(barButtonTitle: toolBarButtonTitle, barButtonTarget: barButtonTarget, barButtonAction: barButtonAction)
        return (pickerView, toolbarWithBarButton)
    }
    
}


// MARK: - Tool Bar used as input accessory view of fields

extension UIViewController {
    
    func toolBar(barButtonTitle: String, barButtonTarget: Any, barButtonAction: Selector) -> UIToolbar {
        let barButtonItem = UIBarButtonItem(title: barButtonTitle, style: .done, target: barButtonTarget, action: barButtonAction)
        let toolbarWithBarButton = self.toolbar(barButtonItem: barButtonItem)
        return toolbarWithBarButton
    }
    
    func toolbar(barButtonItem: UIBarButtonItem) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:40)
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),barButtonItem]
        return toolbar
    }
    
}


// MARK: - Activity indicator

private var xoAssociationKey: UInt8 = 0

extension UIViewController {
    
    fileprivate var activityView: UIView? {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? UIView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func showActivityIndicator() {
        if UIApplication.shared.isIgnoringInteractionEvents == false {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        if activityView != nil {
            activityView!.removeFromSuperview()
        }
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        let viewHolding = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        viewHolding.backgroundColor = UIColor.black
        viewHolding.layer.cornerRadius = 5
        viewHolding.clipsToBounds = true
        viewHolding.addSubview(activityIndicator)
        let window = UIApplication.shared.delegate!.window!
        window!.addSubview(viewHolding)
        viewHolding.center = window!.center
        activityIndicator.center = CGPoint(x: viewHolding.frame.size.width/2, y: viewHolding.frame.size.height/2)
        activityView = viewHolding
    }
    
    
    func hideActivityIndicator() {
        if UIApplication.shared.isIgnoringInteractionEvents == true {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        if activityView != nil {
            activityView!.removeFromSuperview()
            activityView = nil
        }
    }
    
}

