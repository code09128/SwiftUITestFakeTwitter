//
//  UserStatsView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/10.
//

import SwiftUI

struct UserStatsView: View {
    var body: some View {
        HStack(spacing: 24) {
            HStack(spacing: 4) {
                Text("920").bold()
                    .font(.subheadline)
                
                Text("Following")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 4) {
                Text("6.9M").bold()
                    .font(.subheadline)
                
                Text("Followers")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        } 
    }
}

struct UserStatsView_Previews: PreviewProvider {
    static var previews: some View {
        UserStatsView()
    }
}
