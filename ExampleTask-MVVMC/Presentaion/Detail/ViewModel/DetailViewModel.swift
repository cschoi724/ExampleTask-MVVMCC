//
//  DetailViewModel.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/10.
//

import Foundation
import RxCocoa
import RxSwift

class DetailViewModel {
    private weak var coordinator: DetailCoordinator!
    private let detailUseCase: DetailUseCase
    
    init(coordinator: DetailCoordinator, detailUseCase: DetailUseCase) {
        self.coordinator = coordinator
        self.detailUseCase = detailUseCase
    }
    
    struct Inputs {
        let viewWillApear: Observable<Void>
        let closeTap: Observable<Void>
        let closeSwipe: Observable<Void>
    }
    
    struct Outputs {
        let userProfile = BehaviorRelay<UserProfile?>(value: nil)
    }
    
    func transform(_ bag: DisposeBag, inputs: Inputs) -> Outputs{
        let output = Outputs()
        
        inputs.viewWillApear
            .withUnretained(self)
            .bind{ this, _ in
                output.userProfile.accept(this.detailUseCase.userPorifle)
            }
            .disposed(by: bag)
        
        inputs.closeTap
            .withUnretained(self)
            .bind{ this, _ in
                this.coordinator.finish(animated: true, completionHandler: nil)
            }
            .disposed(by: bag)
        
        inputs.closeSwipe
            .withUnretained(self)
            .bind{ this, _ in
                this.coordinator.finish(animated: true, completionHandler: nil)
            }
            .disposed(by: bag)
        
        return output
    }
}
