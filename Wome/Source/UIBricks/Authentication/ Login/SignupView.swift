//
//  SignupView.swift
//  Wome
//
//  Created by Maxim Soroka on 19.06.2021.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject private var viewModel: AuthenticationViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var x: [Asset] = []
    var body: some View {
        ScrollView(AppConstants.screen.height < 750 ? .vertical : .init()) {
            VStack(spacing: 20) {
                
                Button {
                    withAnimation {
                        viewModel.showSignupView = false
                        if viewModel.showSignUpFromAuthView {
                            viewModel.showAuthenticationView = true
                            viewModel.showSignUpFromAuthView = false
                        } else { viewModel.showLoginView = true }
                        
                        
                        viewModel.email = ""
                        viewModel.fullName = ""
                        viewModel.username = ""
                        viewModel.password = ""
                        
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.title3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Button {
                    viewModel.showPhotoPicker = true
                } label: {
                    Circle()
                        .stroke(Color.womeBlack, lineWidth: 0.7)
                        .frame(width: horizontalSizeClass == .regular ? CGFloat(230) : 130,
                               height: horizontalSizeClass == .regular ? CGFloat(230) : 130)
                        .overlay(
                            VStack {
                                if let first = viewModel.selectedAssets.first {
                                    Image(uiImage: first)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: horizontalSizeClass == .regular ? CGFloat(230) : 130,
                                               height: horizontalSizeClass == .regular ? CGFloat(230) : 130)
                                        .clipShape(Circle())
                                } else {
                                    Image("avatar")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: horizontalSizeClass == .regular ? 230 : 130, height: horizontalSizeClass == .regular ? 230 : 130)
                                        .clipShape(Circle())
                                }
                            }
                        )
                }
                
                Text("Setup your profile")
                    .font(.openSansBold(size: 25))
                    .foregroundColor(.womeBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                AuthenticationTextField(
                    image: Image(systemName: "envelope.fill"),
                    placeHolder: "Email",
                    errorMessage: viewModel.emailValidation.message ?? "",
                    isSecureFiled: false,
                    show: viewModel.email.isEmpty,
                    text: $viewModel.email
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .shadow(color: Color.womeBlack.opacity(0.2), radius: 8, x: 7, y: 4)
                
                
                AuthenticationTextField(
                    image: Image(systemName: "person.fill"),
                    placeHolder: "Username",
                    errorMessage: viewModel.usernameValidation.message ?? "",
                    isSecureFiled: false,
                    show: viewModel.username.isEmpty,
                    text: $viewModel.username
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .shadow(color: Color.womeBlack.opacity(0.2), radius: 8, x: 7, y: 4)
                
                AuthenticationTextField(
                    image: Image(systemName: "mail.fill"),
                    placeHolder: "Full name",
                    errorMessage: viewModel.fullNameValidation.message ?? "",
                    isSecureFiled: false,
                    show: viewModel.fullName.isEmpty,
                    text: $viewModel.fullName
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .shadow(color: Color.womeBlack.opacity(0.2), radius: 8, x: 7, y: 4)
                
                AuthenticationTextField(
                    image: Image(systemName: "lock.fill"),
                    placeHolder: "Password",
                    errorMessage: viewModel.passwordValidation.message ?? "",
                    isSecureFiled: true,
                    show: viewModel.password.isEmpty,
                    text: $viewModel.password
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .shadow(color: Color.womeBlack.opacity(0.2), radius: 8, x: 7, y: 4)
                
                
                Button {
                    withAnimation {
                        viewModel.send(action: .signup)
                    }
                } label: {
                    Text("Sign Up")
                        .foregroundColor(.womeWhite)
                        .font(.openSansSemiBold(size: 20))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.womePink)
                        .cornerRadius(12)
                        .shadow(color: Color.womePink.opacity(0.4), radius: 8, x: 7, y: 4)
                }
                .opacity(!viewModel.canSignup ? 0.7 : 1)
                .disabled(!viewModel.canSignup)
                
                Spacer()
                
                HStack {
                    Text("Already have an account?")
                        .font(.openSansRegular(size: 16.5))
                        .foregroundColor(.secondary)
                    
                    Button {
                        withAnimation {
                            viewModel.showSignupView = false
                            viewModel.showLoginView = true
                            
                            viewModel.email = ""
                            viewModel.fullName = ""
                            viewModel.username = ""
                            viewModel.password = ""
                        }
                    } label: {
                        Text("Sign In")
                            .font(.openSansRegular(size: 16.5))
                            .foregroundColor(.womeBlack)
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $viewModel.showPhotoPicker) {
            PhotoPicker(pickeedAssets: $x, pickedAssets: $viewModel.selectedAssets, isShown: $viewModel.showPhotoPicker, selectionLimit: 1)
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.orange
            
            SignupView()
                .environmentObject(AuthenticationViewModel())
        }
    }
}
