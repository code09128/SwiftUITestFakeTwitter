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
