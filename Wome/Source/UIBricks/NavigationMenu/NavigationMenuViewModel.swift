//
//  NavigationMenuViewModel.swift
//  Wome
//
//  Created by Maxim Soroka on 18.06.2021.
//

import UIKit
import Combine

final class NavigationMenuViewModel: ObservableObject {
    @Published var selectedNavigationMenuComponent: NavigationMenuComponent = .shop
    @Published var showNavigationMenu = false
    @Published var currentUser: User?
    
    private let authService: AuthService
    private let userService: UserService
    private var cancellables: [AnyCancellable] = []
    
    init(
        authService: AuthService = AuthService(),
        userService: UserService = UserService()) {
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
            }
            .store(in: &cancellables)
        
        userService
            .currentUserPublisher
            .compactMap { $0?.uid }
            .flatMap { userService.observeUserProfile(userID: $0) }
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] user in
                self?.currentUser = user
            }
            .store(in: &cancellables)
    }
    
}

extension NavigationMenuViewModel {
    enum NavigationMenuComponent: String, CaseIterable {
        case shop
        case notifications
        case feed
        case profile
        
        var systemImageName: String {
            switch self {
            case .shop:
                return "square.3.stack.3d"
            case .notifications:
                return "bell"
            case .feed:
                return "newspaper"
            case .profile:
                return "person"
            }
        }
    }
}
