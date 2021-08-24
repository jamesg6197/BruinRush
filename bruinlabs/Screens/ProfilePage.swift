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
    var body: some View {
        ProfilePage()
    }
}
struct ProfilePage: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var currentUser: CurrentUser
    @State var alert = false
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
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView {
                    HStack {
                        btnBack
                        Spacer()

                        Button(action: {
                            self.alert.toggle()
                        }){
                            Image(systemName: "lock.rotation")
                                    .padding()
                        }
                    }
                    HStack {
                        UrlImageView(urlString: currentUser.imageurl)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                            .padding()
                        Spacer()
                        VStack(alignment: .leading) {
                            HStack{
                                Text("\(currentUser.displayName)")
                                    .fontWeight(.bold)
                                    .font(.largeTitle)
                                    .padding(.trailing)
                                Spacer()
                            }
                            HStack {
                                Image(systemName: "graduationcap.fill")
                                Text("Graduation Year: \(currentUser.year)")
                            }.padding(.trailing)
                             .padding(.vertical)
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                Text("Major: \(currentUser.major)")
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
                            Text("\(currentUser.bio)")
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
                    ForEach(currentUser.reviews.sorted {
                        $0.rawTime > $1.rawTime
                    }) {review in
                        VStack {
                            HStack {
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
                            HStack {
                                RatingDisplay(rating: review.sRating)
                                    .padding(.horizontal)
                                Spacer()
                                Text(review.sTime)
                                    .padding(.horizontal)
                                    .foregroundColor(Color("bruinblue"))
                            }.padding(.top)
                            HStack {
                                Text(review.sReview)
                                .padding()
                                Spacer(minLength: 0)
                            }
                        }.background(Color.white)
                         .border(Color.gray.opacity(0.2))
                         .cornerRadius(15)
                         .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                         .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                         .padding()
                    }
                    Button(action : {
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                            
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }
                        UserDefaults.standard.set(false, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    },label: {
                        HStack {
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
            }.navigationBarHidden(true)
            if (self.alert) {
                ZStack{
                    GeometryReader{_ in
                    }
                    .background(Color.black.opacity(0.3).edgesIgnoringSafeArea(.all))
                    VStack {
                        Text("Are you sure that you want to sign out?")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                        HStack{
                            Button(action: {self.alert.toggle()
                            }){
                                Text("Cancel")
                            }
                            Button(action : {
                                let firebaseAuth = Auth.auth()
                                do {
                                    try firebaseAuth.signOut()
                                    
                                } catch let signOutError as NSError {
                                    print ("Error signing out: %@", signOutError)
                                }
                                UserDefaults.standard.set(false, forKey: "status")
                                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                               
                            },label: {
                                HStack {
                                    Spacer()
                                    Text("Log Out")
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                }.foregroundColor(.black)
                                 .padding()
                                 .background(Color("errorred"))
                                 .cornerRadius(10)
                            }).padding()
                        }.padding()
                    }.padding(.vertical, 25)
                     .frame(width: UIScreen.main.bounds.width - 70)
                     .background(Color.white)
                     .cornerRadius(15)
                }
            }
        }
    }
}


