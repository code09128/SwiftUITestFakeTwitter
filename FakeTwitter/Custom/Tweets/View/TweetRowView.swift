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
