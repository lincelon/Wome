//
//  AuthenticationViewModel.swift
//  Wome
//
//  Created by Maxim Soroka on 19.06.2021.
//

import UIKit
import Combine

final class AuthenticationViewModel: ObservableObject {
    @Published var showAuthenticationView = true
    @Published var showLoginView = false 
    @Published var showSignupView = false
    @Published var showSignUpFromAuthView = false
    @Published var showPhotoPicker = false
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var username: String = ""
    @Published var fullName: String = ""
    @Published var selectedAssets: [UIImage] = []
    
    @Published var currentUser: User?
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var emailValidation: FormValidation = FormValidation()
    @Published var passwordValidation: FormValidation = FormValidation()
    @Published var usernameValidation: FormValidation = FormValidation()
    @Published var fullNameValidation: FormValidation = FormValidation()
    
    @Published var canLogin: Bool = false
    @Published var canSignup: Bool = false
    
    struct Config {
        static let recommendedLength = 6
        static let specialCharacters = "!@#$%^&*()?/|\\:;"
        static let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        static let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}$")
        static let fullNamePredicate = NSPredicate(format:"SELF MATCHES %@", "^[a-zA-Z]{4,}(?: [a-zA-Z]+){0,2}$")
    }
    
    enum Action {
        case signup
        case login
        case logout
    }
    
    private let userService: UserService
    private let authService: AuthService
    private var cancellables: [AnyCancellable] = []
    
    init(userService: UserService = UserService(),
         authService: AuthService = AuthService()) {
        self.userService = userService
        self.authService = authService
        
        
        emailPublisher
            .assign(to: \.emailValidation, on: self)
            .store(in: &cancellables)
        
        passwordPublisher
            .assign(to: \.passwordValidation, on: self)
            .store(in: &cancellables)
        
        fullNamePublisher
            .assign(to: \.fullNameValidation, on: self)
            .store(in: &cancellables)
        
        usernamePublisher
            .assign(to: \.usernameValidation, on: self)
            .store(in: &cancellables)
        
        
        Publishers.CombineLatest(emailPublisher, passwordPublisher)
            .map { emailValidation, passwordValidation  in
                emailValidation.isSucceed && passwordValidation.isSucceed
            }
            .assign(to: \.canLogin, on: self)
            .store(in: &cancellables)
        
        
        Publishers.CombineLatest4(emailPublisher, passwordPublisher, usernamePublisher, fullNamePublisher)
            .map { emailValidation, passwordValidation, usernameValidation, fullNameValidation  in
                emailValidation.isSucceed && passwordValidation.isSucceed && usernameValidation.isSucceed && fullNameValidation.isSucceed
            }
            .assign(to: \.canSignup, on: self)
            .store(in: &cancellables)
    }
    
    func send(action: Action) {
        switch action {
        case .signup:
            isLoading = true
            authService
                .signup(
                    email: email,
                    password: password,
                    username: username,
                    fullname: fullName,
                    image: selectedAssets.first == nil
                        ? (UIImage(named: "avatar") ?? UIImage())
                        : selectedAssets.first ?? UIImage()
                )
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.isLoading = false
                        print("Successfully created a user")
                    case let .failure(error):
                        self?.isLoading = false
                        self?.errorMessage = error.localizedDescription
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self]  _ in
                    self?.isLoading = false
                }
                .store(in: &cancellables)
            
        case .login:
            authService
                .login(email: email, password: password)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.isLoading = false
                        print("Successfully created a user")
                    case let .failure(error):
                        self?.isLoading = false
                        self?.errorMessage = error.localizedDescription
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self]  _ in
                    self?.isLoading = false
                }
                .store(in: &cancellables)
        case .logout:
            
            email = ""
            username = ""
            fullName = ""
        }
    }
    
    private var emailPublisher: AnyPublisher<FormValidation, Never> {
        $email
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { email in
                if email.isEmpty {
                    return FormValidation(isSucceed: false, message: "")
                }
                
                if !Config.emailPredicate.evaluate(with: email) {
                    return FormValidation(isSucceed: false, message: "Invalid email address")
                }
                
                return FormValidation(isSucceed: true, message: "")
            }
            .eraseToAnyPublisher()
    }
    
    private var passwordPublisher: AnyPublisher<FormValidation, Never> {
        $password
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                if password.isEmpty {
                    return FormValidation(isSucceed: false, message: "")
                }
                
                if password.count < Config.recommendedLength {
                    return FormValidation(isSucceed: false, message: "The password length must be greater than \(Config.recommendedLength)")
                }
                
                if !Config.passwordPredicate.evaluate(with: password) {
                    return FormValidation(isSucceed: false, message: "The password is must contain numbers, uppercase and special characters")
                }
                
                return FormValidation(isSucceed: true, message: "")
            }
            .eraseToAnyPublisher()
    }
    
    private var usernamePublisher: AnyPublisher<FormValidation, Never> {
        $username
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { username in
                if username.isEmpty {
                    return FormValidation(isSucceed: false, message: "")
                }
                
                return FormValidation(isSucceed: true, message: "")
            }
            .eraseToAnyPublisher()
    }
    
    private var fullNamePublisher: AnyPublisher<FormValidation, Never> {
        $fullName
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { fullName in
                if fullName.isEmpty {
                    return FormValidation(isSucceed: false, message: "")
                }
                
                if !Config.fullNamePredicate.evaluate(with: fullName) {
                    return FormValidation(isSucceed: false, message: "Full name must contains only letters")
                }
                
                return FormValidation(isSucceed: true, message: "")
            }
            .eraseToAnyPublisher()
    }
}

