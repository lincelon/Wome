//
//  ShopViewModel.swift
//  Wome
//
//  Created by Maxim Soroka on 19.06.2021.
//

import Foundation
import Combine

final class ShopViewModel: ObservableObject {
    @Published var clothes: [Clothes] = MockData.clothes
    @Published var selectedClothesFilter: ClothesFilter = .all
    @Published var selectedClothes: Clothes?
    @Published var showDetails = false
    @Published var currentUser: User?
    
    private let authService: AuthService
    private var cancellables: [AnyCancellable] = [] 
    
    var filteredClothes: [Clothes] {
        switch selectedClothesFilter {
        case .all:
            return clothes
        case .dress:
            return clothes.filter { $0.type == .dress }
        case .coat:
            return clothes.filter { $0.type == .coat }
        case .suit:
            return clothes.filter { $0.type == .suit }
        }
    }
    
    init(authService: AuthService = AuthService()) {
        self.authService = authService

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
    }
}

extension ShopViewModel {
    enum ClothesFilter: String, CaseIterable {
        case all
        case dress
        case coat
        case suit
    }
}
