//
//  SearchBarView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding
    var text: String
    
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(8)
                .padding(.horizontal,24)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay (
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0,maxWidth: .infinity,alignment: .leading)
                            .padding(.leading,8)
                    }
                )
        }
        .padding(.horizontal,4)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(text: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
