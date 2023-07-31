//
//  UserRowView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/10.
//

import SwiftUI
import Kingfisher

struct UserRowView: View {
    let user:User
    
    var body: some View {
        HStack(spacing: 12){
            KFImage(URL(string: user.profileImageUrl))
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 56, height: 56)
                
            VStack(alignment: .leading, spacing: 5){
                Text(user.fullname)
                    .font(.subheadline).bold()
                    .foregroundColor(.black)
                
                Text(user.username)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

//struct UserRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserRowView(user: user)
//    }
//}
