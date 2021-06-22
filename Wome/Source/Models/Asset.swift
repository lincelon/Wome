//
//  Asset.swift
//  Wome
//
//  Created by Maxim Soroka on 28.05.2021.
//

import UIKit

struct Asset: Identifiable, Hashable {
    let id = UUID().uuidString
    let image: UIImage
}
