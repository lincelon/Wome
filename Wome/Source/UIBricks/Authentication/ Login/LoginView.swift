//
//  LoginView.swift
//  Wome
//
//  Created by Maxim Soroka on 19.06.2021.
//

import SwiftUI
import Combine

struct LoginView: View {
    @EnvironmentObject private var viewModel: AuthenticationViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Button {
                withAnimation {
                    viewModel.showLoginView = false
                    viewModel.showAuthenticationView = true
                    
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
            
            Image("login")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(.keyboard)
            
            Text("Welcome back!")
                .font(.openSansBold(size: 25))
                .foregroundColor(.womeBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            AuthenticationTextField(
                image: Image(systemName: "envelope.fill"),
                placeHolder: "Email",
                errorMessage: viewModel.emailValidation.message ?? "",
                isSecureFiled: false,
                show: viewModel.email.isEmpty,
                text: $viewModel.email)
                .shadow(color: Color.womeBlack.opacity(0.2), radius: 8, x: 7, y: 4)
            
            AuthenticationTextField(
                image: Image(systemName: "lock.fill"),
                placeHolder: "Password",
                errorMessage: viewModel.passwordValidation.message ?? "",
                isSecureFiled: true,
                show: viewModel.password.isEmpty,
                text: $viewModel.password)
                .shadow(color: Color.womeBlack.opacity(0.2), radius: 8, x: 7, y: 4)
            
            
            Button {
                withAnimation {
                    viewModel.send(action: .login)
                }
            } label: {
                Text("Sign In")
                    .foregroundColor(.womeWhite)
                    .font(.openSansSemiBold(size: 20))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.womePink)
                    .cornerRadius(12)
                    .shadow(color: Color.womePink.opacity(0.4), radius: 8, x: 7, y: 4)
            }
            
            Spacer()
            
            HStack {
                Text("Don`t have an account?")
                    .font(.openSansRegular(size: 16.5))
                    .foregroundColor(.secondary)
                
                Button {
                    withAnimation {
                        viewModel.showLoginView = false
                        viewModel.showSignupView = true
                          
                        viewModel.email = ""
                        viewModel.fullName = ""
                        viewModel.username = ""
                        viewModel.password = ""
                    }
                } label: {
                    Text("Sign up")
                        .font(.openSansRegular(size: 16.5))
                        .foregroundColor(.womeBlack)
                }
            }
        }
        .padding()
        .disableAutocorrection(true)
        .autocapitalization(.none)
    }
}

struct AuthenticationTextField: View {
    let image: Image
    let placeHolder: String
    let errorMessage: String
    var isSecureFiled = false
    var show: Bool
    
    @Binding var text: String
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                image
                    .font(.title2)
                    .foregroundColor(.womePink)
                    .frame(width: 25)
                
                VStack {
                    if isSecureFiled {
                        SecureField("", text: $text)
                        
                    } else { TextField("", text: $text) }
                }
                .foregroundColor(.womeBlack)
                .placeHolder(
                    Text(placeHolder)
                        .foregroundColor(.womeBlack)
                        .font(Font.callout.weight(.semibold)),
                    show: show)
            }
            .opacity(0.85)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(Color.red)
                    .font(Font.footnote.weight(.medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .transition(AnyTransition.opacity.animation(.easeIn))
            }
            
        }
    }
}

struct PlaceHolder<T: View>: ViewModifier {
    var placeHolder: T
    var show: Bool
    
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if show { placeHolder }
            content
        }
    }
}

extension View {
    func placeHolder<T:View>(_ holder: T, show: Bool) -> some View {
        self.modifier(PlaceHolder(placeHolder:holder, show: show))
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
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
            LoginView()
                .environmentObject(AuthenticationViewModel())
        }
    }
}

