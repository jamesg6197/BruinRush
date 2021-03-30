//
//  Register.swift
//  bruinlabs
//
//  Created by James Guo on 12/28/20.
//

import SwiftUI

struct Register: View {
    @EnvironmentObject var accountCreation: AccountCreationViewModel
    @State var pvisible = false
    @State var rvisible = false
    var body: some View {
    ScrollView{
        VStack{
            HStack{
            Text("Create Account")
                .font(.title)
                .foregroundColor(.black)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment:.leading)
                .padding(.top, 15)
                Button(action: {accountCreation.pageNumber = 0
                }, label: {
                    HStack
                    {
                        Spacer(minLength: 0)
                        Text("Back to Login")
                        Spacer(minLength: 0)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(Color("bruinblue"))
                    .cornerRadius(8)
                    
                    
                    
                })
            }
            HStack
            {
                Image(systemName: "envelope.fill")
                    .foregroundColor(Color("bruinblue"))
                TextField("Email", text: $accountCreation.email)
            }
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
            HStack(spacing: 15){
                Image(systemName: "person.fill")
                    .foregroundColor(Color("bruinblue"))
                TextField("Username", text: $accountCreation.displayName)
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
            .padding(.vertical)
            HStack
            {
                HStack(spacing: 15)
                {
                    Image(systemName: "lock").foregroundColor(Color("bruinblue"))
                    
                    
                    if self.pvisible
                    {
                        TextField("Password", text: $accountCreation.password)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    }
                    else
                    {
                        SecureField("Password", text: $accountCreation.password)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    }
                    Button(action : {self.pvisible.toggle()})
                    {
                        Image(systemName: self.pvisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(Color.black.opacity(0.3))
                    }
                }.padding(.vertical, 12)
                .padding(.horizontal)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                HStack(spacing: 15)
                {
                    
                    Image(systemName: "lock.fill").foregroundColor(Color("bruinblue"))
                    
                    
                    if self.rvisible
                    {
                        TextField("Retype Password", text: $accountCreation.retype)
                            .autocapitalization(.none)
                    }
                    else
                    {
                        SecureField("Retype Password", text: $accountCreation.retype)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    }
                    Button(action : {self.rvisible.toggle()})
                    {
                        Image(systemName: self.rvisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(Color.black.opacity(0.3))
                    }
                }.padding(.vertical, 12)
                .padding(.horizontal)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
            }
            HStack
            {
                HStack(spacing: 15)
                {
                    Button(action:{}, label: {
                    Image(systemName: "graduationcap.fill").foregroundColor(Color("bruinblue"))
                    
                    })
                    TextField("Graduation Year", text: $accountCreation.year)
                }.padding(.vertical, 12)
                .padding(.horizontal)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                HStack(spacing: 15)
                {
                    Button(action:{}, label: {
                    Image(systemName: "lightbulb.fill").foregroundColor(Color("bruinblue"))
                    
                    })
                    TextField("Major", text: $accountCreation.major)
                }.padding(.vertical, 12)
                .padding(.horizontal)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
            }
            ZStack
            {
                if accountCreation.bio.isEmpty
                {
                    Text("Write something cool here...")
                        .foregroundColor(Color.black.opacity(0.5))
                        .padding()
                }
                TextEditor(text: $accountCreation.bio)
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                    .padding(.vertical)
                    .frame(height: UIScreen.main.bounds.height * 0.15)
            }
            Button(action: {accountCreation.checkReg()
            }, label: {
                HStack
                {
                    Spacer(minLength: 0)
                    Text("Create Account")
                    Spacer(minLength: 0)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(Color("bruinblue"))
                .cornerRadius(8)
                
                
                
            })
            .disabled((accountCreation.displayName != "" && accountCreation.email != "") ? false: true)
            .opacity((accountCreation.displayName != "" && accountCreation.email != "") ? 1 : 0.6)
            
        }
        .padding(.horizontal)
        
        }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}


