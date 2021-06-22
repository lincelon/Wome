//
//  FeedPublicationView.swift
//  Wome
//
//  Created by Maxim Soroka on 28.05.2021.
//

import SwiftUI

struct FeedPublicationView: View {
    @EnvironmentObject private var viewModel: FeedViewModel
    
    let publicationType: Publication.PublicationType
    let bounds: GeometryProxy
    
    var body: some View {
        content(for: publicationType)
    }
    
    @ViewBuilder
    private func content(for publicationType: Publication.PublicationType) -> some View {
        switch publicationType {
        case .story(let story):
            StoryView(story: story, bounds: bounds)
            
        case .post(let post):
            PostView(post: post, bounds: bounds)
        }
    }
}

struct FeedPublicationView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { bounds in
            FeedView(showNavigationMenu: .constant(false), bounds: bounds)
        }
    }
}
