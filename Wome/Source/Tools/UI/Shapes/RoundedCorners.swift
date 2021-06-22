//
//  RoundedCorners.swift
//  Wome
//
//  Created by Maxim Soroka on 30.05.2021.
//

import SwiftUI

struct RoundedCorners: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}
