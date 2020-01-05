//
//  StoryboardInstantiable.swift
//  Beam
//
//  Created by Ryan Smith on 5/19/19.
//  Copyright © 2019 Ryan Smith. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardInstantiable: NSObjectProtocol {
    associatedtype MyType
    static var defaultFilename: String { get }
    static func instantiateViewController(_ bundle: Bundle?) -> MyType
}

extension StoryboardInstantiable where Self: UIViewController {
    static var defaultFilename: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }

    static func instantiateViewController(_ bundle: Bundle? = nil) -> Self {
        let filename = defaultFilename
        let storyboard = UIStoryboard(name: filename, bundle: bundle)

        return storyboard.instantiateInitialViewController() as! Self
    }

    static func instantiateViewController(withIdentifier identifier: String, bundle: Bundle? = nil) -> Self {
        let filename = defaultFilename
        let storyboard = UIStoryboard(name: filename, bundle: bundle)

        return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
    }
}
