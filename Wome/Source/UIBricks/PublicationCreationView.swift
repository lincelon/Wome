//
//  PublicationCreationView.swift
//  Wome
//
//  Created by Maxim Soroka on 30.05.2021.
//

import SwiftUI
import Introspect
import WaterfallGrid

struct PublicationCreationView: View {
    @StateObject private var viewModel:PublicationCreationViewModel = PublicationCreationViewModel()
    @StateObject private var keyboardHandler: KeyboardHandler = KeyboardHandler()
    @State private var applyActionMenuTransition: Bool = false
    @State private var x: [UIImage] = []
    
    @Binding var publications: [Publication]
    @Binding var feedShowAction: FeedViewModel.FeedShowAction
    @Binding var applyViewTransition: Bool
    @Binding var applyViewDelay: Bool
    
    let bounds: GeometryProxy
    
    var body: some View {
        let exitAction: () -> () = {
            withAnimation {
                applyViewTransition = false
            }
            withAnimation(Animation.default.delay(0.3)) {
                feedShowAction = .toolbar
            }
        }
        
        ScrollView {
            Button {
                exitAction()
            } label: {
                Image(systemName: "xmark") 
                    .imageScale(.large)
                    .foregroundColor(.womeBlack)
            }
            .padding()
            .padding(.top, AppConstants.safeAreaInsets?.top)
            .frame(maxWidth: .infinity, alignment: .trailing)
            VStack {
                Text("Setup a publication type")
                    .foregroundColor(.womeBlack)
                    .font(.openSansRegular(size: 24))
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                PublicationTypeSelectionView()
                    .onAppear {
                        withAnimation {
                            applyViewDelay = false
                            viewModel.storyAnimationProgress = 1
                        }
                    }
                
                
                CreationFieldsView()
                
                VStack(alignment: .leading) {
                    WaterfallGrid(viewModel.selectedAssets, id: \.self) { asset in
                        VStack {
                                Button {
                                    withAnimation {
                                        viewModel.showAssetsViewer = true
                                        viewModel.selectedAsset = asset
                                    }
                                } label: {
                                    Image(uiImage: asset.image)
                                        .resizable()
                                        .scaledToFit()
                                        .fixedSize(horizontal: false, vertical: true)
                                        .cornerRadius(22)
                                        .overlay(
                                            Button {
                                                withAnimation {
                                                    viewModel.send(action: .deleteAsset(asset: asset))
                                                }
                                            } label: {
                                                ZStack {
                                                    Circle()
                                                        .fill(Color.white)
                                                        .frame(width: 30, height: 30)
                                                        .shadow(color: Color.womeBlack.opacity(0.3), radius: 8, x: 4, y: 5)
                                                    Image(systemName: "minus")
                                                        .foregroundColor(.womeBlack)
                                                }
                                                .offset(x: 3, y: -3)
                                            },
                                            alignment: .topTrailing
                                        )
                                }
                        }
                        .transition(.asymmetric(insertion: .slide, removal: .opacity))
                        .animation(.default)
                    }
                    .padding()
       
                    
                    if let message = viewModel.selectedAssetsValidation.message {
                        Text(message)
                            .foregroundColor(.red)
                            .font(Font.footnote.weight(.medium))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .transition(AnyTransition.opacity.animation(.easeIn))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 150)
            }
            .frame(maxWidth: 712)
        }
        .onTapGesture {
            applyViewDelay = false
        }
        .padding(.bottom, keyboardHandler.keyboardHeight)
        .animation(Animation.default.delay(applyViewDelay ? 0.3 : 0))
        .overlay(
            VStack {
                if applyActionMenuTransition {
                    ActionMenu() {
                        withAnimation {
                            viewModel.showErrorView =
                                viewModel.canPublish ? false : true
                            
                            if viewModel.canPublish {
                                viewModel.send(action: .createPublication(publications: publications)) { feedPublications in
                                    publications = feedPublications
                                }
                                
                                viewModel.generator.notificationOccurred(.success)
                                
                                exitAction()
                            }
                        }
                    }
                    .padding(.bottom, AppConstants.safeAreaInsets?.bottom)
                    .padding(.bottom,
                             AppConstants.safeAreaInsets?.bottom ?? 0 > 0
                                ? 0
                                : 16
                    )
                    .transition(.move(edge: .trailing))
                }
            },
            alignment: .bottomTrailing
        )
        .overlay(
            VStack {
                if viewModel.showAssetsViewer {
                    AssetsViewer(bounds: bounds)
                        .frame(maxWidth: 412)
                }
            }
            .transition(.move(edge: .bottom))
        )
        .overlay(
            VStack {
                if viewModel.showErrorView {
                    ZStack {
                        Color.black.opacity(0.3).ignoresSafeArea()
                            .animation(Animation.default.delay(0.3))
                        
                        ErrorView()
                            .transition(.slide)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        viewModel.generator.notificationOccurred(.error)
                    }
                }
            }
            
        )
        .onAppear {
            withAnimation(Animation.default.delay(0.7)) {
                applyActionMenuTransition = true
            }
        }
        .sheet(isPresented: $viewModel.showPhotoPicker) {
            PhotoPicker(pickeedAssets: $viewModel.selectedAssets, pickedAssets: $x, isShown: $viewModel.showPhotoPicker, selectionLimit: 0)
        }
        .environmentObject(viewModel)
    }
}

struct PublicationCreationView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { bounds in
            PublicationCreationView(publications: .constant([]), feedShowAction: .constant(.publicationCreation), applyViewTransition: .constant(true), applyViewDelay: .constant(false), bounds: bounds)
                .ignoresSafeArea(.all, edges: .top)
        }
    }
}
