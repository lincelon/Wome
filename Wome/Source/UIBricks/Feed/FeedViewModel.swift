//
//  FeedViewModel.swift
//  Wome
//
//  Created by Maxim Soroka on 28.05.2021.
//

import UIKit
import Combine
import FirebaseAuth

final class FeedViewModel: ObservableObject {
    //MARK: -
    @Published var publications: [Publication] = MockData.feedPublications
    
    @Published private(set) var selectedFilter: ContentFilter = .all
    @Published var selectedStory: Publication.Story?
    
    @Published var admin: User?
    @Published var currentUser: User?
    //MARK: - FeedShowActions properties
    @Published var feedShowAction: FeedShowAction = .none
    @Published var applyViewTransition: Bool = false
    @Published var applyViewDelay: Bool = false
    
    //MARK: -
    @Published var isLandscape: Bool = !UIDevice.current.orientation.isPortrait
    
    private let userService: UserService
    private let feedService: FeedService
    private var cancellables: [AnyCancellable] = []
    
    var filteredPublications: [Publication] {
        switch selectedFilter {
        case .all:
            return publications
        case .story:
            return publications.filter {
                if case .story(_) = $0.type { return true }
                else { return false }
            }
        case .post:
            return publications.filter {
                if case .post(_) = $0.type { return true }
                else { return false }
            }
        }
    }
    
    func send(action: Action) {
        switch action {
        case .filterPublications(filter: let filter):
            self.selectedFilter = filter
        case .show(feedShowAction: let feedShowAction):
            self.feedShowAction = feedShowAction
        }
    }
    
    init(userService: UserService = UserService(),
         feedService: FeedService = FeedService()) {
        self.userService = userService
        self.feedService = feedService
        
        userService
            .fetchUser(documentID: AppConstants.adminID)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] user in
                self?.admin = user
            }
            .store(in: &cancellables)
        
            
//        feedService
//            .observePosts()
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            } receiveValue: { [weak self] publications in
//                self?.publications = publications
//            }
//            .store(in: &cancellables)
    
        userService
            .observeUserProfile(userID: Auth.auth().currentUser?.uid ?? "")
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

extension FeedViewModel {
    enum Action {
        case filterPublications(filter: ContentFilter)
        case show(feedShowAction: FeedShowAction)
    }
    
    enum ContentFilter: String, CaseIterable {
        case all
        case story
        case post
    }
    
    enum FeedShowAction {
        case chat
        case publicationCreation
        case toolbar
        case none
    }
}
