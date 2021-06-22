//
//  ShopView.swift
//  Wome
//
//  Created by Maxim Soroka on 18.06.2021.
//

import SwiftUI
import WaterfallGrid
import SDWebImageSwiftUI


struct ShopView: View {
    @StateObject private var viewModel = ShopViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Binding var showNavigationMenu: Bool
    
    let bounds: GeometryProxy
    
    var body: some View {
        ZStack {
            let columnsCondition = bounds.size.width < 712 && horizontalSizeClass == .regular ? 3 : 4
            
            ScrollView {
                VStack(spacing: 30) {
                    HStack {
                        MenuButton(widthAndHeight: 35) {
                            withAnimation {
                                showNavigationMenu = true
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }
                        }
                        .foregroundColor(.womeBlack)
                        
                        Spacer()
                        
                        Button { } label: {
                            WebImage(url: URL(string: viewModel.currentUser?.profileImageURL ?? ""))
                                .resizable()
                                .scaledToFill()
                                .frame(width: horizontalSizeClass == .regular ? 60 : 45, height: horizontalSizeClass == .regular ? 60 : 45)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, AppConstants.safeAreaInsets?.top)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Hello")
                            .foregroundColor(.womeBlack)
                            .font(.openSansSemiBold(size: 32))
                        
                        Text("Welcome to Wome")
                            .foregroundColor(.secondary)
                            .font(.openSansSemiBold(size: 16))
                    }
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ClothesFiltersView()
                        .padding(.top, -16)
                    
                    WaterfallGrid(viewModel.filteredClothes, id: \.self) { clothes in
                        Button {
                            withAnimation(Animation.easeOut.speed(0.8)) {
                                viewModel.showDetails = true
                                viewModel.selectedClothes = clothes
                            }
                        } label: {
                            Image(clothes.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .cornerRadius(22)
                        .transition(AnyTransition.scale.combined(with: .opacity))
                        .animation(.default)
                    }
                    .padding(.horizontal)
                    .gridStyle(
                        columnsInPortrait: horizontalSizeClass == .regular ? 3 : 2,
                        columnsInLandscape: horizontalSizeClass == .regular ? columnsCondition : 2,
                        spacing: 12
                    )
                }
            }
            .padding(.top)
            .disabled(viewModel.selectedClothes != nil)
            .overlay(
                ZStack {
                    if viewModel.selectedClothes != nil {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                    }
                }
            )
            
            VStack {
                if viewModel.showDetails {
                    DetailsClothesView(bounds: bounds)
                        .frame(
                            maxWidth: horizontalSizeClass == .regular && bounds.size.width > 712 ? 712 : .infinity,
                            maxHeight: horizontalSizeClass == .regular ? (bounds.size.width < 712 ? .infinity : 850) : .infinity
                        )
                        .clipped()
                        .cornerRadius((horizontalSizeClass == .regular && bounds.size.width < 712) ? 0 : 22)
                        .contentShape(Rectangle())
                        .transition(.asymmetric(insertion: .offset(x: bounds.size.width, y: bounds.size.height), removal:  horizontalSizeClass == .regular ? .offset(y: bounds.size.height) : .slide))
                }
            }
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environmentObject(viewModel)
    }
}

struct ClothesFiltersView: View {
    @EnvironmentObject private var viewModel: ShopViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(ShopViewModel.ClothesFilter.allCases, id: \.self) { filter in
                    Button {
                        withAnimation {
                            viewModel.selectedClothesFilter = filter
                            
                        }
                    } label: {
                        Text(filter.rawValue.capitalized)
                            .foregroundColor(viewModel.selectedClothesFilter == filter ? .womeWhite : .womeBlack)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 32)
                            .background(viewModel.selectedClothesFilter == filter ? Color.womePink : Color(UIColor.systemGray5))
                            .cornerRadius(12)
                    }
                    .id(filter)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { bounds in
            ShopView(
                showNavigationMenu: .constant(false),
                bounds: bounds
            )
            .ignoresSafeArea()
        }
    }
}
