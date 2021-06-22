//
//  ProfileViewModel.swift
//  Wome
//
//  Created by Maxim Soroka on 21.06.2021.
//

import UIKit
import Combine

final class ProfileViewModel: ObservableObject {
    @Published var fullname = ""
    @Published var username = ""
    @Published var inProgress = false
    @Published var isCompleted = false
    @Published var showPhotoPicker = false
    @Published var pickedAsssets: [UIImage] = []
    @Published var currentUser: User?
    
    enum Action {
        case logout
        case updateSettings
    }
    
    private let authService: AuthService
    private let userService: UserService
    private var cancellables: [AnyCancellable] = []
    
    func sendAction(action: Action) {
        switch action {
        case .logout:
            authService
                .logout()
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Logged out")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                } receiveValue: { _ in
                    
                }
                .store(in: &cancellables)
            
        case .updateSettings:
            isCompleted = false
                userService
                    .updateSettings(
                        username: username,
                        fullName: fullname,
                        image: pickedAsssets.first
                    )
                    .sink { [weak self] completion in
                        switch completion {
                        case .finished:
                            self?.isCompleted = true
                        case let .failure(error):
                            self?.isCompleted = true
                            print(error.localizedDescription)
                        }
                    } receiveValue: { [weak self] user in
                        self?.currentUser = user
                        self?.isCompleted = true
                    }
                    .store(in: &cancellables)
        }
    }
    
    init(
        authService: AuthService = AuthService(),
        userService: UserService = UserService()
    ) {
        self.authService = authService
        self.userService = userService
        
        authService
            .currentUserPublisher
            .compactMap { $0?.uid }
            .flatMap {  authService.fetchUser(documentID: $0) }
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] user in
                guard let self = self else { return }
                
                self.currentUser = user
                self.username = user.username
                self.fullname = user.fullname
            }
            .store(in: &cancellables)
    }
}
