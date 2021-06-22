//
//  FeedActionButton.swift
//  Wome
//
//  Created by Maxim Soroka on 18.06.2021.
//

import SwiftUI

struct FeedActionButton<Content: View>: View {
    @EnvironmentObject private var viewModel: FeedViewModel
    
    let assignedShowAction: FeedViewModel.FeedShowAction
    let systemImageName: String
    let backgroundColor: Color
    let foregroundColor: Color
    let widthAndHeight: CGFloat
    let content: Content
    
    init(
         assignedShowAction: FeedViewModel.FeedShowAction,
         systemImageName: String,
         backgroundColor: Color,
         foregroundColor: Color,
         widthAndHeight: CGFloat,
         @ViewBuilder content: @escaping () -> Content
    ) {
        self.assignedShowAction = assignedShowAction
        self.systemImageName = systemImageName
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.widthAndHeight = widthAndHeight
        self.content = content()
    }
    
    var body: some View {
        let condition = viewModel.feedShowAction == assignedShowAction && assignedShowAction != .toolbar
        ZStack {
            condition
                ? Color.womeWhite
                : backgroundColor

            VStack {
                if !condition {
                    Image(systemName: systemImageName)
                            .foregroundColor(foregroundColor)
                            .font(.title)
                            .transition(.opacity)
                            .rotationEffect(.degrees(viewModel.feedShowAction == .toolbar && assignedShowAction == .toolbar ? 90 : 0))
                }
            }
            .opacity(!condition ? 1 : 0)
            .animation(Animation.default.speed(2))
            
            VStack {
                content
            }
        }
        .frame(
            maxWidth:
                condition ? .infinity : CGFloat(75),
            maxHeight:
                condition ? .infinity : CGFloat(75)
        )
        .cornerRadius(45)
        .padding(.horizontal, condition ? CGFloat(0) : CGFloat(16))
        .padding(.bottom, condition ? CGFloat(0) : AppConstants.safeAreaInsets?.bottom)
        .padding(.bottom, condition
                    ? CGFloat(0)
                    : AppConstants.safeAreaInsets?.bottom ?? 0 > 0
                    ? 0
                    : 16
        )
        .onTapGesture {
            if assignedShowAction == .toolbar {
                withAnimation(
                    .spring(
                        response: 0.6,
                        dampingFraction: 0.55,
                        blendDuration: 0
                    )
                ) {
                    viewModel.feedShowAction =
                        viewModel.feedShowAction == .none ? .toolbar : .none
                }
            } else {
                withAnimation {
                    viewModel.feedShowAction = assignedShowAction
                    viewModel.applyViewDelay = true
                }
                
                withAnimation(Animation.default.delay(0.3)) {
                    viewModel.applyViewTransition = true
                }
            }
        }
    }
}

struct FeedActionButton_Previews: PreviewProvider {
    static var previews: some View {
        FeedActionButton(
            assignedShowAction: .toolbar,
            systemImageName: "xmark",
            backgroundColor: .womePink,
            foregroundColor: .womeWhite,
            widthAndHeight: 75
        ) { }
    }
}
