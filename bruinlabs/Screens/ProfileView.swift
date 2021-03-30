//
//  ProfileView.swift
//  bruinlabs
//
//  Created by James Guo on 1/5/21.
//  Copyright © 2021 Daniel Hu. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct ProfileView: View {
    let uid: String
    init(userid: String)
    {
        self.uid = userid
    }
    @State var name = ""
    @State var bio = ""
    @State var year = ""
    @State var major = ""
    @State var imageurls: Array<String>?
    @State var imageurl: String?
    @State var reviewsreferences = [String]()
    @State var reviews = [completedReviews]()
    @State var tname = ""
    @State var treview = ""
    @State var trating = 0
    @State var tuid = ""
    @State var ttime = ""
    @State var tclub = ""
    func getUser (uid: String){
        let db = Firestore.firestore().collection("Users").document(uid)
        db.getDocument{ (document, error) in
          if let document = document {
            self.name = document.get("displayName") as? String ?? ""
            self.bio = document.get("bio") as? String ?? ""
            self.year = document.get("year") as? String ?? ""
            self.major = document.get("major") as? String ?? ""
            self.imageurls = document.get("imageurls") as? Array ?? nil
            self.imageurl = self.imageurls?[0]
            self.reviewsreferences = document.get("reviews") as? Array ?? []
            
            for review in self.reviewsreferences
            {
                let revRef = Firestore.firestore().document("All Reviews/\(review)")
                revRef.getDocument { (document1, error1) in
                    if let document1 = document1 {
                        self.tname = document1.get("name") as? String ?? "failed"
                        self.treview = document1.get("review") as? String ?? "failed"
                        self.trating = document1.get("rating") as? Int ?? 0
                        self.tuid = document1.get("uid") as? String ?? "failed"
                        self.ttime = document1.get("time") as? String ?? "failed"
                        self.tclub = document1.get("club") as? String ?? "failed"
                        self.reviews.append(completedReviews(suid: self.tuid, sName : self.tname,  sReview: self.treview, sRating: self.trating, sYear: "", sTime: self.ttime, sClub: self.tclub))
                    }
                    else{
                        print("Document does not exist in cache")
                    }
                }
            }
          
          } else {
            print("Document does not exist in cache")
          }
        
    }
}
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
                        
                        VStack (alignment: .leading)
                        {
                            HStack{
                                Image(systemName: "person.fill")
                                Text("Name: \(self.name)")
                            }.padding()
                            HStack
                            {
                                Image(systemName: "graduationcap.fill")
                                Text("Graduation Year: \(self.year)")
                            }.padding()
                            HStack
                            {
                                Image(systemName: "lightbulb.fill")
                                Text("Major: \(self.major)")
                            }.padding()
                        }
                        Spacer()
                        UrlImageView(urlString: self.imageurl)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                            .padding()
                    }
                    Spacer()
                    Text("About: \(self.bio)")
                        .padding()
                    Text("My Reviews:")
                        .padding()
                    ForEach(self.reviews)
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
                        
                    
                }
                .navigationBarTitle("\(self.name)")

                
                
            }
        }
        .onAppear()
        {
            getUser(uid:self.uid)
        }
    }
}


