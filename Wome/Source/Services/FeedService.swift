//
//  FeedService.swift
//  Wome
//
//  Created by Maxim Soroka on 21.06.2021.
//

import UIKit
import Combine
import FirebaseAuth
import FirebaseFirestore

final class FeedService {
    var currentUserPublisher: AnyPublisher<FirebaseAuth.User?, Never> {
        Just(
            Auth.auth().currentUser
        )
        .eraseToAnyPublisher()
    }
    
    func uploadPost(
                    uiImage: UIImage?,
                    title: String,
                    caption: String,
                    publicationType: PublicationCreationViewModel.PublicationTypeSelection
    ) -> AnyPublisher<Void, WomeError> {
        Publishers.UploadImagePublisher(uiImage: uiImage, path: "/images_profile/")
            .flatMap { urlString -> AnyPublisher<Void, WomeError> in
                return Future<Void, WomeError> { promise in
                    let publicationID = UUID().uuidString
                    var data: [String : Any]
                    
                    switch publicationType {
                    case .story:
                        data = [
                            "publicationID": publicationID,
                            "publicationType": publicationType.rawValue,
                            "images" : urlString ?? "",
                            "title": title,
                            "caption": caption,
                            "likes" : 0,
                            "timestamp": Timestamp(date: Date()),
                            "comments":  []
                        ]
                    case .post:
                        data = [
                            "publicationID": publicationID,
                            "publicationType": publicationType.rawValue,
                            "image" : urlString ?? "",
                            "caption": caption,
                            "timestamp": Timestamp(date: Date()),
                        ]
                    }

                    Firestore.firestore().collection("publications").document()
                        .setData(data) { error in
                        if let error = error {
                            promise(.failure(.default(description: error.localizedDescription)))
                        }
                        promise(.success(()))
                    }
            }
            .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
//    
//    func observePosts() -> AnyPublisher<[Publication], WomeError> {
//
//        let ref = Firestore.firestore().collection("publications")
//
//        return Publishers.QuerySnapshotPublisher(listenerPath: .collection(ref))
//            .flatMap { querySnapshot -> AnyPublisher<[Publication], WomeError> in
//                do {
//                    let publications =  try querySnapshot.documents
//                        .compactMap { try $0.data(as: Publication.self) }
//
//                    return Just(publications)
//                        .setFailureType(to: WomeError.self)
//                        .eraseToAnyPublisher()
//
//                } catch {
//                    return Fail(error: .default(description: "Parse error"))
//                        .eraseToAnyPublisher()
//                }
//            }
//            .eraseToAnyPublisher()
//    }
}
