//
//  AuthenticationView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/11.
//  登入頁面

import SwiftUI

struct LoginView: View {
    @State
    private var email = ""
    @State
    private var password = ""
    
    @EnvironmentObject
    var viewModel:AuthViewModel 
    
    var body: some View {
        // MARK: Login UI parent container
        VStack {
            // header view
            AuthHeaderView(title1: "Hello", title2: "Welcome back.")
            
            VStack(spacing: 40) {
                CustomInputFieldView(imageName: "envelope", placeholderText: "Email", text: $email )
                
                CustomInputFieldView(imageName: "lock", placeholderText: "Password",isSecureField: true, text: $password )
                
            }
            .padding(.horizontal,32)
            .padding(.top,44)
            
            // forgot password text set
            HStack{
                Spacer()
                
                NavigationLink {
                    Text("Reset password view")
                } label: {
                    Text("Forgot Password")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.systemBlue))
                        .padding(.top)
                        .padding(.trailing,24)
                }
            }
            
            // sign in button
            Button {
                viewModel.login(email: email, password: password)
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 340,height: 50)
                    .background(Color(.systemBlue))
                    .clipShape(Capsule())
                    .padding()
            }
            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
            
            Spacer()
            
            // bottom sign up text
            NavigationLink {
                RegistrationView()
                    .navigationBarHidden(true)
            } label: {
                HStack {
                    Text("Dont have an account")
                        .font(.caption)
                    
                    Text("Sign up")
                        .font(.body)
                        .fontWeight(.semibold)
                }
            }
            .padding(.bottom,32)
            .foregroundColor(Color(.systemBlue))

        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
