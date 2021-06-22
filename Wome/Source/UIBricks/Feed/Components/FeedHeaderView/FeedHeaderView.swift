//
//  FeedHeaderView.swift
//  Wome
//
//  Created by Maxim Soroka on 28.05.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct FeedHeaderView: View {
    @EnvironmentObject private var viewModel: FeedViewModel
    @Namespace private var animation
    @Binding var showNavigationMenu: Bool
    
    let bounds: GeometryProxy
    
    var body: some View {
        VStack {
            HStack {
                MenuButton(widthAndHeight: 35) {
                    withAnimation {
                        showNavigationMenu = true
                    }
                }
                
                Spacer()
                
                Image("more")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 25, height: 25)
            }
            .padding()
            .padding(.top, AppConstants.safeAreaInsets?.top)
            .foregroundColor(.womeBlack)
            
            WebImage(url: URL(string: viewModel.admin?.profileImageURL ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            
            VStack(spacing: 5) {
                Text(viewModel.admin?.fullname ?? "")
                    .foregroundColor(.womeBlack)
                    .font(.openSansSemiBold(size: 20))
                Text("HR-lead. Kharkov, UA")
                    .foregroundColor(.womeBlack)
            }
            
            HStack {
                ForEach(FeedViewModel.ContentFilter.allCases, id: \.self) { contentFilter in
                    FeedFilterSelector(contentFilter: contentFilter, animation: animation)
                        .padding(.vertical)
                }
            }
            .padding()
        }
        .background(
            Circle()
                .fill(Color.womeBlack.opacity(0.05))
                .offset(x: bounds.size.width * 0.1, y: -bounds.size.width * 0.1)
                .frame(
                    width: bounds.size.width * 0.6,
                       height: bounds.size.width * 0.6, alignment: .center
                ),
            alignment: .topTrailing
        )
        .background(
            Circle()
                .fill(Color.womePink.opacity(0.15))
                .offset(x: bounds.size.width * 0.1, y: -bounds.size.width * 0.1)
                .frame(
                    width: bounds.size.width * 0.5,
                       height: bounds.size.width * 0.5, alignment: .center
                ),
            alignment: .topLeading
        )
        .background(
                Color.womeWhite
        )
        .clipShape(RoundedCorners(corners: [.bottomLeft, .bottomRight], radius: 30))
        .font(.openSansRegular(size: 16))
    }
}

struct FeedHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { bounds in
            FeedHeaderView(showNavigationMenu: .constant(false), bounds: bounds)
                .environmentObject(FeedViewModel())
        }
    }
}
