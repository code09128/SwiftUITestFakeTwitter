//
//  SideMenuView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/10.
//

import SwiftUI
import Kingfisher

struct SideMenuView: View {
    @EnvironmentObject
    var authViewModel:AuthViewModel
    
    var body: some View {
        if let user = authViewModel.currentUser {
            VStack(alignment: .leading,spacing: 32) {
                VStack(alignment: .leading) {
                    KFImage(URL(string: user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 48,height: 48)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.fullname)
                            .font(.headline)
                        
                        Text("@\(user.username)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    UserStatsView()
                        .padding(.vertical)
                }
                .padding(.leading)
                
                ForEach(SideMenuViewModel.allCases, id: \.rawValue){ ViewModelResult in
                    
                    if ViewModelResult == .profile {
                        NavigationLink {
                            //點擊連結前往的地方
                            ProfileView(user: user)
                        } label: {
                            SideMenuOptionRowView(viewModel: ViewModelResult)
                        }
                    }
                    else if ViewModelResult == .logout {
                        Button {
                            authViewModel.signOut()
                        } label: {
                            SideMenuOptionRowView(viewModel: ViewModelResult)
                        }
                    }
                    else{
                        SideMenuOptionRowView(viewModel: ViewModelResult)
                    }
                }
                
                Spacer()
            }
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
    }
}

