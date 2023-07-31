//
//  Tweet.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/25.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Tweet: Identifiable, Decodable {
    @DocumentID
    var id: String?
    let caption: String
    let timestamp: TimeInterval
    let uid: String
    var likes: Int
    var user: User?
    var didlike:Bool? = false
}
