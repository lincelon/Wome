//
//  AuthenticationView.swift
//  Wome
//
//  Created by Maxim Soroka on 19.06.2021.
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @StateObject private var keyboardHandler = KeyboardHandler()
    
    var body: some View {
        GeometryReader { bounds in
            ZStack {
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color(#colorLiteral(red: 0.9921568627, green: 0.6, blue: 0.7764705882, alpha: 1)),
                            Color.white,
                            Color(#colorLiteral(red: 0.7137254902, green: 0.6862745098, blue: 0.8078431373, alpha: 1))
                        ]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ZStack {
                    VStack {
                        if viewModel.showAuthenticationView {
                            VStack {
                                Spacer()
                                
                                VStack(spacing: 20) {
                                    Text("Wome")
                                        .font(.system(size: 45, weight: .bold, design: .rounded))
                                        .foregroundColor(.womeBlack)
                                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua")
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(5)
                                        .font(.openSansRegular(size: 16))
                                        .foregroundColor(Color(UIColor.systemGray))
                                }
                                .padding()
                                
                                Spacer()
                                
                                VStack(spacing: 20) {
                                    VStack(spacing: 12) {
                                        AuthenticationActionButton(
                                            systemImageName: "envelope.fill",
                                            title: "Login with Email",
                                            backgroundColor: Color.white.opacity(0.7),
                                            foregroundColor: .black
                                        ) {
                                            withAnimation {
                                                viewModel.showLoginView = true
                                                viewModel.showAuthenticationView = false
                                            }
                                        }
                                        
                                        AuthenticationActionButton(
                                            systemImageName: "applelogo",
                                            title: "Login with Apple",
                                            backgroundColor: .black,
                                            foregroundColor: .white
                                        ) { }
                                        
                                    }
                                    
                                    HStack {
                                        Text("Don`t have an account?")
                                            .font(.openSansRegular(size: 16.5))
                                            .foregroundColor(.secondary)
                                        
                                        Button {
                                            withAnimation {
                                                viewModel.showSignupView = true
                                                viewModel.showSignUpFromAuthView = true
                                                
                                                viewModel.showAuthenticationView = false
                                            }
                                        } label: {
                                            Text("Sign up")
                                                .font(.openSansRegular(size: 16.5))
                                                .foregroundColor(.womeBlack)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .transition(
                                .scale(scale: 0, anchor: .topTrailing)
                            )
                        }
                        
                        VStack {
                            if viewModel.showLoginView {
                                LoginView()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .transition(
                                        .scale(scale: 0, anchor: .bottomLeading)
                                    )
                            }
                        }
                    }
                    
                    VStack {
                        if viewModel.showSignupView {
                            SignupView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .transition(
                                    .scale(scale: 0, anchor: .bottomTrailing)
                                )
                        }
                    }
                }
                .frame(maxWidth: 712)
                .animation(.default)
                .ignoresSafeArea(.keyboard)
            }
            .frame(width: bounds.size.width)
            .overlay(
                LoadingView(isLoading: $viewModel.isLoading, errorMessage: $viewModel.errorMessage)
            )
            .environmentObject(viewModel)
            .animation(.default)
        }
    }
}

struct AuthenticationActionButton: View {
    let systemImageName: String
    let title: String
    let backgroundColor: Color
    let foregroundColor: Color
    
    let action: () -> ()
    
    var body: some View {
        VStack {
            Button {
                action()
            } label: {
                Image(systemName: systemImageName)
                    .font(.title3)
                    .foregroundColor(.black)
                    .padding(12)
                    .background(Color.white)
                    .clipShape(Circle())
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(
                        Text(title)
                            .font(.openSansSemiBold(size: 17))
                            .padding(22)
                            .foregroundColor(foregroundColor)
                    )
                    .padding(.vertical, 12)
                    .background(backgroundColor)
                
            }
            .clipShape(Capsule())
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isLoading: .constant(false), errorMessage: .constant("User does not have permission to access gs://wome-6b077.appspot.com/images_profile/D8E252B3-E98D-4ECD-921D-E78492C8F551."))
    }
}


struct LoadingView: View {
    @Binding var isLoading: Bool
    @Binding var errorMessage: String?
    
    var body: some View {
        if isLoading {
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                LottieView(name: "loading", loopMode: .loop)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(22)
                    .frame(width: 150, height: 150)
            }
        }
        
        if let message = errorMessage {
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Text(message)
                        .font(.openSansRegular(size: 15))
                        .foregroundColor(.womeBlack)
                    
                    Button {
                        withAnimation {
                            isLoading = false
                            errorMessage = nil
                        }
                    } label: {
                        Text("Okey")
                            .font(.openSansSemiBold(size: 15))
                            .foregroundColor(.womeBlack)
                    }
                }
                .padding(32)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 22))
            }
        }
    }
}
