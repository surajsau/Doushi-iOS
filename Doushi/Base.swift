//
//  Base.swift
//  Doushi
//
//  Created by Suraj Sau on 07/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardInitializable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardInitializable where Self: UIViewController {

    static func initFromStoryboard(name: String = "Main") -> Self {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}
