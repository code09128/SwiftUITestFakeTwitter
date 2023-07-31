//
//  ExploreView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/4.
//

import SwiftUI

struct ExploreView: View {
    @ObservedObject
    var viewModel = ExploreViewModel()
    
    var body: some View {
        VStack {
            SearchBarView(text: $viewModel.searchText)
                .padding()
            
            ScrollView{
                LazyVStack {
                    ForEach (viewModel.searchableUsers){ user in
                        NavigationLink {
                            ProfileView(user: user)
                        } label: {
                            UserRowView(user: user)
                        }
                    }
                }
            }
        }
        .navigationTitle("Explore")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
