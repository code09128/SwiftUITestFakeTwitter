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
    
    
    func login(email: String,password: String) {
        print("DEGUG: Login with email \(email)")
        // firebase auth
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
    
    func signOut(){
        // sets user session to nil so we show login view
        userSession = nil
        
        // signs user out on server
        try? Auth.auth().signOut()
    }
    
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
