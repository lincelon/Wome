//
//  ChatRowView.swift
//  Wome
//
//  Created by Maxim Soroka on 19.06.2021.
//

import SwiftUI

struct ChatRowView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image("showcase-cell-4")
                .resizable()
                .scaledToFill()
                .frame(width: 65, height: 65)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Beverly Jones")
                    .foregroundColor(.womeBlack)
                    .font(.openSansSemiBold(size: 17))
                
                Text("You know you are in love when")
                    .foregroundColor(.secondary)
                    .font(.openSansRegular(size: 16))
            }
            
            Spacer()
        }
    }
}

struct ChatRowView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRowView()
            .padding()
    }
}
