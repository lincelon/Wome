//
//  Font+Extension.swift
//  Wome
//
//  Created by Maxim Soroka on 04.06.2021.
//

import SwiftUI

extension Font {
    static func montserratRegular(size: CGFloat) -> Font {
        Font.custom("Montserrat-Regular", size: size)
    }
    
    static func montserratBold(size: CGFloat) -> Font {
        Font.custom("Montserrat-Bold", size: size)
    }
    
    static func montserratSemiBold(size: CGFloat) -> Font {
        Font.custom("Montserrat-SemiBold", size: size)
    }
    
    static func openSansSemiBold(size: CGFloat) -> Font {
        Font.custom("OpenSans-SemiBold", size: size)
    }
    
    static func openSansBold(size: CGFloat) -> Font {
        Font.custom("OpenSans-Bold", size: size)
    }
    
    static func openSansRegular(size: CGFloat) -> Font {
        Font.custom("OpenSans-Regular", size: size)
    }
    
    static func openSansLight(size: CGFloat) -> Font {
        Font.custom("OpenSans-Light", size: size)
    }
    
    static func openSansBoldItalic(size: CGFloat) -> Font {
        Font.custom("OpenSans-BoldItalic", size: size)
    }
}
