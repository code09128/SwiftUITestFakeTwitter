//
//  FakeTwitterApp.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/6/17.
//

import SwiftUI
import Firebase

//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//
//        return true
//    }
//}

@main
struct FakeTwitterApp: App {
    
    @StateObject
    var viewmodel = AuthViewModel()
    
    // firebase 設定檔載入
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(viewmodel)
        }
    }
}
