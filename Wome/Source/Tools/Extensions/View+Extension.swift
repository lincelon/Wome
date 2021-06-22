//
//  View+Extension.swift
//  Wome
//
//  Created by Maxim Soroka on 31.05.2021.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication
            .shared
            .sendAction(
                #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
            )
    }
}
#endif
