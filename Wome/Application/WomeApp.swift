//
//  WomeApp.swift
//  Wome
//
//  Created by Maxim Soroka on 28.05.2021.
//

import SwiftUI
import Firebase
import Combine

@main
struct WomeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    var body: some Scene {
        WindowGroup {
            Group{
                if appState.isLoggedIn {
                    NavigationMenuView()
                        .transition(AnyTransition.scale(scale: 0, anchor: .topLeading).animation(.default))
                    
                }
                
                if !appState.isLoggedIn { 
                    AuthenticationView()
                        .transition(AnyTransition.scale(scale: 0, anchor: .bottomTrailing).animation(.default))
                }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

class AppState: ObservableObject {
    @Published private(set) var isLoggedIn = false
    @Published private(set) var isLoading = false
    
    private let authService: AuthService
    private var cancellables: [AnyCancellable] = []
    
    init(authService: AuthService = AuthService()) {
        self.authService = authService
        
        authService
            .observeAuthChanges()
            .map { $0 != nil }
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    isLoading = false
                }
            } receiveValue: { [unowned self] x in
                isLoggedIn = x
                isLoading = !x
            }
            .store(in: &cancellables)
    }
}

