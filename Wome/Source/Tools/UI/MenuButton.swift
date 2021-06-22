//
//  MenuButton.swift
//  Wome
//
//  Created by Maxim Soroka on 18.06.2021.
//

import SwiftUI

struct MenuButton: View {
    let widthAndHeight: CGFloat
    let action: () -> ()
    
    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 0.3)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                
                VStack(spacing: 5) {
                    ForEach(0..<2, id: \.self) { _ in
                        HStack(spacing: 5) {
                            ForEach(0..<2, id: \.self) { _ in
                                Circle()
                                    .fill(Color.womeBlack)
                                    .frame(
                                        width: widthAndHeight * 0.15,
                                        height: widthAndHeight * 0.15
                                    )
                            }
                        }
                    }
                }
            }
        }
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButton(widthAndHeight: 35) { }
    }
}
