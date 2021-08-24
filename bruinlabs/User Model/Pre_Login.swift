//
//  NewLoginScreen.swift
//  bruinlabs
//
//  Created by James Guo on 12/28/20.
//

import Foundation
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
    init(){
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View
    {
        if (accountCreation.pageNumber == 0) {
            VStack{
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: UIScreen.main.bounds.height/3.5)
                    .padding(.top)
                Spacer()
                Text("")
                Button(action: {accountCreation.pageNumber = 1
                }, label: {
                    HStack
                    {
                        Spacer(minLength: 0)
                        Text("Login")
                        Spacer(minLength: 0)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(Color("bruinblue"))
                    .cornerRadius(8)
                }).padding(.top)
                  .padding(.horizontal)
                Button(action: {accountCreation.pageNumber = 2}, label: {
                    HStack {
                            Spacer(minLength: 0)
                            Text("Create Account")
                            Spacer(minLength: 0)
                            Image(systemName: "arrow.right")
                    }.foregroundColor(.white)
                     .padding(.vertical, 12)
                     .padding(.horizontal)
                     .background(Color("bruinblue"))
                     .cornerRadius(8)
                }).padding()
            }
        }
        if (accountCreation.pageNumber == 1) {
            withAnimation{
                Login().transition(.slide)
            }
        }
        else if (accountCreation.pageNumber == 2) {
            withAnimation{
                Register().transition(.slide)
            }
        }
        else if (accountCreation.pageNumber == 3) {
            withAnimation{
                addProfilePicture().transition(.slide)
            }
        }
    }
}
