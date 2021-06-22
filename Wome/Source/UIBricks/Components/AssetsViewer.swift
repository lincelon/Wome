//
//  AssetsViewer.swift
//  Wome
//
//  Created by Maxim Soroka on 02.06.2021.
//

import AVKit
import SwiftUI
import Introspect

struct AssetsViewer: View {
    @EnvironmentObject private var viewModel: PublicationCreationViewModel
    @GestureState private var viewState: CGSize = .zero

    let bounds: GeometryProxy
    
    init(bounds: GeometryProxy) {
        self.bounds = bounds
        
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .opacity(viewModel.backgroundOpacity)
                .ignoresSafeArea()
            
            ScrollView(.init()) {
                TabView(selection: $viewModel.selectedAsset) {
                    ForEach(viewModel.selectedAssets, id: \.self) { asset in
                        Image(uiImage: asset.image)
                                .resizable()
                                .scaledToFit()
                                .tag(asset)
                                .offset(y: viewModel.assetsViewerOffset.height)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            }
            .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gesture(
            DragGesture()
                .updating($viewState) { value, inoutValue, _ in
                    withAnimation(.easeInOut) {
                        inoutValue = value.translation
                        
                        viewModel.assetsViewerOffset = inoutValue
                        
                        let progress = viewModel.assetsViewerOffset.height / bounds.size.height / 2
                        
                        viewModel.backgroundOpacity = Double(1 - (progress < 0 ? -progress : progress))
                    }
                }
                .onEnded { value in
                    withAnimation {
                        if viewModel.assetsViewerOffset.height > 250 {
                            viewModel.showAssetsViewer = false
                            viewModel.backgroundOpacity = 1
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                viewModel.assetsViewerOffset = .zero
                            }
                        } else {
                            viewModel.assetsViewerOffset = .zero
                        }
                    }
                }
        )
    }
}


struct AssetsViewer_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { bounds in
            PublicationCreationView(publications: .constant([]), feedShowAction: .constant(.publicationCreation), applyViewTransition: .constant(true), applyViewDelay: .constant(false), bounds: bounds)
                .ignoresSafeArea(.all, edges: .top)
        }
    }
}
