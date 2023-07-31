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

                    // 取資料存取
//                    guard let snapshot,
//                          snapshot.exists,
//                          let userData = try? snapshot.data(as: User.self) else {
//                        return
//                    }
//                    print("DEBUG: User data is \(userData.id) ")
                    
//                    guard let snapshotData = snapshot else {
//                        return
//                    }
//
//                    guard let userData = snapshotData.data() else {
//                        return
//                    }
//
//                    print("DEBUG: userData data is \(userData) ")
//                    // print("DEBUG: User data is \(data["email"] ?? "") ")
//
//                    guard let data = try? snapshot?.data(as: User.self) else {
//                        return
//                    }
//
//                    print("DEBUG: User data is \(data) ")
                    
                    completion(user)
                }
            }
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void){
//        var users = [User]()
        
        Firestore.firestore().collection("users")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    return
                }
                
                let users = documents.compactMap({try? $0.data(as: User.self)})
                
//                documents.forEach { document in
//                    guard let userDatas = try? document.data(as: User.self) else {
//                        return
//                    }
//                    users.append(userDatas)
//                }
                
                completion(users)
            }
    }
}
