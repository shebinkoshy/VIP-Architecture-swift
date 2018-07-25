//
//  StoryboardProtocol.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import Foundation
import UIKit

protocol TPStoryboardProtocol {
    static func instance(storyboardName:String, bundle:Bundle?) -> UIViewController
}
