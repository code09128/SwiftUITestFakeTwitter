//
//  ExploreViewModel.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/21.
//

import Foundation

class ExploreViewModel: ObservableObject {
    @Published
    var users = [User]()
    @Published
    var searchText = ""
    
    var searchableUsers: [User] {
        if searchText.isEmpty {
            return users
        }
        else{
            let lowercaseQuery = searchText.lowercased()
            
            return users.filter({
                $0.username.contains(lowercaseQuery) ||
                $0.fullname.lowercased().contains(lowercaseQuery)
            })
        }
    }
    
    let service = UserService()
    
    init() {
        fetchUsers()
    }
    
    func fetchUsers(){
        service.fetchUsers { users in
            self.users = users
            
            print("DEBUG: users\(users)")
        }
    }
}
