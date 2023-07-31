//
//  ProfileView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/7.
//  個人頁面

import SwiftUI
import Kingfisher

struct ProfileView: View {
    @State
    private var selectedFilter: TweetFilterViewModel = .tweets
    
    @ObservedObject
    var viewModel: ProfileViewModel
    
    @Environment(\.presentationMode) //實現按鈕跳轉/關閉動作
    var mode
    
    @Namespace
    var animation
        
    init(user:User) {
        self.viewModel = ProfileViewModel(user: user)
    }
    
    var body: some View {
        VStack(alignment: .leading){
            headerView
            actionButton
            userInfoDetail
            tweetFilterBar
            tweetViewData
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(user: User(username: "Batman", fullname: "Bruce Wayne", profileImageUrl: "", email: "batmain@gmail.com"))
//    }
//}

extension ProfileView {
    // MARK: Title & Profile photo
    var headerView: some View {
        ZStack(alignment: .bottomLeading){
            Color(.systemBlue)
                .ignoresSafeArea()
            
            VStack {
                // left button
                Button {
                    mode.wrappedValue.dismiss()
                } label: {
                   Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 20, height: 16)
                        .foregroundColor(.white)
                        .offset(x:20, y:10)
                }
                
                // profile photo
                KFImage(URL(string: viewModel.user.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 72,height: 72)
                .offset(x:16, y:24)
            }
        }
        .frame(height: 96)
    }
    
    // MARK: Bell & Edit Profile Button
    var actionButton: some View {
        HStack(spacing: 12) {
            Spacer()
            
            // bell
            Image(systemName: "bell.badge")
                .font(.title3)
                .padding(6)
                .overlay(Circle().stroke(Color.gray,lineWidth: 0.75))
            
            //Edit profile
            Button {
                // to do
            } label: {
                Text(viewModel.actionButtonTitle)
                    .font(.subheadline).bold()
                    .frame(width: 128, height: 32)
                    .foregroundColor(.black)
                    .overlay(RoundedRectangle(cornerRadius:20).stroke(Color.gray, lineWidth: 0.75))
            }

        }
        .padding(.trailing)
    }
    
    // MARK: UserInfoDetail
    var userInfoDetail: some View {
        VStack(alignment: .leading){
            HStack {
                Text(viewModel.user.fullname)
                    .font(.title2).bold()
                
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor( Color(.systemBlue))
            }
            
            Text("@\(viewModel.user.username)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Im happy, who are you")
                .font(.subheadline)
                .padding(.vertical)
            
            HStack(spacing: 32) {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                    Text("Goham, NY")
                }
                
                HStack {
                    Image(systemName: "link")
                    Text("www.thejoker.com")
                }
            }
            .font(.caption)
            .foregroundColor(.gray)
            
            UserStatsView()
                .padding(.vertical)
            
        }
        .padding(.horizontal)
    }
    
    //MARK: TweetFilterTabBar
    var tweetFilterBar: some View {
        HStack {
            ForEach(TweetFilterViewModel.allCases,id: \.rawValue) { item in
                VStack {
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(selectedFilter == item ? .semibold : .regular)
                        .foregroundColor(selectedFilter == item ? .black : .gray)
                     
                    if selectedFilter == item {
                        Capsule() //膠囊樣式形狀
                            .foregroundColor(Color(.systemBlue))
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "filter", in: animation)//滑動形式動畫
                    } else {
                        Capsule() //膠囊樣式形狀
                            .foregroundColor(Color(.clear ))
                            .frame(height: 3)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedFilter = item
                    }
                }
            }
        }
        .overlay(Divider().offset(x:0, y:16))
    }
    
    //MARK: TweetViewData
    var tweetViewData: some View {
        ScrollView {
            LazyVStack {
                ForEach (viewModel.tweets){ result in
                    TweetRowView(tweet: result)
                        .padding()
                }
            }
        }
    }
}
