//
//  CommentView.swift
//  Wome
//
//  Created by Maxim Soroka on 19.06.2021.
//

import SwiftUI

struct CommentView: View {
    @EnvironmentObject private var viewModel: CommentsViewModel
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 16) {
                Image("showcase-cell-4")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                                
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Katya Vershinina")
                            .font(.openSansSemiBold(size: 16))
                            .foregroundColor(.womeBlack)
                        Text("3h ago")
                            .font(.openSansRegular(size: 15))
                            .foregroundColor(.secondary)
                    }
                    
                    Text("You always give good advice. What would you say to someone")
                        .foregroundColor(.womeBlack)
                        .font(.openSansRegular(size: 15))
                    
                    ExDivider(color: Color.womeBlack.opacity(0.25), width: 0.4)
                    
                    HStack {
                        Button { } label: {
                            Image(systemName: "heart")
                                .foregroundColor(.womeBlack)
                        }
                        
                        Text("Like")
                            .font(.openSansSemiBold(size: 14))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView()
            .environmentObject(CommentsViewModel())
    }
}
