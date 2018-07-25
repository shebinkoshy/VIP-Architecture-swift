//
//  TPCell.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UICollectionViewCell: ReusableView {
}

extension UITableViewCell : ReusableView {
    
}
