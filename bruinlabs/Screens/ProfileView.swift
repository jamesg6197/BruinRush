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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
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
    @State var trawtime = Timestamp()
    @State var tdate = Date()
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
                        self.trawtime = document1.get("rawtime") as? Timestamp ?? Timestamp()
                        self.tdate = trawtime.dateValue()
                        
                        
                            self.reviews.append(completedReviews(suid: self.tuid, sName : self.tname,  sReview: self.treview, sRating: self.trating, sYear: "", sTime: self.ttime, sClub: self.tclub, rawTime: self.tdate))
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
    var btnBack : some View { Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "arrow.left") // set image here
                    .aspectRatio(contentMode: .fit)
                        .padding(.leading)
                    
                    Text("Back")
                }
            }
        }
    var body: some View {
        ZStack
        {
            Color("Background").edgesIgnoringSafeArea(.all)
            VStack
            {
                ScrollView
                {
                    HStack
                    {
                        btnBack
                        Spacer()
                        Spacer()
                    }
                    HStack
                    {
                        UrlImageView(urlString: self.imageurl)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                            .padding()
                        Spacer()
                        VStack(alignment: .leading)
                        {
                            HStack{
                                Text("\(self.name)")
                                    .fontWeight(.bold)
                                    .font(.largeTitle)
                                    .padding(.trailing)
                                Spacer()
                            }
                            HStack
                            {
                                Image(systemName: "graduationcap.fill")
                                Text("Graduation Year: \(self.year)")
                            }.padding(.trailing)
                            .padding(.vertical)
                            HStack
                            {
                                Image(systemName: "lightbulb.fill")
                                Text("Major: \(self.major)")
                            }.padding(.trailing)
                            .padding(.vertical)
                        }
                        
                        
                    }
                    Spacer()
                    HStack{
                        VStack{
                            HStack{
                                Text("Bio")
                                    .fontWeight(.bold)
                                    .font(.title)
                                    .padding(.horizontal)
                                Spacer()
                                Spacer()
                            }
                            Text("\(self.bio)")
                                .padding()
                        }
                        Spacer()
                    }
                    HStack{
                        Text("Reviews")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding(.horizontal)
                        Spacer()
                        Spacer()
                    }
                    ForEach(self.reviews.sorted
                    {
                        $0.rawTime > $1.rawTime
                    })
                    {review in
                        VStack{
                        HStack
                        {
                            Text(review.sName)
                                .padding(.horizontal)
                                .padding(.top)
                                .font(.headline)
                                .foregroundColor(Color("bruinblue"))
                            Spacer()
                            Spacer()
                            Text("Grad Year: \(review.sYear)")
                                .padding(.horizontal)
                                .padding(.top)
                                .font(.headline)
                                .foregroundColor(Color("bruinblue"))
                            
                        }.buttonStyle(PlainButtonStyle())
                
                        HStack{
                            RatingDisplay(rating: review.sRating)
                                .padding(.horizontal)
                            Spacer()
                            Text(review.sTime)
                                .padding(.horizontal)
                                .foregroundColor(Color("bruinblue"))
                        }.padding(.top)
                            HStack ()
                            {
                                Text(review.sReview)
                                .padding()
                                Spacer(minLength: 0)
                            }
                        }
                        .background(Color.white)
                        .border(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                        .padding()
                        
                    }
                    
                    
                    
                    }
            }.navigationBarHidden(true)
            
            
        }.onAppear()
        {
            getUser(uid: self.uid)
        }
        
    }
    
}


