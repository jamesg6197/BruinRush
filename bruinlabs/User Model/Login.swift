//
//  Login.swift
//  bruinlabs
//
//  Created by James Guo on 8/7/21.
//  Copyright © 2021 Daniel Hu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI

struct Login: View{
    @EnvironmentObject var accountCreation: AccountCreationViewModel
    @State var visible = false
    var body: some View {
        ScrollView{
            HStack{
                Button(action: {accountCreation.pageNumber = 0}, label: {
                    HStack {
                        
                        Image(systemName: "arrow.left")
                            .padding(.horizontal)
                    }.foregroundColor(Color("bruinblue"))
                    .padding(.vertical, 10)
                    .cornerRadius(10)
                    })
                    .frame(alignment: .leading)
                    .padding(.top)
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
            Text("Login")
                .font(.largeTitle)
                .foregroundColor(.black)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom)
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
                        .padding(.horizontal)
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
                        .padding(.horizontal)
                }.foregroundColor(.white)
                .padding(.vertical, 10)
                .background(Color("bruinblue"))
                .cornerRadius(10)
            })

            }.padding()
        }
        if (self.accountCreation.alert) {
                ErrorView(alert: $accountCreation.alert, error: $accountCreation.error)
        }
    }
}
