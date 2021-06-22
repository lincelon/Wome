//
//  WomeError.swift
//  Wome
//
//  Created by Maxim Soroka on 20.06.2021.
//

import Foundation


enum WomeError: LocalizedError {
    case auth(description: String)
    case `default`(description: String? = nil)
    
    var errorDescription: String? {
        switch self {
        case let .auth(description):
            return description
        case let .default(description):
            return description ?? "Something went wrong"
        }
    }
}
