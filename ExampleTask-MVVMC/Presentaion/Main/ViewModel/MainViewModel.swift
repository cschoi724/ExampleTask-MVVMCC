//
//  MainViewModel.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/10.
//

import Foundation
import RxCocoa
import RxSwift

class MainViewModel {
    
    let coordinator: MainCoordinator
    let mainUseCase: MainUseCase
    
    init(coordinator: MainCoordinator, mainUseCase: MainUseCase) {
        self.coordinator = coordinator
        self.mainUseCase = mainUseCase
    }
    
    struct Input {
        let viewDidApear: Observable<Void>
        let updateRequest: Observable<UserGender>
        let pullToRefresh: Observable<UserGender>
        let userTap: Observable<UserProfile>
        let deleteItem: Observable<([String], [String])>
    }
    
    struct Output {
        let maleList = BehaviorRelay<[UserProfile]>(value: [])
        let femaleList = BehaviorRelay<[UserProfile]>(value: [])
    }
    
    func transform(_ bag: DisposeBag, input: Input) -> Output{
        let output = Output()
        
        input.viewDidApear
            .take(1)
            .withUnretained(self)
            .bind{ this, _ in
                this.mainUseCase.comminInit()
            }
            .disposed(by: bag)
        
        input.updateRequest
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind{ this, gender in
                this.mainUseCase.updateRequest(gender)
            }
            .disposed(by: bag)
        
        input.pullToRefresh
            .withUnretained(self)
            .bind{ this, gender in
                this.mainUseCase.pullToRefresh(gender)
            }
            .disposed(by: bag)
        
        input.userTap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind{ this, userProfile in
                this.coordinator.showDetail(userProfile)
            }
            .disposed(by: bag)
        
        input.deleteItem
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind{ this, item  in
                this.mainUseCase.delete(item.0, item.1)
            }
            .disposed(by: bag)
        
        mainUseCase
            .femaleUserList
            .map{ $0.list }
            .bind(to: output.femaleList)
            .disposed(by: bag)
        
        mainUseCase
            .maleUserList
            .map{ $0.list }
            .bind(to: output.maleList)
            .disposed(by: bag)
        
        return output
    }
}
