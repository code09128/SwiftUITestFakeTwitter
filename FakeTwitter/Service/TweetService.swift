//
//  TweetService.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/25.
//

import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TweetService {
    
    func uploadTweet(caption: String, completion: @escaping(Bool) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let data = ["uid": uid,
                    "caption": caption,
                    "likes": 0,
                    "timestamp": Date().timeIntervalSince1970] as [String : Any]
        
        Firestore.firestore().collection("tweets").document()
            .setData(data){ error in
                
                if let error = error {
                    print("DEBUG: Faild to upload tweet with error ...")
                    completion(false)
                    return
                }
                
                completion(true)
            }
    }
    
    /** fetch Tweets text list*/
    func fetchTeewts(completion: @escaping([Tweet]) -> Void){
        Firestore.firestore().collection("tweets")
            .order(by: "timestamp",descending: true)
            .getDocuments { snapshot, error in
            
                guard let documents = snapshot?.documents else {
                return
            }
            
//            documents.forEach { doc in
//                print("fetchTeewts\(doc.data())")
//            }
            
            let tweets = documents.compactMap({try? $0.data(as: Tweet.self)})
                completion(tweets)
        }
    }
    
    func fetchTweets(uid: String, completion: @escaping([Tweet]) -> Void) {
        print("DEBUG:fetchTweets uid: \(uid)")

        Firestore.firestore().collection("tweets")
            .whereField("uid", isEqualTo: uid)
            .getDocuments { snapshot, error in
                
                guard let documents = snapshot?.documents else {
                    return
                }
                
                let tweets = documents.compactMap({try? $0.data(as: Tweet.self)})
                
                print("DEBUG:fetchTweets tweets \(tweets)")
                
                completion(tweets.sorted(by: { $0.timestamp > $1.timestamp }))
            }
    }
}

// MARK: Likes & UnLike service
extension TweetService {
    func likeTweet(tweet: Tweet,completion:@escaping(Bool) -> Void) {
        print("DEBUG: Like tweet here")
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        guard let tweetId = tweet.id else{
            return
        }
        
        let userLikesRed = Firestore.firestore().collection("users")
            .document(uid)
            .collection("user-likes")
        
        Firestore.firestore().collection("tweets").document(tweetId)
            .updateData(["likes" : tweet.likes + 1]){
                result in
                
                userLikesRed.document(tweetId).setData([:]) { error in
                    print("DEBUG: Did like tweet...and now we should update UI")
                    
                    completion(true)
                }
            }
    }
    
    func unlikeTweet(tweet:Tweet,completion:@escaping(Bool) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        guard let tweetId = tweet.id else{
            return
        }
        
        guard tweet.likes > 0 else {
            return
        }
        
        let userLikesRed = Firestore.firestore().collection("users")
            .document(uid)
            .collection("user-likes")
        
        Firestore.firestore().collection("tweets").document(tweetId)
            .updateData(["likes" : tweet.likes - 1]){
                result in
                
                userLikesRed.document(tweetId).delete() { error in
                    print("DEBUG: Did like tweet...and now we should update UI")
                    
                    completion(false)
                }
            }
    }
    
    func checkIfUserLikedTweet(tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        guard let tweetId = tweet.id else{
            return
        }
         
        Firestore.firestore().collection("users")
            .document(uid)
            .collection("user-likes")
            .document(tweetId)
            .getDocument { snapshot, erro in
                guard let snapshot = snapshot else {
                    return
                }
                completion(snapshot.exists)
            }
    }
    
    func fetchLikedTweets(uid:String,completion: @escaping ([Tweet]) -> Void){
        print("DEBUF: fetchLikedTweets....")
        
        var tweets = [Tweet]()
        
        Firestore.firestore().collection("users")
            .document(uid)
            .collection("user-likes")
            .getDocuments { snapshot, error in
                guard let document = snapshot?.documents else {
                    return
                }
                
                document.forEach { doc in
                    let tweetID = doc.documentID
                    
                    Firestore.firestore().collection("tweets")
                        .document(tweetID)
                        .getDocument { snapshot, error in
                            guard let tweet = try? snapshot?.data(as: Tweet.self) else {
                                return
                            }
                            
                            tweets.append(tweet)
                            
                            completion(tweets)
                        }
                }
            }
    }
}
