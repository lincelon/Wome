//
//  User.swift
//  Wome
//
//  Created by Maxim Soroka on 20.06.2021.
//

import FirebaseFirestoreSwift
import Foundation

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var username: String
    let fullname: String
    let email: String
    let profileImageURL: String
    
    var isAdmin: Bool {
        id == AppConstants.adminID
    }
}
