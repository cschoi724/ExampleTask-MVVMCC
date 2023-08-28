//
//  BaseController.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/12.
//

import UIKit

protocol BaseController where Self: UIViewController {}

extension BaseController {
    static var instance: Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib()
    }
}
