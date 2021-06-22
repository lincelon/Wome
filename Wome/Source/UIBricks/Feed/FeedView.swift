//
//  ContentView.swift
//  Wome
//
//  Created by Maxim Soroka on 28.05.2021.
//

import SwiftUI 
import WaterfallGrid

struct FeedView: View {
    @StateObject private var viewModel: FeedViewModel = FeedViewModel()
    @State private var scrollViewOffset: CGPoint = .zero
    @State private var applyOpacity = true
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.orientationPublisher) private var orientationPublisher
    @Binding var showNavigationMenu: Bool
    
    let bounds: GeometryProxy
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                let columnsCondition = bounds.size.width < 712 && horizontalSizeClass == .regular ? 2 : 3
                VStack {
                    GeometryScrollView(offsetChanged: { scrollViewOffset = $0 }) {
                        FeedHeaderView(
                            showNavigationMenu: $showNavigationMenu,
                            bounds: bounds
                        )
                        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 7)
                        .offset(y: -10)
                        .offset(y: scrollViewOffset.y > 0 ? -scrollViewOffset.y : 0)
                        
                        WaterfallGrid(viewModel.filteredPublications.reversed()) { publication in
                            FeedPublicationView(
                                publicationType: publication.type,
                                bounds: bounds
                            )
                            .shadow(color: Color.black.opacity(0.3), radius: 7, x: 4, y: 10)
                            .transition(
                                .asymmetric(
                                    insertion: AnyTransition.opacity.combined(with: .scale),
                                    removal: .opacity
                                )
                            )
                            .animation(.default)
                            .onTapGesture {
                                if case .story(let story) = publication.type {
                                    withAnimation {
                                        viewModel.selectedStory = story
                                    }
                                }
                            }
                        }
                        .padding()
                        .gridStyle(
                            columnsInPortrait: horizontalSizeClass == .compact ? 1 : 2,
                            columnsInLandscape: horizontalSizeClass == .compact ? 1 : columnsCondition,
                            spacing: 32
                        )
                        .opacity(applyOpacity ? 0 : 1)
                    }
                }
                
                FeedShowActionsView(bounds: bounds)
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.white, Color(#colorLiteral(red: 0.9254901961, green: 0.9490196078, blue: 0.9843137255, alpha: 1))]), startPoint: .topTrailing, endPoint: .bottomLeading)
            )
            .environmentObject(viewModel)
            .onReceive(orientationPublisher)
                { viewModel.isLandscape = !$0.isPortrait }
            .onAppear {
                withAnimation(Animation.default.delay(0.25)) {
                    applyOpacity = false
                }
            }
            .overlay(
                ZStack {
                    if viewModel.selectedStory != nil {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                    }
                }
            )
            .overlay(
                VStack {
                    if viewModel.selectedStory != nil {
                        PublicationDetailsView(story: $viewModel.selectedStory)
                            .frame(maxWidth: 712)
                            .transition(.offset(x: bounds.size.width))
                    }
                }
             
            )
            .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { bounds in
            FeedView(showNavigationMenu: .constant(false), bounds: bounds)
        }
    }
}

