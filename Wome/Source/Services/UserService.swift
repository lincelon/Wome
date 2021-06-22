//
//  UserService.swift
//  Wome
//
//  Created by Maxim Soroka on 20.06.2021.
//

import UIKit
import Combine
import FirebaseAuth
import FirebaseFirestore

protocol UserServiceProtocol {
    var currentUserPublisher: AnyPublisher<FirebaseAuth.User?, Never> { get }
}

final class UserService: UserServiceProtocol {
    var currentUserPublisher: AnyPublisher<FirebaseAuth.User?, Never> {
        Just(
            Auth.auth().currentUser
        )
        .eraseToAnyPublisher()
    }
    
    func updateSettings(username: String, fullName: String, image: UIImage?) -> AnyPublisher<User, WomeError> {
        Publishers.UploadImagePublisher(uiImage: image, path: "/images_profile/")
            .flatMap { [weak self] urlString -> AnyPublisher<User, WomeError> in
                guard let self = self else { return
                    Just(User(id: "", username: "", fullname: "", email: "", profileImageURL: ""))
                    .setFailureType(to: WomeError.self)
                    .eraseToAnyPublisher()
                }
                
                return self.currentUserPublisher
                    .compactMap { $0?.uid }
                    .flatMap { uid -> AnyPublisher<User, WomeError> in
                       return Future<Void, WomeError> { promise in
                            Firestore.firestore().collection("users").document(uid)
                                .updateData(
                                   urlString == nil ? [
                                        "fullname" : fullName,
                                        "username" : username,
                                    ] : [
                                        "fullname" : fullName,
                                        "username" : username,
                                        "profileImageURL" : urlString ?? ""
                                    ]
                                ) { error in
                                    if let error = error {
                                        promise(.failure(.default(description: error.localizedDescription)))
                                    } else {
                                        promise(.success(()))
                                    }
                                }
                        }
                        .flatMap { () -> AnyPublisher<User, WomeError> in
                            self.fetchUser(documentID: uid)
                        }
                        .eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
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
    
    func observeUserProfile(userID: String) -> AnyPublisher<User, WomeError> {
        let listenerPath = Firestore.firestore().collection("users").document(userID)

        return Publishers.DocumentSnapshotPublisher(listenerPath: listenerPath)
            .flatMap { documentSnapshot -> AnyPublisher<User, WomeError> in
                if let data = documentSnapshot.data() {
                    print("Like that", data)
                }
                
                do {
                    let user = try documentSnapshot.data(as: User.self)
                    
                    return Just(user ?? User(id: "", username: "", fullname: "", email: "", profileImageURL: ""))
                        .setFailureType(to: WomeError.self)
                        .eraseToAnyPublisher()
                    
                } catch {
                    return Fail(error: .default(description: "Parse error"))
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
