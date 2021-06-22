//
//  ChatsView.swift
//  Wome
//
//  Created by Maxim Soroka on 18.06.2021.
//

import SwiftUI

struct ChatsView: View {
    @Binding var applyViewTransition: Bool
    @Binding var feedShowAction: FeedViewModel.FeedShowAction
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Button {
                    withAnimation {
                        applyViewTransition = false
                    }
                    withAnimation(Animation.default.delay(0.3)) {
                        feedShowAction = .toolbar
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.womeBlack)
                        .font(Font.title2.weight(.semibold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    Text("Conversations")
                        .foregroundColor(.womeBlack)
                        .font(.openSansBold(size: 30))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 30) {
                        HStack(spacing: 20) {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.womePink)
                                .clipShape(Circle())
                            
                            Text("Search friend")
                                .font(.openSansRegular(size: 16))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.womeWhite)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 7)
                        
                        ForEach(1..<5, id: \.self) { _ in
                            ChatRowView()
                        }
                    }
                }
                .frame(maxWidth: 712)
            }
            .padding()
            .padding(.top, AppConstants.safeAreaInsets?.top)
        }
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView(applyViewTransition: .constant(false), feedShowAction: .constant(.chat))
            .background(Color.womeWhite)
    }
}
