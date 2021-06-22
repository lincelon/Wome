//
//  NotificationsView.swift
//  Wome
//
//  Created by Maxim Soroka on 18.06.2021.
//

import SwiftUI

struct NotificationsView: View {
    @Binding var showNavigationMenu: Bool
    
    var body: some View {
        VStack {
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.womeWhite)
        .onTapGesture {
            withAnimation {
                showNavigationMenu = true
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView(showNavigationMenu: .constant(false))
    }
}
