# SwiftUI test demo uses MVVM architecture to create fake Twitter UI, and uses Firebase to fetch &amp; display user data from API

## Firebase API set to your project 
https://firebase.google.com/docs/ios/setup#swiftui

## Firestore data with Swift
https://firebase.google.com/docs/firestore/solutions/swift-codable-data-mapping

We need to use Firebase service API as below:
- Authentication
- Firestore Database 
- Storage

## Kingfisher library, for downloading and caching images from the web
https://github.com/onevcat/Kingfisher

## Login Sign In UI
<div  align="center">
<img src="https://github.com/code09128/SwiftUITestFakeTwitter/assets/32324308/7fc92da6-0f24-4a5f-9e72-1f4ffc25354e" width="350px"/>
</div>

### LoginView
```swift
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
```

## Register Account UI
<div  align="center">
<img src="https://github.com/code09128/SwiftUITestFakeTwitter/assets/32324308/443a1501-be63-4352-8b92-ecb15a7c3c2a" width="350px"/>
</div>

## RegistrationView
```swift
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
```

## CustomInputTextFieldView
```swift
//
//  CustomInputFieldView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/11.
//

import SwiftUI

struct CustomInputFieldView: View {
    let imageName: String
    let placeholderText: String
    var isSecureField:Bool? = false
    
    @Binding
    var text: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(.darkGray))
                
                if isSecureField ?? false {
                    SecureField(placeholderText, text: $text)
                }
                else {
                    TextField(placeholderText, text: $text)
                }
            }
            
            Divider()
                .background(Color(.darkGray))
        }
    }
}

struct CustomInputFieldView_Previews: PreviewProvider {
    static var previews: some View {
        CustomInputFieldView(imageName: "envelope", placeholderText: "Email",isSecureField: false, text: .constant(""))
    }
}

```


## USER Model
```swift
//
//  User.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/19.
//

import FirebaseFirestoreSwift
import FirebaseAuth

struct User: Identifiable,Decodable {
    @DocumentID
    var id: String?
    let username: String
    let fullname: String
    let profileImageUrl: String
    let email: String
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == id
    }
}
```

## AuthViewModel
```swift
//
//  AuthViewModel.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/12.
//  Firebase Firestore & FirebaseAuth API ViewModel

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published
    var userSession: FirebaseAuth.UserInfo?
    
    @Published
    var didAuthenticateUser = false
    
    @Published
    var currentUser: User?
    
    private var tempUserSession: FirebaseAuth.UserInfo?
    
    private let service = UserService()
    
    init() {
        userSession = Auth.auth().currentUser
        self.fetchUser()
        print("DEBUG: User session is \(String(describing: userSession?.uid))")
    }
    
    /// Login登入API 連結firebaseAuth sign in認證 email password
    /// - Parameters:
    ///   - email: 帳號用email
    ///   - password: 登入密碼
    func login(email: String,password: String) {
        print("DEGUG: Login with email \(email)")
        // firebase auth sign in
        Auth.auth().signIn(withEmail: email, password: password){ [self] result,error in
            if let error = error {
                print("DEBUF: failed to register with error \(error.localizedDescription)")
            }
            
            guard let user = result?.user else {
                return
            }
            
            self.userSession = user
            self.fetchUser()
            print("DEBUG: did log user in")
        }
    }
    
    /// 註冊用API 連結firebaseAuth creat user 註冊資料
    /// - Parameters:
    ///   - email: 帳號用email
    ///   - password: 登入密碼
    ///   - fullname: 全名
    ///   - username: 使用者名稱
    func register(email:String,password:String,fullname:String,username:String){
        //firebase auth api
        Auth.auth().createUser(withEmail: email, password: password){ [self] result,error in
            if let error = error {
                print("DEBUF: failed to register with error \(error.localizedDescription)")
            }
            
            guard let user = result?.user else {
                return
            }
//            self.userSession = user
            
            print("DEBUG: registered user successfully")
            self.tempUserSession = user
            
            // login successfully sets data and upload to firebase database
            let data = ["email":email,
                        "username":username.lowercased(),
                        "fullname":fullname,
                        "uid":user.uid]
            
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData(data) {
                    result in
                    
                    print("DEBUG: did upload user data")
                    self.didAuthenticateUser = true
                }
        }
    }
    
    /// firebase Auth signOut登出
    func signOut(){
        // sets user session to nil so we show login view
        userSession = nil
        
        // signs user out on server
        try? Auth.auth().signOut()
    }
    
    /// firebase updateData 新增上傳檔案相片
    /// - Parameter image: 檔案相片路徑
    func uploadProfilesImage(image:UIImage){
        guard let uid = tempUserSession?.uid else {
            return
        }
        
        // update image upload to firebase firestore
        ImageUploader.uploadImage(image: image) { profileImageUrl in
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(["profileImageUrl" : profileImageUrl]) {
                    result in
                    
                    self.userSession = self.tempUserSession
                    self.fetchUser()
                }
        }
    }
    
    /// 新增使用者
    func fetchUser(){
        guard let uid = self.userSession?.uid else {
            return
        }
        
        service.fetchUser(uid: uid) { user in
            self.currentUser = user
            print("currentUser \(String(describing: self.currentUser))")
        }
    }
}
```

