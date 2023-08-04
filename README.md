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

## This App function & UI
LoginPage
- Login
- Register
- UploadImage
  
MainPage
- Home
  - NewTweetMessage
- Explore
  - Search
- SideMenu
  - Profile
  - Lists
  - BookMarks
  - Logout
- NotificationUI
- MessageUI
  
## Login Sign In UI
<div  align="center">
<img src="https://github.com/code09128/SwiftUITestFakeTwitter/assets/32324308/7fc92da6-0f24-4a5f-9e72-1f4ffc25354e" width="350px"/>
</div>


## LoginView
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

## Custom Text RoundedShape

```swift
//
//  RoundedShape.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/11.
//

import Foundation
import SwiftUI

struct RoundedShape: Shape {
    var corners: UIRectCorner
    
    func path(in rect:CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 80, height: 80))
        
        return Path(path.cgPath)
    }
}
```


## CustomInputFieldView

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


## FeedView

<div  align="center">
<img src="https://github.com/code09128/SwiftUITestFakeTwitter/assets/32324308/3a1f358c-fd42-4db7-b799-7f2632f6a221" width="350px"/>
</div>

```swift
//
//  FeedView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/6/19.
//

import SwiftUI

struct FeedView: View {
    @State
    private var showNewTweetView = false
    
    @ObservedObject
    var viewModel = FeedViewModel()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack {
                    //KeyPath 的標準寫法是 \ + 型別. + property
                    ForEach(viewModel.tweets){
                        tweets in
                        TweetRowView(tweet: tweets)
                            .padding()
                    }
                }
            }
            
            //右下的訊息按鈕
            Button {
                showNewTweetView.toggle()
            } label: {
              Image(systemName: "envelope")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 28, height: 28)
                    .padding()
            }
            .background(Color(.systemBlue))
            .foregroundColor(.white)
            .clipShape(Circle())
            .padding()
            .fullScreenCover(isPresented: $showNewTweetView) {
                NewTweetView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
```

## FeedViewModel
```swift
//
//  FeedViewModel.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/25.
//

import Foundation

class FeedViewModel: ObservableObject {
    @Published
    var tweets = [Tweet]()
    
    let service = TweetService()
    let userService = UserService()
    
    init() {
        fetchTweets()
    }

    func fetchTweets(){
        service.fetchTeewts { tweets in
            self.tweets = tweets
            
            for i in 0 ..< tweets.count {
                let uid = tweets[i].uid
                
                self.userService.fetchUser(uid: uid) { user in
                    self.tweets[i].user = user
                }
            }
        }
    }
}

// [tweet1, tweet2, tweet3]
```


## upload NewTweet Message

<div  align="center">
<img src="https://github.com/code09128/SwiftUITestFakeTwitter/assets/32324308/905246c7-a395-4d3f-af8b-f31c65ec2fc6" width="350px"/>
</div>

## NewTweetView 
```swift
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
```


## UploadTweetViewModel
```swift
//
//  UploadTweetViewModel.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/25.
//

import Foundation

class UploadTweetViewModel: ObservableObject {
    @Published var didUploadTweet = false
    let service = TweetService()
    
    func uploadTweet(caption:String){
        service.uploadTweet(caption: caption) { success in
            if success {
                // dismiss screen somehow
                self.didUploadTweet = true
            }
            else {
                // showm error message
            }
        }
    }
}
```


## Set Custom TextArea Message 

```swift
//
//  TextAreaView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/11.
//

import SwiftUI

struct TextArea: View {
    @Binding
    var text: String
    
    let placeholder: Text
    
    /// 初始化設置元件
    /// - Parameters:
    ///   - text: 輸入的文字
    ///   - placeholder: 未輸入文字顯示的文字訊息
    init(text: Binding<String>,placeholder: Text) {
        self._text = text
        self.placeholder = placeholder
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                placeholder
                    .foregroundColor(.gray.opacity(0.4))
            }
            
            TextField("", ㄏㄏtext: $text)
        }
        .padding(10)
    }
}
```

## ExploreView
<div align="center">
<img src="https://github.com/code09128/SwiftUITestFakeTwitter/assets/32324308/c1eee5ad-6554-470e-8817-0f0bd7f5c2c2" width="350px"/>
<img src="https://github.com/code09128/SwiftUITestFakeTwitter/assets/32324308/ba532e26-1e70-4e42-bb45-b1baf9917aba" width="350px"/>
</div>

