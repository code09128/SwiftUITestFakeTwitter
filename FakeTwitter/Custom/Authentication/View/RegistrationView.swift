//
//  RegistrationView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/11.
//  註冊頁面

import SwiftUI

struct RegistrationView: View {
    @State
    private var email = ""
    @State
    private var username = ""
    @State
    private var fullname = ""
    @State
    private var password = ""
    
    @Environment(\.presentationMode)
    var presentationMode
    
    @EnvironmentObject
    var viewModel:AuthViewModel
    
    var body: some View {
        // MARK: Creat Account UI
        NavigationStack {
            VStack {
                AuthHeaderView(title1: "Get started.", title2: "Create your account")
                
                // text edit set
                VStack(spacing: 40){
                    CustomInputFieldView(imageName: "envelope", placeholderText: "Email", text: $email )
                    
                    CustomInputFieldView(imageName: "person", placeholderText: "Username", text: $username )
                    
                    CustomInputFieldView(imageName: "person", placeholderText: "Full name", text: $fullname )
                    
                    CustomInputFieldView(imageName: "lock", placeholderText: "Password",isSecureField: true, text: $password )
                }
                .padding(32)
                
                // sign up button
                Button {
                    viewModel.register(email: email, password: password, fullname: fullname, username: username)
                } label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 340,height: 50)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                        .padding()
                }
                .navigationDestination(isPresented: $viewModel.didAuthenticateUser) {
                    ProfilePhotoSelectorView()
                }
                .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Spacer()
                
                // bottom sign in button
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Text("Dont have an account")
                            .font(.caption)
                        
                        Text("Sign In")
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.bottom,32)
            }
            .ignoresSafeArea()
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
