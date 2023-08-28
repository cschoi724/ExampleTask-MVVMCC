//
//  AppContainer.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/12.
//

import Foundation

protocol AppContainer {
    var networkService: NetworkService { get }
}

class ImpAppContainer: AppContainer {
    
    var networkService: NetworkService
    
    init() {
        networkService = AlamofireService(
            config: APINetworkConfig(
                baseURL: URL(string: "https://randomuser.me/api")!
            )
        )
    }
}