```swift
//
//  ExploreView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/4.
//

import SwiftUI

struct ExploreView: View {
    @ObservedObject
    var viewModel = ExploreViewModel()
    
    var body: some View {
        VStack {
            SearchBarView(text: $viewModel.searchText)
                .padding()
            
            ScrollView{
                LazyVStack {
                    ForEach (viewModel.searchableUsers){ user in
                        NavigationLink {
                            ProfileView(user: user)
                        } label: {
                            UserRowView(user: user)
                        }
                    }
                }
            }
        }
        .navigationTitle("Explore")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
```


## ExploreViewModel
```swift
//
//  ExploreViewModel.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/21.
//

import Foundation

class ExploreViewModel: ObservableObject {
    @Published
    var users = [User]()
    @Published
    var searchText = ""
    
    var searchableUsers: [User] {
        if searchText.isEmpty {
            return users
        }
        else{
            // 比對文字大小寫
            let lowercaseQuery = searchText.lowercased()
            
            return users.filter({
                $0.username.contains(lowercaseQuery) ||
                $0.fullname.lowercased().contains(lowercaseQuery)
            })
        }
    }
    
    let service = UserService()
    
    init() {
        fetchUsers()
    }
    
    func fetchUsers(){
        service.fetchUsers { users in
            self.users = users
            
            print("DEBUG: users\(users)")
        }
    }
}
```


## SearchView 

```swift
//
//  SearchBarView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding
    var text: String
    
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(8)
                .padding(.horizontal,24)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay (
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0,maxWidth: .infinity,alignment: .leading)
                            .padding(.leading,8)
                    }
                )
        }
        .padding(.horizontal,4)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(text: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
```


## SideMenuView


<div align="center">
<img src="https://github.com/code09128/SwiftUITestFakeTwitter/assets/32324308/638c3157-02a4-4375-b019-5871fc0e7480" width="350px"/>
</div>


```swift
//
//  SideMenuView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/10.
//

import SwiftUI
import Kingfisher

struct SideMenuView: View {
    @EnvironmentObject
    var authViewModel:AuthViewModel
    
    var body: some View {
        if let user = authViewModel.currentUser {
            VStack(alignment: .leading,spacing: 32) {
                VStack(alignment: .leading) {
                    KFImage(URL(string: user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 48,height: 48)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.fullname)
                            .font(.headline)
                        
                        Text("@\(user.username)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    UserStatsView()
                        .padding(.vertical)
                }
                .padding(.leading)
                
                ForEach(SideMenuViewModel.allCases, id: \.rawValue){ ViewModelResult in
                    
                    if ViewModelResult == .profile {
                        NavigationLink {
                            //點擊連結前往的地方
                            ProfileView(user: user)
                        } label: {
                            SideMenuOptionRowView(viewModel: ViewModelResult)
                        }
                    }
                    else if ViewModelResult == .logout {
                        Button {
                            authViewModel.signOut()
                        } label: {
                            SideMenuOptionRowView(viewModel: ViewModelResult)
                        }
                    }
                    else{
                        SideMenuOptionRowView(viewModel: ViewModelResult)
                    }
                }
                
                Spacer()
            }
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
    }
}
```

## Custom SideMenuRowView 

``` swift
//
//  SideMenuRowView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/10.
//

import SwiftUI

struct SideMenuOptionRowView: View {
    let viewModel: SideMenuViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: viewModel.imageName)
                .font(.headline)
                .foregroundColor(.gray)
            
            Text(viewModel.title)
                .foregroundColor(.black)
                .font(.subheadline)
            
            Spacer()
        }
        .frame(height:40)
        .padding(.horizontal)
    }
}

struct SideMenuRowView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuOptionRowView(viewModel: .profile)
    }
}
```


## SideMenuViewModel

```swift
//
//  SideMenuViewModel.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/10.
//

import Foundation

enum SideMenuViewModel: Int,CaseIterable {
    case profile
    case lists
    case bookmarks
    case logout
    
    var title: String {
        switch self {
        case .profile: return "Profile"
        case .lists: return "Lists"
        case .bookmarks: return "Bookmarks"
        case .logout: return "Logout"
        }
    }
    
    var imageName: String {
        switch self {
        case .profile: return "person"
        case .lists: return "list.bullet"
        case .bookmarks: return "bookmark"
        case .logout: return "arrow.left.square"
        }
    }
}
```


## ProfileView
<div align = "center">
<img src = "https://github.com/code09128/SwiftUITestFakeTwitter/assets/32324308/74a9b9bb-ba14-4f9c-a7e9-f30ce10a4d78" width= "350px">
</div>


