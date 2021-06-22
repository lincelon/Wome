//
//  ProfileView.swift
//  Wome
//
//  Created by Maxim Soroka on 18.06.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var x: [Asset] = []
    @Binding var showNavigationMenu: Bool
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Profile Settings")
                .font(.openSansBold(size: 32))
                .foregroundColor(.womeBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.top)
                .padding(.top, AppConstants.safeAreaInsets?.top)
            
            VStack(spacing: 16) {
                HStack(alignment: .top, spacing: 30) {
                    Button {
                        viewModel.showPhotoPicker = true
                    } label: {
                        if let image = viewModel.pickedAsssets.first {
                            Image(uiImage: image )
                                .resizable()
                                .scaledToFill()
                                .frame(width: 130, height: 200)
                                .cornerRadius(22)
                        } else {
                            WebImage(
                                url:
                                    URL(
                                        string: viewModel.currentUser?.profileImageURL ?? ""
                                    )
                            )
                            .resizable()
                            .scaledToFill()
                            .frame(width: 130, height: 200)
                            .cornerRadius(22)
                        }
                    }
                    .shadow(color: Color.womeBlack.opacity(0.3), radius: 7, x: 5, y: 7)
                    
                    VStack(spacing: 20) {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.womePink)
                            TextField("Username", text: $viewModel.username)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.womeWhite)
                        .cornerRadius(12)
                        .shadow(color: Color.womeBlack.opacity(0.3), radius: 7, x: 5, y: 7)
                        
                        HStack {
                            Image(systemName: "mail.fill")
                                .foregroundColor(.womePink)
                            TextField("Full name", text: $viewModel.fullname)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.womeWhite)
                        .cornerRadius(12)
                        .shadow(color: Color.womeBlack.opacity(0.3), radius: 7, x: 5, y: 7)
                        
                        AsyncButton(isComplete: viewModel.isCompleted) {
                            withAnimation {
                                viewModel.sendAction(action: .updateSettings)
                            }
                        } label: {
                            Text("Update")
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    
                }
                
                Button {
                    withAnimation {
                        viewModel.sendAction(action: .logout)
                    }
                } label: {
                    Text("Sign Out")
                        .font(.openSansSemiBold(size: 17))
                        .foregroundColor(.womeWhite)
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color.womePink)
                .cornerRadius(12)
            }
            .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.womeWhite)
        .sheet(isPresented: $viewModel.showPhotoPicker) {
            PhotoPicker(pickeedAssets: $x, pickedAssets: $viewModel.pickedAsssets, isShown: $viewModel.showPhotoPicker, selectionLimit: 1)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(showNavigationMenu: .constant(false))
    }
}

struct AsyncButton<Content: View>: View {
    
    var isComplete: Bool
    let action: ()->()
    let content: Content
    
    @State private var inProgress: Bool
    
    init(isComplete: Bool, action: @escaping ()->(), @ViewBuilder label: ()->Content) {
        self.action = action
        self.isComplete = isComplete
        self.content = label()
        self._inProgress = State.init(initialValue: false)
    }
    
    var body: some View {
        Button(action: {
            if !inProgress { action() }
            withAnimation(Animation.easeInOut(duration: 0.4)) {
                inProgress = true
            }
            
        }, label: {
            VStack(alignment: .trailing) {
                if inProgress && !isComplete {
                    ProgressView()
                        .foregroundColor(.white)
                } else if isComplete {
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 15, height: 15, alignment: .center)
                        .foregroundColor(.white)
                } else {
                    content
                }
            }
            .frame(maxWidth: isComplete || inProgress ? 50 : .infinity, maxHeight: isComplete  || inProgress ? 50 : nil, alignment: .center)
            .padding(.vertical, isComplete  || inProgress ? 0 : 12)
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(isComplete || inProgress ? 25 : 8)
            .font(Font.body.weight(.semibold)) 
            .padding(.all, isComplete || inProgress ? 20 : 0)
        })
    }
    
    
}
