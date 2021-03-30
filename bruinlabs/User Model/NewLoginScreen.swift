//
//  NewLoginScreen.swift
//  bruinlabs
//
//  Created by James Guo on 12/28/20.
//  Copyright © 2020 Daniel Hu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI
struct CustomCorner: Shape
{
    var corners: UIRectCorner
    func path( in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 30, height: 30))
        
        return Path(path.cgPath)
    }
}
struct LoadingScreen: View
{
    var body: some View
    {
        ProgressView()
            .padding()
            .background(Color.clear)
            .foregroundColor(Color.black)
            .cornerRadius(10)
    }
}
struct MainView: View
{
    @EnvironmentObject var accountCreation : AccountCreationViewModel
    init()
    {
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View
    {
        ZStack{
            VStack{
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: UIScreen.main.bounds.height/3.5)
                .padding(.top)
            Spacer(minLength: 0)
            ZStack {
                if accountCreation.pageNumber == 0
                {
                    Login()
                        .transition(.move(edge:.trailing))
                }
                else if accountCreation.pageNumber == 1
                {
                    Register()
                        .transition(.move(edge: .trailing))
                }
                else if accountCreation.pageNumber == 2
                {
                    addProfilePicture()
                        .transition(.move(edge:.trailing))
                }

            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white).clipShape(CustomCorner(corners:[.topLeft, .topRight])).edgesIgnoringSafeArea(.all)
        }
        .background(LinearGradient(gradient: Gradient(colors: [.bruinblue, .white, .bruinyellow]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea(.all, edges: .all))
            
        
        if self.accountCreation.alert
            {
            
                ErrorView(alert: $accountCreation.alert, error: $accountCreation.error)
            }
        }
        
    }
}
struct Login: View{
    @EnvironmentObject var accountCreation: AccountCreationViewModel
    @State var visible = false
    var body: some View{
    ScrollView
    {
        VStack
        {
            Text("Login")
                .font(.largeTitle)
                .foregroundColor(.black)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 25)
                .padding()
            VStack(spacing: 15)
            {
                TextField("Email", text: $accountCreation.email)
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                    
                HStack (spacing: UIScreen.main.bounds.height * 0.015)
                {
        
                    VStack
                    {
                        if self.visible
                        {
                            TextField("Password", text: self.$accountCreation.password)
                                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                .cornerRadius(10)
                        }
                        else
                        {
                            SecureField("Password", text: self.$accountCreation.password)
                                .autocapitalization(.none)
                                .cornerRadius(10)
                                
                        }
                    }
                    Button(action : {self.visible.toggle()})
                    {
                        Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(Color(.quaternarySystemFill))
                    }
                

            }.padding(.vertical, 12)
                .padding(.horizontal)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
            Button(action: {accountCreation.login()}, label: {
                HStack
                {
                    Spacer()
                    Text("Login")
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .background(Color("bruinblue"))
                .cornerRadius(10)
            })
            .padding(.top)
            .disabled((accountCreation.email != "" && accountCreation.password != "") ? false: true)
            .opacity((accountCreation.email != "" && accountCreation.password != "") ? 1: 0.6)
            Button(action: {accountCreation.reset()}, label: {
                HStack
                {
                    Spacer()
                    Text("Forgot Password?")
                    Spacer()
                            
                    Image(systemName: "arrow.right")
                }.foregroundColor(.white)
                .padding(.vertical, 10)
                .background(Color("bruinblue"))
                .cornerRadius(10)
            })
            Button(action: {accountCreation.pageNumber = 1}, label: {
                    HStack
                    {
                        Spacer()
                        Text("Create Account")
                        Spacer()
                            
                        Image(systemName: "arrow.right")
                    }.foregroundColor(.white)
                    .padding(.vertical, 10)
                    .background(Color("bruinblue"))
                    .cornerRadius(10)
                })
                .padding(.top)
            Spacer(minLength: 0)
        }.padding(.horizontal)
        }
    }
    }
}
