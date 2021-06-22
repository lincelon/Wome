//
//  CreationFieldsView.swift
//  Wome
//
//  Created by Maxim Soroka on 06.06.2021.
//

import SwiftUI
import WaterfallGrid

struct CreationFieldsView: View {
    @EnvironmentObject private var viewModel: PublicationCreationViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            VStack {
                if viewModel.selectedPublicationType == .story {
                    AutoSizingTextField(placeholder: "Title", font: UIFont.init(name: "OpenSans-Regular", size: 18)!, isTextView: false, text: $viewModel.titleText, containerHeight: $viewModel.titleContainerHeight)
                        .frame(height: viewModel.titleContainerHeight <= 59 ? viewModel.titleContainerHeight : 59)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 4, y: 5)
                }
            }
            
            VStack {
                AutoSizingTextField(placeholder: "Caption", font: UIFont.init(name: "OpenSans-Regular", size: 18)!, isTextView: true, text: $viewModel.captionText, containerHeight: $viewModel.captionContainerHeight)
                    .frame(height: viewModel.captionContainerHeight <= 170 ? viewModel.captionContainerHeight : 170)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 4, y: 5)
                
                if let message = viewModel.captionTextValidation.message {
                    Text(message)
                        .foregroundColor(.red)
                        .font(Font.footnote.weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .transition(AnyTransition.opacity.animation(.easeIn))
                }
            }
        }
        .padding()

    }
}

struct CreationFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        CreationFieldsView()
    }
}
