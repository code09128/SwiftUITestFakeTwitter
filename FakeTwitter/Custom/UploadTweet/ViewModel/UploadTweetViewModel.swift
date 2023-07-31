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
