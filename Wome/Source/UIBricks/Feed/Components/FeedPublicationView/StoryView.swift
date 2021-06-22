//
//  StoryView.swift
//  Wome
//
//  Created by Maxim Soroka on 18.06.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct StoryView: View {
    @EnvironmentObject private var viewModel: FeedViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    let story: Publication.Story
    let bounds: GeometryProxy
    
    var body: some View {
        VStack {
            if let assets = story.images,
               let first = assets.first {
                
                Image(uiImage: first.image)
                    .resizable()
                    .aspectRatio(contentMode: horizontalSizeClass == .compact ? .fill : .fill)
                    .frame(width: LayoutAdaptation.getPublicationWidth(with: bounds, isLandscape: $viewModel.isLandscape, horizontalSizeClass: horizontalSizeClass ?? .compact) - 32)
                    .frame(maxHeight: 500)
                    .background(Color.yellow)
                    .clipped()
                    .contentShape(Rectangle())
            }
            
            VStack(alignment: .leading, spacing: 8.0) {
                if let title = story.title {
                    Text(title)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.openSansSemiBold(size: 20))
                }
                
                if let caption = story.caption {
                    Text(caption)
                        .font(.openSansRegular(size: 16))
                        .lineLimit(story.images != nil ? 2 : 5)
                        .lineSpacing(4)
                }
                
                if story.caption != nil || story.title != nil {
                    ExDivider(color: .secondary, width: 1)
                        .cornerRadius(6)
                        .padding(.top, 4)
                }
                
                HStack(spacing: 12) {
                    Label("10", systemImage: "heart")
                    Label("5", systemImage: "bubble.right")
                    
                    Spacer()
                    
                    Text("2h ago")
                }
                .foregroundColor(.secondary)
                
            }
            .padding(.top, story.images != nil ? 8 : 16)
            .padding([.horizontal, .bottom])
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.white)
        .cornerRadius(22)
        .frame(
            maxWidth:
                 LayoutAdaptation.getPublicationWidth(
                    with: bounds,
                    isLandscape: $viewModel.isLandscape,
                    horizontalSizeClass: horizontalSizeClass ?? .compact
                ) - 32
        )
    }
}