```swift
//
//  ProfileView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/7.
//  個人頁面

import SwiftUI
import Kingfisher

struct ProfileView: View {
    @State
    private var selectedFilter: TweetFilterViewModel = .tweets
    
    @ObservedObject
    var viewModel: ProfileViewModel
    
    @Environment(\.presentationMode) //實現按鈕跳轉/關閉動作
    var mode
    
    @Namespace
    var animation
        
    init(user:User) {
        self.viewModel = ProfileViewModel(user: user)
    }
    
    var body: some View {
        VStack(alignment: .leading){
            headerView
            actionButton
            userInfoDetail
            tweetFilterBar
            tweetViewData
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(user: User(username: "Batman", fullname: "Bruce Wayne", profileImageUrl: "", email: "batmain@gmail.com"))
//    }
//}

extension ProfileView {
    // MARK: Title & Profile photo
    var headerView: some View {
        ZStack(alignment: .bottomLeading){
            Color(.systemBlue)
                .ignoresSafeArea()
            
            VStack {
                // left button
                Button {
                    mode.wrappedValue.dismiss()
                } label: {
                   Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 20, height: 16)
                        .foregroundColor(.white)
                        .offset(x:20, y:10)
                }
                
                // profile photo
                KFImage(URL(string: viewModel.user.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 72,height: 72)
                .offset(x:16, y:24)
            }
        }
        .frame(height: 96)
    }
    
    // MARK: Bell & Edit Profile Button
    var actionButton: some View {
        HStack(spacing: 12) {
            Spacer()
            
            // bell
            Image(systemName: "bell.badge")
                .font(.title3)
                .padding(6)
                .overlay(Circle().stroke(Color.gray,lineWidth: 0.75))
            
            //Edit profile
            Button {
                // to do
            } label: {
                Text(viewModel.actionButtonTitle)
                    .font(.subheadline).bold()
                    .frame(width: 128, height: 32)
                    .foregroundColor(.black)
                    .overlay(RoundedRectangle(cornerRadius:20).stroke(Color.gray, lineWidth: 0.75))
            }

        }
        .padding(.trailing)
    }
    
    // MARK: UserInfoDetail
    var userInfoDetail: some View {
        VStack(alignment: .leading){
            HStack {
                Text(viewModel.user.fullname)
                    .font(.title2).bold()
                
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor( Color(.systemBlue))
            }
            
            Text("@\(viewModel.user.username)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Im happy, who are you")
                .font(.subheadline)
                .padding(.vertical)
            
            HStack(spacing: 32) {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                    Text("Goham, NY")
                }
                
                HStack {
                    Image(systemName: "link")
                    Text("www.thejoker.com")
                }
            }
            .font(.caption)
            .foregroundColor(.gray)
            
            UserStatsView()
                .padding(.vertical)
            
        }
        .padding(.horizontal)
    }
    
    //MARK: TweetFilterTabBar
    var tweetFilterBar: some View {
        HStack {
            ForEach(TweetFilterViewModel.allCases,id: \.rawValue) { item in
                VStack {
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(selectedFilter == item ? .semibold : .regular)
                        .foregroundColor(selectedFilter == item ? .black : .gray)
                     
                    if selectedFilter == item {
                        Capsule() //膠囊樣式形狀
                            .foregroundColor(Color(.systemBlue))
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "filter", in: animation)//滑動形式動畫
                    } else {
                        Capsule() //膠囊樣式形狀
                            .foregroundColor(Color(.clear ))
                            .frame(height: 3)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedFilter = item
                    }
                }
            }
        }
        .overlay(Divider().offset(x:0, y:16))
    }
    
    //MARK: TweetViewData
    var tweetViewData: some View {
        ScrollView {
            LazyVStack {
                ForEach (viewModel.tweets(filter: self.selectedFilter)){ result in
                    TweetRowView(tweet: result)
                        .padding()
                }
            }
        }
    }
}
```


## ProfileViewModel

