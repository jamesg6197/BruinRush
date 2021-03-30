//
//  ProfilePage.swift
//  bruinlabs
//
//  Created by James Guo on 1/1/21.
//  Copyright © 2021 Daniel Hu. All rights reserved.
//

import SwiftUI
import Firebase
struct ProfileContent: View {
    var body: some View
    {
        ProfilePage()
    }
}
struct ProfilePage: View {
    @EnvironmentObject var currentUser: CurrentUser
    var body: some View {
        ZStack
        {
            LinearGradient(gradient: Gradient(colors: [.bruinblue, .white, .bruinyellow]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            VStack
            {
                ScrollView
                {
                    HStack
                    {
                        
                        VStack(alignment: .leading)
                        {
                            HStack{
                                Image(systemName: "person.fill")
                                Text("Name: \(currentUser.displayName)")
                            }.padding()
                            HStack
                            {
                                Image(systemName: "graduationcap.fill")
                                Text("Graduation Year: \(currentUser.year)")
                            }.padding()
                            HStack
                            {
                                Image(systemName: "lightbulb.fill")
                                Text("Major: \(currentUser.major)")
                            }.padding()
                        }
                        Spacer()
                        UrlImageView(urlString: currentUser.imageurl)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                            .padding()
                    }
                    Spacer()
                    Text("About me: \(currentUser.bio)")
                        .padding()
                    Text("My Reviews:")
                        .padding()
                    ForEach(currentUser.reviews)
                    {review in
                        VStack
                        {
                            RatingDisplay(rating: review.sRating)
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            Text("\(review.sReview)")
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        }
                        Divider()
                    }
                    Button(action :
                    {
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                            
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }
                        UserDefaults.standard.set(false, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                       
                    },label:
                    {
                        HStack
                        {
                            Spacer()
                            Text("Log Out")
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                        }.foregroundColor(.black)
                        .padding()
                        .background(Color("errorred"))
                        .cornerRadius(10)
                    }).padding()
                    
                    
                    }
                }.navigationTitle(currentUser.displayName)
                .navigationBarItems(leading: Image(systemName: "lock.fill"))
        }
    }
    
}


