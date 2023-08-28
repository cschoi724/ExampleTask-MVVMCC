//
//  MainCoordinator.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/10.
//

import UIKit

protocol MainCoordinator: Coordinator {
    func start()
    func showDetail(_ userProfile: UserProfile)
}

class ImpMainCoordinator: MainCoordinator {
    var nav: UINavigationController
    var viewController: MainViewController
    var childCoordinators: [Coordinator] = []
    var delegate: CoordinatorDelegate?
    
    required init(_ nav: UINavigationController) {
        self.nav = nav
        self.viewController = MainViewController.instance
    }
    
    func finish(animated: Bool, completionHandler: CompletionHandler?) {
        nav.popViewController(animated: false)
        delegate?.childFinished(self)
        if let handler = completionHandler {
            handler()
        }
    }
    
    func start() {
        viewController.viewModel = MainViewModel(
            coordinator: self,
            mainUseCase: ImpMainUseCase(
                randomUserRepository: ImpRandomUserRepository(
                    networkService: AppDelegate.appContainer.networkService
                )
            )
        )
        nav.pushViewController(viewController, animated: false)
    }
    
    func showDetail(_ userProfile: UserProfile) {
        let coordinator: DetailCoordinator = ImpDetailCoordinator(nav)
        coordinator.delegate = self
        coordinator.start(userProfile)
        childCoordinators.append(coordinator)
    }
}
