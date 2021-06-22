//
//  PostView.swift
//  Wome
//
//  Created by Maxim Soroka on 18.06.2021.
//

import SwiftUI
import SDWebImageSwiftUI


struct PostView: View {
    @EnvironmentObject private var viewModel: FeedViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var showMore = false
    
    let post: Publication.Post
    let bounds: GeometryProxy
    
    var body: some View {
        VStack {
            if let image = post.image {
                Image(uiImage: image.image)
                    .resizable()
                    .scaledToFit()
                    .fixedSize(horizontal: false, vertical: true)
                    .clipped()
                    .contentShape(Rectangle())
            } 
            
            VStack(alignment: .leading, spacing: 6) {
                if let caption = post.caption {
                    Text(caption)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(4)
                        .lineLimit(caption.count > 50 && !showMore ? 4 : nil)
                        .font(.openSansRegular(size: 16))
                    
                    if caption.count > 50  {
                        Button {
                            withAnimation {
                                showMore.toggle()
                            }
                        } label: {
                            Text(showMore ? "Show less" : "Show more")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding(post.caption == nil ? 0 : 16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.white)
        .cornerRadius(22)
        .frame(
            width: LayoutAdaptation.getPublicationWidth(
                with: bounds,
                isLandscape: $viewModel.isLandscape,
                horizontalSizeClass: horizontalSizeClass ?? .compact
            ) - 32
        )
    }
}