## UserService
```swift
//
//  UserService.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/18.
//

import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserService {
    /// 取得使用者資料 Firestore get datas
    /// - Parameters:
    ///   - uid: 使用者uid
    ///   - completion: 回傳USER model
    func fetchUser(uid:String, completion: @escaping(User) -> Void){
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, error in
                
                if let error = error as NSError? {
                    print("Error getting document: \(error.localizedDescription)")
                }
                else{
                    // Firestore get datas
                    let id = snapshot?.documentID
                    let data = snapshot?.data()
                    let fullname = data?["fullname"] as? String ?? ""
                    let username = data?["username"] as? String ?? ""
                    let profileImageUrl = data?["profileImageUrl"] as? String ?? ""
                    let email = data?["email"] as? String ?? ""
                    
                    let user = User(username: username, fullname: fullname, profileImageUrl: profileImageUrl, email: email)
                    
                    print("DEBUG: document data documentID is \(String(describing: id)) ")
                    print("DEBUG: document data data is \(String(describing: data)) ")
                    print("DEBUG: document data fullname is \(String(describing: fullname)) ")
                    print("DEBUG: document user data is \(String(describing: data)) ")

                    completion(user)
                }
            }
    }
    
    
    /// 取得使用者資料 Firestore get datas
    /// - Parameter completion: 回傳USER model
    func fetchUsers(completion: @escaping([User]) -> Void){
        
        Firestore.firestore().collection("users")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    return
                }
                
                let users = documents.compactMap({try? $0.data(as: User.self)})
                
                completion(users)
            }
    }
}
```

## UploadImageProfile
<div  align="center">
<img src="https://github.com/code09128/SwiftUITestFakeTwitter/assets/32324308/8e311f95-f701-4448-81bf-003fa9797d9e" width="320px"/>
<img src="https://github.com/code09128/SwiftUITestFakeTwitter/assets/32324308/bcc95968-d261-47a4-8075-d116c4800d9b" width="320px"/>
<img src="https://github.com/code09128/SwiftUITestFakeTwitter/assets/32324308/fda7c991-2c0d-416b-ae59-68ca1e5a88ac" width="320px"/>
</div>

```swift
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
                // profileImage picker style
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

            // upload profileImage
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
```

## Util - ImagePicker Set

```swift
//
//  ImagePicker.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/17.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding
    var selectedImage: UIImage?
    
    @Environment(\.presentationMode)
    var presentationMode
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
        
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

extension ImagePicker {
    class Coordinator: NSObject,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else {return}
            parent.selectedImage = image
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
```

## ImageUploader

```swift
//
//  ImageUploader.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/18.
//

import UIKit
import Firebase
import FirebaseStorage

struct ImageUploader {
    
    static func uploadImage(image:UIImage,completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_image/\(filename)")
        
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("DEBUG: failed to upload image with error \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { imageUrl, _ in
                guard let imageUrl = imageUrl?.absoluteString else {
                    return
                }
                
                completion(imageUrl)
            }
        }
    }
}
```

## MainTabView
<div  align="center">
<img src="https://github.com/code09128/SwiftUITestFakeTwitter/assets/32324308/0adb3817-1aaa-4dab-89f7-e46c7c08411c" width="350px"/>
</div>

```swift
//
//  MainTabView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/4.
//  選擇主頁面動作

import SwiftUI

struct MainTabView: View {
    @State private var selectedIndex = 0
    
    var body: some View {
        // TableView set select button
        TabView(selection: $selectedIndex) {
            FeedView()
                .onTapGesture {
                    self.selectedIndex = 0
                }
                .tabItem {
                    Image(systemName: "house")
                }.tag(0)
            
            ExploreView()
                .onTapGesture {
                    self.selectedIndex = 1
                }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }.tag(1)
            
            NotificationView()
                .onTapGesture {
                    self.selectedIndex = 2
                }
                .tabItem {
                    Image(systemName: "bell")
                }.tag(2)
            
            MessagesView()
                .onTapGesture {
                    self.selectedIndex = 3
                }
                .tabItem {
                    Image(systemName: "envelope")
                }.tag(3)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
```
