//
//  PubliacationDetailsView.swift
//  Wome
//
//  Created by Maxim Soroka on 17.06.2021.
//

import SwiftUI
import CollectionViewPagingLayout
import SDWebImageSwiftUI

struct PublicationDetailsView: View {
    @StateObject private var viewModel = PublicationDetailsViewModel()
    @Binding var story: Publication.Story?
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                HStack(alignment: .top) {
                    Button {
                        withAnimation {
                            story = nil
                        }
                    } label : {
                        Circle()
                            .fill(Color(UIColor.systemGray5))
                            .frame(width: 25, height: 25)
                            .overlay(
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.womeBlack)
                            )
                    }
                    
                    Spacer()
                    
                    HStack {
                        VStack(alignment: .trailing) {
                            Text("Tanya Soroka")
                                .font(.openSansBold(size: 14))
                                .foregroundColor(.womeBlack)
                            Text("Post Author")
                                .font(.openSansBold(size: 10))
                                .foregroundColor(.secondary)
                        }
                        
                        Image("showcase-cell-2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35) 
                            .clipShape(Circle())
                    }
                }
                .padding()
                .padding(.top, AppConstants.safeAreaInsets?.top)
                
                VStack(alignment: .leading) {
                    if let story = story {
                        Text(story.title ?? "")
                            .font(.openSansRegular(size: 30))
                            .foregroundColor(.womeBlack)
                            .multilineTextAlignment(.leading)
                            .padding([.horizontal, .bottom])
                        
                        ScalePageView(story.images ?? []) { asset in
                            Image(uiImage: asset.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipped()
                                .contentShape(Rectangle())
                                .frame(width: AppConstants.screen.width)
                                .background(
                                Image(uiImage: asset.image)
                                    .resizable()
                                    .scaleEffect(2)
                                    .frame(width: AppConstants.screen.width)
                                    .clipped()
                                    .blur(radius: 20)
                                    .contentShape(Rectangle())
                                )
                        }
                        .options(options)
                        .frame(height: 400)
                        
                        Text(story.caption ?? "")
                            .foregroundColor(.womeBlack)
                            .multilineTextAlignment(.leading)
                            .font(.openSansRegular(size: 17))
                            .padding()
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            ZStack {
                VStack {
                    if !viewModel.showCommentsView {
                            HStack {
                                Text("Comments")
                                    .font(.openSansSemiBold(size: 15))
                                    .foregroundColor(.womeBlack)
                                Circle()
                                    .fill(Color.womePink)
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Image(systemName: "bubble.left")
                                            .font(.openSansSemiBold(size: 17))
                                            .foregroundColor(.womeWhite)
                                    )
                            }
                            .transition(.opacity)
                    }
                }
                
                VStack {
                    if viewModel.applyTransition {
                        CommentsView(
                            applyTransition: $viewModel.applyTransition,
                            showCommentsView: $viewModel.showCommentsView
                        )
                        .transition(
                            .asymmetric(
                                insertion: .slide,
                                removal: .opacity
                            )
                        )
                    }
                }
            }
            .padding(.leading, viewModel.showCommentsView ? CGFloat(0) : CGFloat(16))
            .frame(maxWidth: viewModel.showCommentsView ? .infinity : nil, maxHeight: viewModel.showCommentsView ? .infinity : nil)
            .background(Color.womeWhite)
            .cornerRadius(viewModel.showCommentsView ? 0 : 45)
            .shadow(color: Color.black.opacity(0.3), radius: 8, x: 5, y: 7)
            .padding(.bottom,viewModel.showCommentsView ? 0
                : 16)
            .padding(.trailing, viewModel.showCommentsView  ? CGFloat(0) : CGFloat(16))
            .padding(.bottom, viewModel.showCommentsView ? CGFloat(0) : AppConstants.safeAreaInsets?.bottom ?? 16)
            .onTapGesture {
                withAnimation {
                    viewModel.showCommentsView = true
                }
                
                withAnimation(Animation.default.delay(0.3)) {
                    viewModel.applyTransition = true
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.womeWhite)
        .statusBar(hidden: true)
        .environmentObject(viewModel)
    }
}

struct PubliacationDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { bounds in
            PublicationDetailsView(story: .constant(nil))
//            FeedView(showNavigationMenu: .constant(false), bounds: bounds)
//                .environmentObject(FeedViewModel())
        }
        .ignoresSafeArea()
    }
}

extension PublicationDetailsView {
    var options: ScaleTransformViewOptions {
        return ScaleTransformViewOptions(
            minScale: 1.00,
            maxScale: 1.00,
            scaleRatio: 0.40,
            translationRatio: .init(x: 1.00, y: 0.20),
            minTranslationRatio: .init(x: -5.00, y: -5.00),
            maxTranslationRatio: .init(x: 2.00, y: 0.00),
            keepVerticalSpacingEqual: true,
            keepHorizontalSpacingEqual: true,
            scaleCurve: .linear,
            translationCurve: .linear,
            shadowEnabled: true,
            shadowColor: .black,
            shadowOpacity: 0.60,
            shadowRadiusMin: 2.00,
            shadowRadiusMax: 13.00,
            shadowOffsetMin: .init(width: 0.00, height: 2.00),
            shadowOffsetMax: .init(width: 0.00, height: 6.00),
            shadowOpacityMin: 0.10,
            shadowOpacityMax: 0.10,
            blurEffectEnabled: false,
            blurEffectRadiusRatio: 0.40,
            blurEffectStyle: .light,
            rotation3d: nil,
            translation3d: nil
        )
    }
    
}
