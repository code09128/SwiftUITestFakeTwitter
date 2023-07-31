//
//  ContentView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/6/17.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @State
    private var showMenu = false
    
    @EnvironmentObject
    var viewmodel:AuthViewModel
    
    var body: some View {
        Group {
            // no user logged in
            if viewmodel.userSession == nil {
                LoginView()
            }
            else{
                // have a logged in user
                mainInterfaceView
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //create navigationBar
        NavigationView {
            ContentView()
        }
    }
}

extension ContentView {
    var mainInterfaceView: some View {
        ZStack(alignment: .topLeading) {
            MainTabView()
                .navigationBarHidden(showMenu)
            
            if showMenu {
                ZStack {
                    Color(.black)
                        .opacity(showMenu ? 0.25 : 0.0) //opacity 0.25
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showMenu = false
                    }
                }
                .ignoresSafeArea()
            }
            
            //side menu set
            SideMenuView()
                .frame(width: 300)
                .offset(x: showMenu ? 0 : -300, y: 0)
                .background(showMenu ? Color.white : Color.clear)
        }
        .navigationBarTitle("Home") //navigation style set
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if let user = viewmodel.currentUser {
                    Button {
                        withAnimation(.easeInOut) {
                            showMenu.toggle()
                        }
                    } label: {
                        // Kingfisher載入圖片
                        KFImage(URL(string: user.profileImageUrl))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 32, height: 32)
                    }
                }
            }
        }
        .onAppear{
            showMenu = false
        }
    }
}
