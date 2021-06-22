//
//  CommentsView.swift
//  Wome
//
//  Created by Maxim Soroka on 19.06.2021.
//

import SwiftUI

struct CommentsView: View {
    @StateObject private var viewModel = CommentsViewModel()
    @Binding var applyTransition: Bool
    @Binding var showCommentsView: Bool
    
    var body: some View {
        ScrollView {
            Button {
                withAnimation {
                    applyTransition = false
                }
                withAnimation(Animation.default.delay(0.3)) {
                    showCommentsView = false
                }
            } label : {
                Circle()
                    .fill(Color(UIColor.systemGray5))
                    .frame(width: 25, height: 25)
                    .overlay(
                        Image(systemName: "chevron.down")
                            .foregroundColor(.womeBlack)
                    )
            }
            .padding(.top, AppConstants.safeAreaInsets?.top)
            .frame(maxWidth: .infinity, alignment: .leading)

            
            VStack {
                Text("Comments")
                    .font(.openSansSemiBold(size: 30))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 25) {
                    ForEach(0..<6) { _ in
                        CommentView()
                    }
                }
            }
            .padding()
            .frame(maxWidth: 712)
        }
        .environmentObject(viewModel)
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView(applyTransition: .constant(false), showCommentsView: .constant(false))
            .environmentObject(PublicationDetailsViewModel())
            .padding(.top, AppConstants.safeAreaInsets?.top)
            .ignoresSafeArea()
            
    }
}
