//
//  LayoutAdaptation.swift
//  Wome
//
//  Created by Maxim Soroka on 02.06.2021.
//

import SwiftUI

struct LayoutAdaptation {
    static func getViewWidth(with bounds: GeometryProxy, padding: CGFloat) -> CGFloat {
        bounds.size.width > 712 ? 712 : bounds.size.width - padding * 2
    }
    
    static func getPublicationWidth(
        with bounds: GeometryProxy,
        isLandscape: Binding<Bool>,
        horizontalSizeClass: UserInterfaceSizeClass
        ) -> CGFloat {
        let condition: CGFloat = bounds.size.width < 712 && horizontalSizeClass == .regular ? 2 : 3
    
        if isLandscape.wrappedValue {
            return bounds.size.width / (horizontalSizeClass == .compact ? 1 : condition)
            
        } else { return bounds.size.width / (horizontalSizeClass == .compact ? 1 : 2) }
    }
    
    static func getDetailsHeight(with bounds: GeometryProxy, horizontalSizeClass: UserInterfaceSizeClass) -> CGFloat? {
        horizontalSizeClass == .regular && bounds.size.width < 712 ? 850 : bounds.size.width * 0.7
    }
    
    static func largeScreenCondition(with bounds: GeometryProxy, horizontalSizeClass: UserInterfaceSizeClass) -> Bool {
        horizontalSizeClass == .regular && bounds.size.width < 712
    }
}
