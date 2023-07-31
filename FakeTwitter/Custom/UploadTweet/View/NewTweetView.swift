//
//  NewTweetView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/11.
//

import SwiftUI
import Kingfisher

struct NewTweetView: View {
    @State
    private var caption = ""
    
    @Environment(\.presentationMode)
    var presentationMode
    
    @EnvironmentObject
    var authViewModel:AuthViewModel
    
    @ObservedObject
    var viewModel = UploadTweetViewModel()
     
    var body: some View {
        VStack {
            HStack {
                // cancel button
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundColor(Color(.systemBlue))
                }

                Spacer()
                
                Button {
                    viewModel.uploadTweet(caption: caption)
                    print("Tweet")
                } label: {
                    Text("Tweet")
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color(.systemBlue))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
            .padding()
            
            // send message
            HStack(alignment: .top) {
                if let user = authViewModel.currentUser {
                    KFImage(URL(string: user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 64, height: 64)
                }
                
                TextArea(text: $caption, placeholder: Text("Say something"))
            }
            .padding()
        }
        .onReceive(viewModel.$didUploadTweet) { success in
            if success {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct NewTweetView_Previews: PreviewProvider {
    static var previews: some View {
        NewTweetView()
    }
}
