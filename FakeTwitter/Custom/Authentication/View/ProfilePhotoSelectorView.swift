//
//  ProfilePhotoSelectorView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/17.
//  上傳頁面

import SwiftUI

struct ProfilePhotoSelectorView: View {
    @State
    private var showImagePicker = false
    
    @State
    private var selectedImage:UIImage?
    
    @State
    private var profileImage:Image?
    
    @EnvironmentObject
    var viewModel:AuthViewModel
    
    var body: some View {
        //MARK: set photo
        VStack {
            AuthHeaderView(title1: "Setup account", title2: "Add profile photo")
            
            // upload photo button
            Button {
                print("Pick image here")
                showImagePicker.toggle()
            } label: {
                if let profileImage = profileImage {
                    profileImage
                        .resizable()
                        .modifier(ProfileImageModeifire())
                }
                else{
                    Image(systemName: "person.and.background.dotted")
                        .resizable()
                        .renderingMode(.template)
                        .modifier(ProfileImageModeifire())
                }
                
            }
            // iOS 16 推出後，我們可以輕鬆在 SwiftUI 建立一個互動式 (interactive) bottom sheet,對話視窗
            .sheet(isPresented: $showImagePicker,onDismiss: loadImage) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .padding(.top,44)

            if let selectedImage = selectedImage {
                Button {
                    viewModel.uploadProfilesImage(image: selectedImage)
                } label: {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 340,height: 50)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                        .padding()
                }
                .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
            }
            
            Spacer()
        }
        .ignoresSafeArea()
    }
    
    func loadImage(){
        guard let selectedImage = selectedImage else {
            return
        }
        profileImage = Image(uiImage: selectedImage)
    }
}

private struct ProfileImageModeifire: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(.systemBlue))
            .scaledToFill()
            .frame(width: 180,height: 180)
            .clipShape(Circle())
    }
}

struct ProfilePhotoSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePhotoSelectorView()
    }
}
