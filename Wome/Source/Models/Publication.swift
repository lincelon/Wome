//
//  Publication.swift
//  Wome
//
//  Created by Maxim Soroka on 28.05.2021.
//

import FirebaseFirestoreSwift
import Firebase
import UIKit

struct Publication: Identifiable, Hashable {
    var id = UUID().uuidString
    let type: PublicationType 
    
    enum PublicationType: Hashable {
        case story(Story)
        case post(Post)
    }
     
    struct Post: Identifiable, Hashable {
        var id = UUID().uuidString
        let caption: String?
        let image: Asset?
    }
    
    struct Story: Identifiable, Hashable {
        var id = UUID().uuidString
        let title: String?
        let caption: String?
        let images: [Asset]?
    }
}

//extension Publication.PublicationType {
//
//    private enum CodingKeys: CodingKey {
//        case story
//        case post
//    }
//
//    enum PostTypeCodingError: Error {
//        case decoding(String)
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        if let value = try? values.decode(Publication.Story.self, forKey: .story) {
//            self = .story(value)
//            return
//        }
//        if let value = try? values.decode(Publication.Post.self, forKey: .post) {
//            self = .post(value)
//            return
//        }
//        throw PostTypeCodingError.decoding("Whoops! \(dump(values))")
//    }
//}
