//
//  ScrollableViewProvider.swift
//  Wome
//
//  Created by Maxim Soroka on 14.06.2021.
//

import SwiftUI

struct ScrollableViewsProvider: View {
    @State private var scrollOffset: CGFloat = 0
    @Binding var showMenu: Bool
    @State private var currentIndex: Int = 0
    let bounds: GeometryProxy
    
    var body: some View {
        
        ScrollableTabBar(tabsCount: 2, rect: bounds.frame(in: .global), offset: $scrollOffset) {
            FeedView(showMenu: $showMenu, bounds: bounds)
            
            ChatsView(scrollOffset: $scrollOffset, bounds: bounds, showMenu: $showMenu)
        }
        .frame(height: bounds.size.height)
    }
}

struct ChatsView: View {
    @Binding var scrollOffset: CGFloat
    let bounds: GeometryProxy
    @Binding var showMenu: Bool
    @StateObject private var viewModel = FeedViewModel()
   
    var body: some View {
        ZStack(alignment: .topLeading) {
            Button {
                scrollOffset = 0
                
            } label: {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            
            FeedHeaderView(showMunu: $showMenu)
                .environmentObject(viewModel)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.orange)
    }
}


struct ScrollableViewsProvider_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { bounds in
            ScrollableViewsProvider(showMenu: .constant(false), bounds: bounds)
        }
        .ignoresSafeArea()
    }
}
