//
//  ErrorView.swift
//  Wome
//
//  Created by Maxim Soroka on 05.06.2021.
//

import SwiftUI

struct ErrorView: View {
    @EnvironmentObject private var viewModel: PublicationCreationViewModel
    
    var body: some View {            
        VStack {
            ZStack {
                Color.womePink
                    .frame(width: 150, height: 150)
                    .clipShape(ClippedCircle())
                
                Image(systemName: "xmark.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.white.opacity(0.8))
                    .offset(x: -15)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 4) {
                Text("Oops!")
                    .font(.openSansSemiBold(size: 25))
                    .foregroundColor(.womeBlack)
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.womePink)
                    .frame(width: 50, height: 6)
                
                Text("You can`t create a \(viewModel.selectedPublicationType.rawValue) publication, until you solve the following problem:")
                    .font(.openSansRegular(size: 20))
                    .foregroundColor(.womeBlack)
                    .multilineTextAlignment(.center)
                    .padding()
                
                VStack(alignment: .leading, spacing: 6) {
                    ForEach([
                        viewModel.captionTextValidation,
                        viewModel.selectedAssetsValidation,
                        viewModel.emptyValidation
                    ], id: \.self) { validation in
                        if let message = validation.message {
                            Text(message)
                                .font(.openSansRegular(size: 18))
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal)
                                .foregroundColor(.womeBlack)
                        }
                    }
                }
            }
            .padding(.top, -50)
            
            Button {
                withAnimation {
                    viewModel.showErrorView = false
                }
            } label: {
                Text("T R Y  A G A I N")
                    .font(.openSansLight(size: 20))
                    .foregroundColor(.womePink)
            }
            .padding()
        }
        .background(
            Color.white
                .shadow(color: Color.womeBlack.opacity(0.3), radius: 10, x: 4, y: 5)
        )
        .frame(maxWidth: 412)
        .padding()
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
            .environmentObject(PublicationCreationViewModel())
    }
}

//VStack {
//    VStack(spacing: 4) {
//
//        Text("Oops!")
//            .font(.openSansSemiBold(size: 25))
//            .foregroundColor(.womeBlack)
//        RoundedRectangle(cornerRadius: 22)
//            .fill(Color.womePink)
//            .frame(width: 50, height: 6)
//
//        Text("You can`t create a \(viewModel.selectedPublicationType.rawValue) publication, until you solve the following problem:")
//            .font(.openSansRegular(size: 20))
//            .foregroundColor(.womeBlack)
//            .multilineTextAlignment(.center)
//            .padding()
//        VStack(alignment: .leading) {
//            ForEach([viewModel.captionTextValidation, viewModel.selectedAssetsValidation], id: \.self) { validation in
//                if let message = validation.message {
//                    Text(message)
//                        .font(.openSansLight(size: 18))
//                        .multilineTextAlignment(.leading)
//                        .padding(.horizontal)
//                        .foregroundColor(.womeBlack)
//                }
//            }
//        }
//
//        Button {
//            withAnimation {
//                viewModel.showErrorView = false
//            }
//        } label: {
//            Text("T R Y  A G A I N")
//                .font(.openSansLight(size: 20))
//                .foregroundColor(.womePink)
//        }
//        .padding(.top, 6)
//    }
//    .frame(maxWidth: 412, maxHeight: 412)
//}
//.background(Color.white)
//.shadow(color: Color.womeBlack.opacity(0.3), radius: 10, x: 4, y: 5)
//.overlay(
//    ZStack {
//        Color.womePink
//            .frame(width: 150, height: 150)
//            .clipShape(ClippedCircle())
//
//        Image(systemName: "xmark.circle")
//            .resizable()
//            .frame(width: 50, height: 50)
//            .foregroundColor(Color.white.opacity(0.8))
//            .offset(x: -15)
//
//    }, alignment: .topLeading
//)
//.padding()
