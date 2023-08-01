SwiftUI test demo uses MVVM architecture to create fake Twitter UI, and uses Firebase to fetch &amp; display user data from API

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


