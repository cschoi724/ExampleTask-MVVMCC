//
//  DetailUseCase.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/12.
//

import Foundation
import RxCocoa
import RxSwift

protocol DetailUseCase {
    var userPorifle: UserProfile { get set }
}

class ImpDetailUseCase: DetailUseCase {
    var userPorifle: UserProfile
    
    init(userPorifle: UserProfile) {
        self.userPorifle = userPorifle
    }
}
