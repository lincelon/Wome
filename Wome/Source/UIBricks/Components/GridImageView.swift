//
//  GridImageView.swift
//  Wome
//
//  Created by Maxim Soroka on 02.06.2021.
//

import SwiftUI
import AVKit

struct GridImageView: View {
    @EnvironmentObject private var viewModel: PublicationCreationViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    let asset: Asset
    let index: Int
    let bounds: GeometryProxy
    
    var body: some View {
        let imageRect = (bounds.size.width / (horizontalSizeClass == .regular ? 4 : 2))
        let indexCondition = (horizontalSizeClass == .regular ? 3 : 1)
        let assetsCountCondition = (horizontalSizeClass == .regular ? 4 : 2)
        
        Button {
            withAnimation(.easeInOut) {
                viewModel.selectedAsset = asset
                viewModel.showAssetsViewer = true
            }
        } label: {
            ZStack {
                if index <= indexCondition {
                    Image(uiImage: asset.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageRect, height: imageRect)
                            .clipped()
                            .cornerRadius(22)
                            .contentShape(Rectangle())
                }

                if viewModel.selectedAssets.count > assetsCountCondition &&
                    index == indexCondition {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.black.opacity(0.3))
                        .frame(width: imageRect, height: imageRect)
                    Text("+\(viewModel.selectedAssets.count - assetsCountCondition)")
                        .font(Font.title.weight(.semibold))
                        .foregroundColor(.white)

                }
            
            }
        }
    }
}


struct GridImageView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { bounds in
            PublicationCreationView(publications: .constant([]), feedShowAction: .constant(.publicationCreation), applyViewTransition: .constant(true), applyViewDelay: .constant(false), bounds: bounds)
                .ignoresSafeArea(.all, edges: .top)
        }
    }
}
