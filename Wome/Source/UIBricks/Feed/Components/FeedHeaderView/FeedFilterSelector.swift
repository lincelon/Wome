//
//  FeedFilterSelector.swift
//  Wome
//
//  Created by Maxim Soroka on 30.05.2021.
//

import SwiftUI

struct FeedFilterSelector: View {
    @EnvironmentObject private var viewModel: FeedViewModel
    
    let contentFilter: FeedViewModel.ContentFilter
    let animation: Namespace.ID
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(contentFilter.rawValue.capitalized)
                .foregroundColor(.womeBlack)
                .font(.openSansRegular(size: 20))
                .onTapGesture {
                    withAnimation {
                        viewModel.send(action: .filterPublications(filter: contentFilter))
                    }
                }
            
            ZStack {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 6, height: 6)
                
                if viewModel.selectedFilter == contentFilter {
                    Circle()
                        .fill(viewModel.selectedFilter == contentFilter ? Color.womeBlack : Color.clear)
                        .frame(width: 6, height: 6)
                        .matchedGeometryEffect(id: "contentFilter", in: animation)
                }
            }
        }
        .frame(maxWidth: AppConstants.screen.width / 3)
    }
}
