//
//  DetailsClothesView.swift
//  Wome
//
//  Created by Maxim Soroka on 19.06.2021.
//

import SwiftUI

struct DetailsClothesView: View {
    @EnvironmentObject private var viewModel: ShopViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State private var viewState: CGSize = .zero
    let bounds: GeometryProxy
    
    var body: some View {
        ZStack {
            VStack {
                if let clothes = viewModel.selectedClothes {
                    Image(clothes.image)
                        .resizable()
                        .aspectRatio(contentMode: horizontalSizeClass == .regular && verticalSizeClass == .regular ? .fill : .fit)
                        .frame(
                            width: horizontalSizeClass == .regular
                                ? (bounds.size.width < 712 ? bounds.size.width : 712)
                                : nil
                        )
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 20) {
                if let clothes = viewModel.selectedClothes {
                    VStack(alignment: .leading, spacing: 6)  {
                        Text(clothes.name)
                            .font(.openSansRegular(size: 25))
                            .foregroundColor(.womeBlack)
                            .padding(.horizontal)
                        
                        Text(clothes.description)
                            .font(.openSansRegular(size: 17))
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    .padding(.top, 24)
                    
                    HStack {
                        HStack(spacing: 16) {
                            Button { } label: {
                                ZStack {
                                    Color.womePink
                                    
                                    Image(systemName: "star")
                                        .font(Font.title2.weight(.bold))
                                        .foregroundColor(.womeWhite)
                                }
                            }
                            .frame(maxWidth: 65, maxHeight: 65)
                            .cornerRadius(45)
                            .shadow(color: Color.womePink.opacity(0.3), radius: 7, x: 8, y: 4)
                            
                            Button { } label: {
                                ZStack {
                                    Color.womeWhite
                                    
                                    Image(systemName: "paperplane.fill")
                                        .font(Font.title2.weight(.bold))
                                        .foregroundColor(.womePink)
                                }
                            }
                            .frame(maxWidth: 65, maxHeight: 65)
                            .cornerRadius(45)
                            .shadow(color: Color.womeBlack.opacity(0.2), radius: 7, x: 0, y: 5)
                        }
                        .padding()
                        .background(Color.womeWhite)
                        .clipShape(RoundedCorners(corners: [.topRight, .bottomRight], radius: 70))
                        .shadow(color: Color.womeBlack.opacity(0.3), radius: 7, x: 8, y: 4)
                        
                        Spacer()
                        
                        Text("\(clothes.price)₴")
                            .font(.openSansRegular(size: 30))
                            .foregroundColor(.black)
                            .padding()
                    }
                }
                
                Spacer()
            }
            .background(Color.womeWhite)
            .clipShape(RoundedCorners(corners: [.topLeft, .topRight], radius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 45)
                    .fill(Color.womeBlack)
                    .frame(width: 44, height: 5)
                    .padding(.top),
                alignment: .top
                    
            )
            .offset(y: horizontalSizeClass == .regular
                        ? 850 * 0.70 :  bounds.size.height * 0.55)
            .offset(y: viewState.height)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation {
                            viewState = value.translation
                            
                            if viewState.height > 50 {
                                viewState = .zero
                            }
                            
                            if viewState.height < -30 {
                                viewState = .zero
                            }
                        }
                    }
                    .onEnded { value in
                        withAnimation {
                            viewState = .zero
                        }
                    }
            )
        }
        .overlay(
            Button {
                withAnimation(Animation.default.speed(0.9)) {
                    viewModel.showDetails = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        viewModel.selectedClothes = nil
                    }
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(Font.title2.weight(.semibold))
                    .foregroundColor(.womeWhite)
            }
            .padding()
            .padding(.top, AppConstants.safeAreaInsets?.top),
            alignment: .topLeading
        )
    }
}

struct DetailsClothesView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { bounds in
            ShopView(showNavigationMenu: .constant(false), bounds: bounds)
                .environmentObject(ShopViewModel())
        }
        .ignoresSafeArea()
    }
}
