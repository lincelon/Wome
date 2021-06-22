//
//  FeedShowActionsView.swift
//  Wome
//
//  Created by Maxim Soroka on 18.06.2021.
//

import SwiftUI

struct FeedShowActionsView: View {
    @EnvironmentObject private var viewModel: FeedViewModel
    let bounds: GeometryProxy
    
    var body: some View {
        VStack {
            if (viewModel.feedShowAction == .toolbar
                    || viewModel.feedShowAction == .publicationCreation) && viewModel.currentUser?.isAdmin ?? true {
                FeedActionButton(
                    assignedShowAction: .publicationCreation,
                    systemImageName: "pencil.circle.fill",
                    backgroundColor: .womeWhite,
                    foregroundColor: .womePink,
                    widthAndHeight: 75
                ) {
                    if viewModel.applyViewTransition {
                        PublicationCreationView(
                            publications: $viewModel.publications,
                            feedShowAction: $viewModel.feedShowAction,
                            applyViewTransition: $viewModel.applyViewTransition,
                            applyViewDelay: $viewModel.applyViewDelay,
                            bounds: bounds
                        )
                        .transition(
                            .asymmetric(
                                insertion: .slide,
                                removal: .opacity
                            )
                        )
                    }
                }
                .shadow(color: Color.womeBlack.opacity(0.3), radius: 8, x: 7, y: 4)
                .offset(y: viewModel.feedShowAction == .toolbar ? -90 : 0)
                .transition(.scale)
            }
        }
        .zIndex(viewModel.feedShowAction == .none ? 0 : 1)
        
        VStack {
            if viewModel.feedShowAction == .toolbar
                || viewModel.feedShowAction == .chat {
                FeedActionButton(
                    assignedShowAction: .chat,
                    systemImageName: "bubble.right.fill",
                    backgroundColor: .womeWhite,
                    foregroundColor: .womePink,
                    widthAndHeight: 75
                ) {
                    if viewModel.applyViewTransition {
                        ChatsView(
                            applyViewTransition: $viewModel.applyViewTransition,
                            feedShowAction: $viewModel.feedShowAction
                        )
                        .transition(
                            .asymmetric(
                                insertion: .offset(x: -bounds.size.width),
                                removal: .opacity
                            )
                        )
                    }
                }
                .shadow(color: Color.womeBlack.opacity(0.3), radius: 8, x: 7, y: 4)
                .offset(x:  viewModel.feedShowAction == .toolbar ? -85 : 0, y:  viewModel.feedShowAction == .toolbar ? -40 : 0)
                .transition(.scale)
            }
        }
        .zIndex(viewModel.feedShowAction == .none ? 0 : 1)
        
        VStack {
            FeedActionButton(
                assignedShowAction: .toolbar,
                systemImageName: "sparkle",
                backgroundColor: .womePink,
                foregroundColor: .womeWhite,
                widthAndHeight: 75
            ) { }
            .shadow(color: Color.womePink.opacity(0.3), radius: 8, x: 7, y: 4)
            .transition(.slide)
        }
        .zIndex(0)
    }
}

struct FeedShowActionsView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { bounds in
            VStack {
                FeedShowActionsView(bounds: bounds)
                    .environmentObject(FeedViewModel())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
