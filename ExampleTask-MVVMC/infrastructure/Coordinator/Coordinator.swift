//
//  Coordinator.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/12.
//

import UIKit

protocol CoordinatorDelegate: AnyObject {
    func childFinished(_ coordinator: Coordinator)
}

protocol Coordinator: AnyObject, CoordinatorDelegate {
    var nav: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var delegate: CoordinatorDelegate? { get set }
    
    func finish(animated: Bool, completionHandler: CompletionHandler?)
    
    init(_ nav: UINavigationController)
}

extension Coordinator {
    func childFinished(_ coordinator: Coordinator) {
        self.childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    func finish(animated: Bool = true) {
        childCoordinators.forEach { $0.finish(animated: false) }
        childCoordinators.removeAll()
        nav.popViewController(animated: animated)
        delegate?.childFinished(self)
    }
}
