//
//  Clothes.swift
//  Wome
//
//  Created by Maxim Soroka on 19.06.2021.
//

import Foundation

struct Clothes: Identifiable, Hashable {
    let id = UUID().uuidString
    let image: String
    let name: String
    let description: String
    let price: Int
    let type: ClothesType
    
    enum ClothesType {
        case dress
        case coat
        case suit
    }
}