```swift
//
//  ProfileViewModel.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/26.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published
    var tweets = [Tweet]()
    
    @Published
    var likedTweets = [Tweet]()
    
    private let service = TweetService()
    private let userService = UserService()
    
    let user: User
    
    init(user: User) {
        self.user = user
        self.fetchUserTweets()
        self.fetchLikedTweets()
    }
    
    var actionButtonTitle: String {
        return user.isCurrentUser ? "Edit Profile" : "Follow"
    }
    
    func tweets(filter:TweetFilterViewModel) -> [Tweet]{
        switch filter {
        case .tweets:
            return tweets
        case .replies:
            return tweets
        case .likes:
            return likedTweets
        }
    }
    
    func fetchUserTweets(){
        guard let uid = user.id else{
            return
        }
        
        print("service.fetchTweets uid \(uid)")
        
        service.fetchTweets(uid: uid) { tweets in
            self.tweets = tweets
            
            print("service.fetchTweets \(tweets)")
            
            for i in 0 ..< tweets.count {
                self.tweets[i].user = self.user
            }
        }
    }
    
    func fetchLikedTweets() {
        guard let uid = user.id else{
            return
        }
        
        service.fetchLikedTweets(uid: uid) { tweets in
            self.likedTweets = tweets
            
            for i in 0 ..< tweets.count {
                let uid = tweets[i].uid
                
                self.userService.fetchUser(uid: uid) { user in
                    self.likedTweets[i].user = user
                }
            }
        }
    }
}
```

## TweetRowView

``` swift
//
//  TweetRowView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/4.
//  建立table list Item 

import SwiftUI
import Kingfisher

struct TweetRowView: View {
//    let tweet: Tweet
    @ObservedObject
    var viewModel:TweetRowViewModel
    
    init(tweet: Tweet) {
        self.viewModel = TweetRowViewModel(tweet:tweet)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // MARK: profile image + user info + tweet
            if let user = viewModel.tweet.user {
                HStack(alignment: .top, spacing: 12) {
                    KFImage(URL(string: user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 56,height: 56)
                    
                    // MARK: user info & tweet caption
                    VStack (alignment: .leading, spacing: 4){
                        // user info
                        HStack {
                            Text(user.fullname)
                                .font(.subheadline).bold()
                            
                            Text("@\(user.username)")
                                .foregroundColor(.gray)
                                .font(.caption)
                            
                            Text("2w")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        
                        // tweet caption
                        Text(viewModel.tweet.caption)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            
            // MARK: action button
            HStack { 
                Button{
                    //action goes here
                } label: {
                    Image(systemName: "bubble.left")
                        .font(.subheadline)
                }
                
                Spacer()
                
                Button{
                    //action goes here
                } label: {
                    Image(systemName: "arrow.2.squarepath")
                        .font(.subheadline)
                }
                
                Spacer()
                
                Button{
                    // like or unlike UI
                    viewModel.tweet.didlike ?? false ?
                    viewModel.unlikeTweet():
                    viewModel.likeTweet()
                } label: {
                    Image(systemName: viewModel.tweet.didlike ?? false ? "heart.fill" : "heart")
                        .font(.subheadline)
                        .foregroundColor(viewModel.tweet.didlike ?? false ? .red : .gray)
                }
                
                Spacer()
                
                Button{
                    //action goes here
                } label: {
                    Image(systemName: "bookmark")
                        .font(.subheadline)
                }
            }
            .padding()
            .foregroundColor(.gray)
            
            Divider()
        }
    }
}

//struct TweetRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        TweetRowView(tweet: tweet)
//    }
//}
```

## TweetRowViewModel

```swift
//
//  TweetRowViewModel.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/26.
//

import Foundation

class TweetRowViewModel: ObservableObject {
    private let service = TweetService()
    
    @Published
    var tweet: Tweet
    
    init(tweet:Tweet){
        self.tweet = tweet
        checkIfUserLikedTweet()
    }
    
    func likeTweet(){
        service.likeTweet(tweet: tweet) {
            result in
            
            self.tweet.didlike = true
        }
    }
    
    func unlikeTweet() {
        service.unlikeTweet(tweet: tweet) { result in
            self.tweet.didlike = false
        }
    }
    
    func checkIfUserLikedTweet(){
        service.checkIfUserLikedTweet(tweet: tweet) { didLike in
            if didLike {
                self.tweet.didlike = true
            }
        }
    }
}
```

## TweetFeedViewModel

```swift
//
//  TweetFeedViewModel.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/7.
//

import Foundation

enum TweetFilterViewModel: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var title: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Replies"
        case .likes: return "Likes"
        }
    }
}
```


## Tweet Model
```swift
//
//  Tweet.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/25.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Tweet: Identifiable, Decodable {
    @DocumentID
    var id: String?
    let caption: String
    let timestamp: TimeInterval
    let uid: String
    var likes: Int
    var user: User?
    var didlike:Bool? = false
}
```


