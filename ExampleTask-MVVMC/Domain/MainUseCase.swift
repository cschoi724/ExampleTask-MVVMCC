//
//  MainUseCase.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/10.
//

import Foundation
import RxCocoa
import RxSwift

protocol MainUseCase {
    var maleUserList: BehaviorRelay<UserProfileList> { get }
    var femaleUserList: BehaviorRelay<UserProfileList> { get }

    func comminInit()
    func pullToRefresh(_ gender: UserGender)
    func updateRequest(_ gender: UserGender)
    func delete(_ males: [String], _ females: [String])
}

class ImpMainUseCase: MainUseCase {
    private let randomUserRepository: RandomUserRepository
    var maleUserList = BehaviorRelay<UserProfileList>(
        value: UserProfileList(list: [], page: 1)
    )
    var femaleUserList = BehaviorRelay<UserProfileList>(
        value: UserProfileList(list: [], page: 1)
    )
    
    init(randomUserRepository: RandomUserRepository) {
        self.randomUserRepository = randomUserRepository
    }
    
    func comminInit() {
        pullToRefresh(.male)
        pullToRefresh(.female)
    }
    
    func delete(_ males: [String], _ females: [String]) {
        var maleUserlist = maleUserList.value
        maleUserlist.list = maleUserlist.list
            .filter{ males.contains($0.id) == false }
        maleUserList.accept(maleUserlist)
        
        var femaleUserlist = femaleUserList.value
        femaleUserlist.list = femaleUserlist.list
            .filter{ females.contains($0.id) == false }
        femaleUserList.accept(femaleUserlist)
    }
 
    func pullToRefresh(_ gender: UserGender){
        fetchUserList(
            gender,
            page: 1,
            pageCount: 20,
            completion: { [weak self] userList in
                guard let self = self else { return }
                switch gender {
                case .male:
                    self.maleUserList.accept(userList)
                case .female:
                    self.femaleUserList.accept(userList)
                }
            }
        )
    }
    
    func updateRequest(_ gender: UserGender) {
        let oldUserList = gender == .female ?
        femaleUserList.value :
        maleUserList.value
        fetchUserList(
            gender,
            page: oldUserList.page + 1,
            pageCount: 20,
            completion: { [weak self] userList in
                guard let self = self else { return }
                var newUserList = userList
                guard newUserList.page > oldUserList.page else {
                     return
                }
                newUserList.list.insert(contentsOf: oldUserList.list, at: 0)
                newUserList.list = newUserList.list.uniqued()
                switch gender {
                case .male:
                    self.maleUserList.accept(newUserList)
                case .female:
                    self.femaleUserList.accept(newUserList)
                }
            }
        )
    }
    
    func fetchUserList(
        _ gender: UserGender,
        page: Int,
        pageCount: Int,
        completion: @escaping (UserProfileList)->Void
    ) {
        let requestDTO = UserRequestDTO(
            gender: gender.rawValue,
            page: page,
            results: pageCount
        )
        randomUserRepository.fetchRandomUserList(
            requestDTO,
            completionHandler: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let dto):
                    completion(self.userListResolve(dto))
                case .failure(let error):
                    print(error)
                }
            }
        )
    }
    
    func userProfileResolve(_ userDTO: UserDTO) -> UserProfile{
        return UserProfile(
            id: userDTO.login.username,
            gender: UserGender(rawValue: userDTO.gender),
            name: "\(userDTO.name.title) \(userDTO.name.first) \(userDTO.name.last)",
            email: userDTO.email,
            age: "\(userDTO.dob.age)",
            phone: userDTO.phone,
            cell: userDTO.cell,
            picture: userDTO.picture.large,
            loaction: "\(userDTO.location.street.number) \(userDTO.location.street.name) \(userDTO.location.city) \(userDTO.location.state) \(userDTO.location.postcode) \(userDTO.location.country)"
        )
    }
    
    func userListResolve(_ userListDTO: UserResponseDTO) -> UserProfileList {
        return UserProfileList(
            list: userListDTO.results.map{ self.userProfileResolve($0) },
            page: userListDTO.info.page
        )
    }
}
