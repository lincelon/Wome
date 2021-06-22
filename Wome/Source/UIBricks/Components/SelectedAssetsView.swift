//
//  SelectedAssetsView.swift
//  Wome
//
//  Created by Maxim Soroka on 02.06.2021.
//

import SwiftUI

struct SelectedAssetsView: View {
    @EnvironmentObject private var viewModel: PublicationCreationViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    let bounds: GeometryProxy
    
    var body: some View {
        VStack {
            if viewModel.selectedAssets.count > 0 {
                GeometryReader { bounds in
                    LazyHGrid(rows: [GridItem(.flexible())]) {
                        ForEach(Array(viewModel.selectedAssets.enumerated()), id: \.element) { index, asset in
                            GridImageView(
                                asset: asset,
                                index: index,
                                bounds: bounds
                            )
                            .transition(.slide)
                            .animation(.default)
                        }
                    }
                }
                .frame(
                    width: LayoutAdaptation.getViewWidth(with: bounds, padding: 16),
                    height: LayoutAdaptation.getViewWidth(with: bounds, padding: 16) / (horizontalSizeClass == .regular ? 4 : 2)
                )
            }
        }
    }
}

struct PickedAssetsView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { bounds in
            PublicationCreationView(publications: .constant([]), feedShowAction: .constant(.publicationCreation), applyViewTransition: .constant(true), applyViewDelay: .constant(false), bounds: bounds)
                .ignoresSafeArea(.all, edges: .top)
        }
    }
}
