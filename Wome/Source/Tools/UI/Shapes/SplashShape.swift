//
//  SplashShape.swift
//  Wome
//
//  Created by Maxim Soroka on 31.05.2021.
//

import SwiftUI

struct SplashShape: Shape {
    var progress: CGFloat
    
    var animatableData: CGFloat {
        get { return progress }
        set { progress = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - (rect.height * progress)))
        path.addLine(to: CGPoint(x: 0, y: rect.height - (rect.height * progress)))

        return path
    }
}
