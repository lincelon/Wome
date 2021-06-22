//
//  TabButton.swift
//  Wome
//
//  Created by Maxim Soroka on 14.06.2021.
//

import SwiftUI

struct NavigationMenuComponentButton: View {
    @EnvironmentObject private var viewModel: NavigationMenuViewModel
    let navigationMenuComponent: NavigationMenuViewModel.NavigationMenuComponent
    let animation: Namespace.ID

    var body: some View {
        Button {
            withAnimation {
                viewModel.selectedNavigationMenuComponent = navigationMenuComponent
            }
            withAnimation(Animation.default.delay(0.55)) {
                viewModel.showNavigationMenu = false
            }
        } label: {
            Label(navigationMenuComponent.rawValue.capitalized, systemImage: navigationMenuComponent.systemImageName)
                .font(.openSansSemiBold(size: 18))
                .foregroundColor(viewModel.selectedNavigationMenuComponent == navigationMenuComponent ?  Color.womePink : Color.white.opacity(0.9))
        }
        .padding()
        .frame(maxWidth: 200, alignment: .leading)
        .background(
            ZStack {
                if viewModel.selectedNavigationMenuComponent == navigationMenuComponent {
                    Color.white
                        .opacity(viewModel.selectedNavigationMenuComponent == navigationMenuComponent ? 1 : 0)
                        .clipShape(RoundedCorners(corners: [.topRight,.bottomRight], radius: 12))
                        .matchedGeometryEffect(id: "navigationMenuComponent", in: animation)
                }
            }
        )
        .allowsHitTesting(viewModel.showNavigationMenu)
        .allowsHitTesting(viewModel.selectedNavigationMenuComponent != navigationMenuComponent)
    }
}
