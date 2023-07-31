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
