//
//  ActionMenu.swift
//  Wome
//
//  Created by Maxim Soroka on 01.06.2021.
//

import SwiftUI

struct ActionMenu: View {
    @EnvironmentObject private var viewModel: PublicationCreationViewModel
    
    @State private var viewState: CGSize = .zero
    @State private var isOpened = true
    
    let completion: () -> ()
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.womeBlack)
                .frame(width: 4, height: 22)
                .padding(.trailing, 12) 
            
            Button {
                viewModel.showPhotoPicker = true
            } label: {
                Circle()
                    .fill(Color.white)
                    .frame(width: 75, height: 75)
                    .shadow(color: Color.womeBlack.opacity(0.3), radius: 6, x: 7, y: 4)
                    .overlay(
                        Image("assets-icon")
                            .renderingMode(.template)
                            .foregroundColor(.womePink)
                    )
            }
            
            Circle()
                .fill(Color.womePink)
                .frame(width: 75, height: 75)
                .shadow(color: Color.womePink.opacity(0.3), radius: 6, x: 7, y: 4)
                .overlay(
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                )
                .onLongPressGesture {
                    completion()
                }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedCorners(corners: [.bottomLeft, .topLeft], radius: 30))
        .shadow(color: Color.womeBlack.opacity(0.3), radius: 6, x: 7, y: 4)
        .offset(x: viewState.width)
        .gesture(
            DragGesture()
                .onChanged { value in
                    let impactMed = UIImpactFeedbackGenerator(style: .light)
                    
                    withAnimation {
                        if isOpened && value.translation.width > 0 {
                            viewState = value.translation
                            
                            if viewState.width > 70 {
                                viewState.width = 200
                                isOpened = false
                                
                                impactMed.impactOccurred()
                            }
                        }
                        
                        if !isOpened && value.translation.width < 0 {
                            viewState.width = value.translation.width + 200
                            
                            if viewState.width < 140 {
                                viewState = .zero
                                isOpened = true
                                
                                impactMed.impactOccurred()
                            }
                        }
                    }
                }
                .onEnded { value in
                    withAnimation {
                        if !isOpened && viewState.width > 140 {
                            viewState.width = 200
                            isOpened = false
                        }
                        
                        if isOpened && viewState.width < 70 {
                            viewState = .zero
                            isOpened = true
                        }
                    }
                }
        )
    }
}

struct ActionMenu_Previews: PreviewProvider {
    static var previews: some View {
        ActionMenu() { }
    }
}
