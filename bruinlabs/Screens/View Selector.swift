//
//  ViewSelector.swift
//  bruinlabs
//
//  Created by James Guo on 11/29/20.
//  Copyright © 2020 Daniel Hu. All rights reserved.
//
import SwiftUI
import Foundation

struct BottomView: View {
    
    @EnvironmentObject var currentUser : CurrentUser
    var body: some View {
        HStack{
             Spacer()
             
            NavigationLink (destination: SearchScreen().onAppear() {
                currentUser.listen()
            }){
                VStack {
                    Image(systemName: "house")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.height * 0.03, height: UIScreen.main.bounds.height * 0.03)
                    Text("Discover")
                }
            }.isDetailLink(false)
             .padding()
             Spacer()
            NavigationLink (destination: ProfilePage()){
                VStack {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.height * 0.03 , height: UIScreen.main.bounds.height * 0.03)
                    Text("Profile")
                }
            }.isDetailLink(false)
            .padding()
            Spacer()
            NavigationLink (destination: InfoPage()) {
                VStack {
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.height * 0.03, height: UIScreen.main.bounds.height * 0.03)
                    Text("Info")
                }
            }.isDetailLink(false)
            .padding()
            
            Spacer()
        }.frame(height: UIScreen.main.bounds.height * 0.035)
        .background(Color.clear)
    }
}


