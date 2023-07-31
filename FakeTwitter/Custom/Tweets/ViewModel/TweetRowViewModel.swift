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
