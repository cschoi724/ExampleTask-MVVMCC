//
//  DetailCoordinator.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/10.
//

import UIKit

protocol DetailCoordinator: Coordinator {
    func start(_ userProfile: UserProfile)
}

class ImpDetailCoordinator: DetailCoordinator {
    var nav: UINavigationController
    var viewController: DetailViewController
    var childCoordinators: [Coordinator] = []
    var delegate: CoordinatorDelegate?
    
    required init(_ nav: UINavigationController) {
        self.nav = nav
        self.viewController = DetailViewController.instance
    }
    
    func start(_ userProfile: UserProfile) {
        viewController.viewModel = DetailViewModel(
            coordinator: self,
            detailUseCase: ImpDetailUseCase(userPorifle: userProfile)
        )
        nav.pushViewController(viewController, animated: true)
    }
    
    func finish(animated: Bool, completionHandler: CompletionHandler?) {
        nav.popViewController(animated: true)
        delegate?.childFinished(self)
        if let handler = completionHandler {
            handler()
        }
    }
}
