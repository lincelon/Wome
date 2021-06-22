//
//  PublicationTypeSelector.swift
//  Wome
//
//  Created by Maxim Soroka on 31.05.2021.
//

import SwiftUI

struct PublicationTypeSelectionView: View {
    @EnvironmentObject private var viewModel: PublicationCreationViewModel
    
    var body: some View {
        HStack {
            ForEach(PublicationCreationViewModel.PublicationTypeSelection.allCases, id: \.self) { type in
                Text(type.rawValue.capitalized)
                    .font(.openSansLight(size: 22))
                    .foregroundColor(viewModel.onApearAnimationStart && type == .story ? .womeBlack : changeColor(for: type))
                    .padding(8)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .background(
                        ZStack {
                            Color.white
                            
                            switch type {
                            case .story:
                                SplashShape(progress: viewModel.storyAnimationProgress)
                                    .foregroundColor(.womePink)
                            case .post:
                                SplashShape(progress: viewModel.postAnimationProgress)
                                    .foregroundColor(.womePink)
                            }
                        }
                    )
                    .cornerRadius(12)
                    .shadow(color: shadowColor(for: type), radius: 6, x: 4, y: 7)
                    .onTapGesture {
                        withAnimation(Animation.spring().speed(0.7)) {
                            hideKeyboard()
                            viewModel.send(action: .publicationTypeSelected(type: type))
                        }
                    }
            }
        }
        .padding()
    }
    
    private func shadowColor(for type: PublicationCreationViewModel.PublicationTypeSelection) -> Color {
          viewModel.selectedPublicationType == type ? Color.womePink.opacity(0.5) : Color.womeBlack.opacity(0.3)
    }
    
    private func changeColor(for type: PublicationCreationViewModel.PublicationTypeSelection) -> Color {
        switch type {
        case .story:
            return  viewModel.storyAnimationProgress == 1 ? .white : .womeBlack
        case .post:
            return  viewModel.postAnimationProgress == 1  ? .white : .womeBlack
        }
    }
}

struct PublicationTypeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PublicationTypeSelectionView()
            .environmentObject(PublicationCreationViewModel())
    }
}
