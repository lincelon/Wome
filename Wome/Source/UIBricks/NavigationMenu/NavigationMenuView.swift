//
//  NavigationMenuView.swift
//  Wome
//
//  Created by Maxim Soroka on 14.06.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct NavigationMenuView: View {
    @StateObject private var viewModel = NavigationMenuViewModel()
    @State private var  viewState: CGSize = .zero
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Namespace private var animation
    
    var body: some View {
        GeometryReader { bounds in
            ZStack {
                Color.womePink
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 40) {
                    Button {
                        withAnimation {
                            viewModel.showNavigationMenu = false
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(Font.title2.bold())
                            .foregroundColor(.white)
                    }
                    .padding([.horizontal, .top])
                    
                    VStack(spacing: 10) {
                        Circle()
                            .stroke(Color.black.opacity(0.3), lineWidth: 8)
                            .frame(width: 85, height: 85)
                            .overlay(
                                WebImage(url: URL(string: viewModel.currentUser?.profileImageURL ?? ""))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .padding()
                            )
                        
                        Text("Hi, \(viewModel.currentUser?.fullname ?? "")!")
                            .font(.openSansBold(size: 24))
                            .foregroundColor(.white)
                    }
                    .padding(.leading)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(NavigationMenuViewModel.NavigationMenuComponent.allCases, id: \.self) { navigationMenuComponent in
                            NavigationMenuComponentButton(
                                navigationMenuComponent: navigationMenuComponent,
                                animation: animation
                            )
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                ZStack {
                    Color.white
                        .opacity(0.5)
                        .cornerRadius(viewModel.showNavigationMenu ? 15 : 0)
                        .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                        .offset(x: viewModel.showNavigationMenu ? -25 : 0)
                        .padding(.vertical,30)
                    
                    Color.white
                        .opacity(0.4)
                        .cornerRadius(viewModel.showNavigationMenu ? 15 : 0)
                        .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                        .offset(x: viewModel.showNavigationMenu ? -50 : 0)
                        .padding(.vertical,60)
                    
                    VStack {
                        switch viewModel.selectedNavigationMenuComponent {
                        case .shop:
                            ShopView(
                                showNavigationMenu: $viewModel.showNavigationMenu,
                                bounds: bounds
                            )
                        case .notifications:
                            NotificationsView(showNavigationMenu: $viewModel.showNavigationMenu)
                        case .feed:
                            FeedView(showNavigationMenu: $viewModel.showNavigationMenu, bounds: bounds)
                                .ignoresSafeArea()
                        case .profile:
                            ProfileView(showNavigationMenu: $viewModel.showNavigationMenu)
                        }
                    }
                    .cornerRadius(viewModel.showNavigationMenu ? 15 : 0)
                    .disabled(viewModel.showNavigationMenu)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                withAnimation {
                                    if value.translation.width > 0 {
                                        viewState = value.translation
                                        
                                        if viewState.width > 60 {
                                            viewModel.showNavigationMenu = true
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        }
                                    }
                                }
                            }
                    )
                    .onTapGesture {
                        withAnimation {
                            if viewModel.showNavigationMenu {
                                viewModel.showNavigationMenu = false
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }
                        }
                    }
                }
                .offset(
                    x: viewModel.showNavigationMenu ? getNaivagationMenuOffset(with: bounds, horizontalSizeClass: horizontalSizeClass ?? .regular).width : 0,
                    y: viewModel.showNavigationMenu ? getNaivagationMenuOffset(with: bounds, horizontalSizeClass: horizontalSizeClass ?? .regular).height :  0
                )
                .ignoresSafeArea()
            }
            .frame(width: bounds.size.width)
            .environmentObject(viewModel)
        }
    }
    
    private func getNaivagationMenuOffset(with bounds: GeometryProxy, horizontalSizeClass: UserInterfaceSizeClass) -> CGSize {
        let iPadOffsetCondition =
            bounds.size.width < 712 && horizontalSizeClass == .regular
            ? bounds.size.width * 0.4 : bounds.size.width * 0.3
//
        return horizontalSizeClass == .regular ? CGSize(width: iPadOffsetCondition, height: bounds.size.height * 0.1) : CGSize(width: bounds.size.width * 0.7, height: bounds.size.height * 0.2)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationMenuView()
        
    }
}
