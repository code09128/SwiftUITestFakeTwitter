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
