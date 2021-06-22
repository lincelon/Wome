//
//  AuthService.swift
//  Wome
//
//  Created by Maxim Soroka on 20.06.2021.
//

import UIKit
import Combine
import FirebaseAuth
import FirebaseFirestore

protocol AuthServiceProtocol {
    var currentUserPublisher: AnyPublisher<FirebaseAuth.User?, Never> { get }
    func signup(
       email: String,
       password: String,
       username: String,
       fullname: String,
       image: UIImage
    ) -> AnyPublisher<FirebaseAuth.User, WomeError>
    func logout() -> AnyPublisher<Void, WomeError>
    func login(email: String, password: String) -> AnyPublisher<Void, WomeError>
    func observeAuthChanges() -> AnyPublisher<FirebaseAuth.User?, Never>
}

final class AuthService: AuthServiceProtocol {
    var currentUserPublisher: AnyPublisher<FirebaseAuth.User?, Never> {
        Just(
            Auth.auth().currentUser
        )
        .eraseToAnyPublisher()
    }
    
    func observeAuthChanges() -> AnyPublisher<FirebaseAuth.User?, Never> {
        Publishers.AuthPublisher()
            .eraseToAnyPublisher()
    }
    
    func fetchUser(documentID: String) -> AnyPublisher<User, WomeError> {
        return Future<User, WomeError> { promise in
            Firestore.firestore().collection("users").document(documentID).getDocument { snapshot, error in
                if let error = error {
                    promise(.failure(.default(description: error.localizedDescription)))
                }
                do {
                    guard let user =  try snapshot?.data(as: User.self) else {
                        promise(.failure(.default(description: "Feild to unwarp user")))
                        return
                    }
                    promise(.success(user))
                }
                catch { promise(.failure(.default(description: error.localizedDescription))) }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signup(
        email: String,
        password: String,
        username: String,
        fullname: String,
        image: UIImage
    ) -> AnyPublisher<FirebaseAuth.User, WomeError> {
        return Publishers.UploadImagePublisher(uiImage: image, path: "/images_profile/")
            .flatMap { urlString -> AnyPublisher<FirebaseAuth.User, WomeError> in
                
                return Future<FirebaseAuth.User, WomeError> { promise in
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        if let error = error {
                            promise(.failure(.default(description: error.localizedDescription)))
                            
                        } else if let user = result?.user {
                            Firestore.firestore().collection("users").document(user.uid)
                                .setData([
                                    "email": email,
                                    "username": username,
                                    "fullname": fullname,
                                    "profileImageURL": urlString,
                                    "uid": user.uid
                                ]) { error in
                                    if let error = error {
                                        promise(.failure(.default(description: error.localizedDescription)))
                                    }
                                }
                            
                            promise(.success(user))
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, WomeError> {
        return Future<Void, WomeError> { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
                
            }  catch  { promise(.failure(.default(description: error.localizedDescription))) }
        }
        .eraseToAnyPublisher()
    }
    
    func login(email: String, password: String) -> AnyPublisher<Void, WomeError> {
        let authCredentional = EmailAuthProvider.credential(withEmail: email, password: password)
        
        return Future <Void, WomeError> { promise in
            Auth.auth().signIn(with: authCredentional) { result, error in
                if let error = error {
                    promise(.failure(.auth(description: error.localizedDescription)))
                }
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
}
