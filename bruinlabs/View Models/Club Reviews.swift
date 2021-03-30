//
//  Club Reviews.swift
//  bruinlabs
//
//  Created by James Guo on 12/6/20.
//  Copyright © 2020 Daniel Hu. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
//*****************//
//Completed Reviews//
//*****************//
extension Date {
  func asString(style: DateFormatter.Style) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = style
    return dateFormatter.string(from: self)
  }
}
struct completedReviews: Identifiable{
    var id = UUID()
    var suid: String
    var sName: String
    var sReview: String
    var sRating: Int
    var sYear: String
    var sTime: String
    var sClub: String
}
struct ClubItemRow: View{
    let Base: BaseStructure
    
    var body: some View{
        HStack {
            Image(Base.image)
                .resizable()
                .clipShape(Circle())
                .frame(width: 70, height: 70)
                .clipped()
            VStack(alignment: .leading){
                Text(Base.name).font(.headline)
            }.padding(.leading, 8)
        }.padding(.init(top: 12, leading: 0, bottom: 12, trailing: 0))
    }
}

struct ClubCircleImage: View {
    let Base: BaseStructure
    
    var body: some View {
        Image(Base.image)
            .resizable()
            .frame(width: 225.0, height: 225.0)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
    }
}
struct ClubDescriptionView: View {
    @EnvironmentObject var currentUser : CurrentUser
    let Base: BaseStructure
    @State var sum: Double = 0
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.bruinblue, .white, .bruinyellow]), startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack {
                ScrollView{
                    
                    ClubCircleImage(Base: Base)
                        .padding(.top, 200)
                        .padding(-UIScreen.main.bounds.height * 0.10)
            
                    VStack(alignment: .leading) {
                        
                        Text(Base.name)
                            .font(.title)
                            .padding(.top, 100)
                            .padding()
                        Text(Base.description)
                            .font(.body)
                            .padding()
                            
                    }
                    
                }
                NavigationLink(destination: ClubReviewsView(Base: Base)
                                ){
                        Text("See Reviews and Metrics")
                            .offset(y: -10)
                            .padding()
                    }
            }
            
        }.edgesIgnoringSafeArea(.all)
        
    }
}
struct ClubReviewsView: View{
    @State var alert = false
    @State var error = ""
    @State var sum: Double = 0
    @State var rating = 0
    @State private var review = ""
    @State var total = 0
    @State var club = ""
    @EnvironmentObject var currentUser : CurrentUser
    @State private var name = ""
    @State private var uid = ""
    @State private var year = ""
    @ObservedObject private var viewReviews = ReviewsViewModel()
    
    let Base: BaseStructure
    let backgroundColor = Color.init(UIColor.systemGray4)
    
    var body: some View {
        ZStack{
            VStack
            {
                
                List 
                {
                    Section(header: Text("Metrics").font(.title).fontWeight(.bold).foregroundColor(.black))
                    {
                        VStack
                        {
                            Text("Overall Rating: \(sum, specifier: "%.1f")")
                            
                        }
                    }.listRowBackground(Color.clear)
                    Section (header: Text("Reviews: \(self.total)").font(.title).fontWeight(.bold).foregroundColor(.black))
                    {
                        ForEach(viewReviews.reviews)
                            { userReviews in
                    
                        
                            VStack(alignment: .leading)
                            {
                                NavigationLink(destination: ProfileView(userid: userReviews.suid))
                                {
                                    HStack{
                                    Text(userReviews.sName)
                                        .padding()
                                        .font(.headline)
                                    Text("Grad Year: \(userReviews.sYear)")
                                        .padding()
                                        .font(.headline)
                                    }
                                
                                }
                                    RatingDisplay(rating: userReviews.sRating)
                                    Text(userReviews.sReview)
                                    Text(userReviews.sTime)
                                        
                                
                            
                            }
                        
                            
                        }
                            .onAppear()
                            {
                                self.sum = 0
                                for review in self.viewReviews.reviews {
                                    self.sum += Double(review.sRating)
                                }
                                self.sum /= Double(self.viewReviews.reviews.count)
                                self.total = self.viewReviews.reviews.count
                            }
                    }
                    .listRowBackground(Color.clear)
                }.listStyle(GroupedListStyle())
                .onAppear()
                {
                    self.name = currentUser.displayName
                    self.uid = currentUser.uid
                    self.year = currentUser.year
                    self.club = self.Base.name
                    self.viewReviews.fetchData(org: self.Base.name)
                                    }
                .navigationBarTitle(Text("Reviews and Metrics"), displayMode: .inline)
                .background(LinearGradient(gradient: Gradient(colors: [.bruinblue, .white, .bruinyellow]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all))

            VStack {
                Section {
                    RatingView(rating: $rating)
                    TextField("Write a review!", text: $review)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Button(action: {

                    let time = Date().asString(style: .medium)
                    let reviewList = [
                        "review":self.review,
                        "rating":self.rating,
                        "name" : self.name,
                        "uid" : self.uid,
                        "year": self.year,
                        "time": time,
                        "club": self.club
                        
                    ] as [String : Any]
                    let id = UUID().uuidString
                    let docRef = Firestore.firestore().document("reviews: \(self.Base.name)/\(id)")
                    let allRef = Firestore.firestore().document("All Reviews/\(id)")
                    let userRef = Firestore.firestore().collection("Users").document("\(currentUser.uid)")
                    if rating != 0 {
                        print("Setting data...")
                        docRef.setData(reviewList){ (error) in
                            if let error = error {
                                print("ERROR = \(error)")
                            } else {
                                print("Data uploaded successfully!")
                                self.review = ""
                                self.rating = 0
                            }
                    }
                        userRef.updateData(["reviews": FieldValue.arrayUnion([id])])

                        allRef.setData(reviewList){ (error) in
                            if let error = error {
                                print("ERROR = \(error)")
                            } else {
                                print("Data uploaded successfully!")
                                self.review = ""
                                self.rating = 0
                            }
                }
                    }
                    else
                    {
                        self.error = "Please leave a Rating"
                        self.alert.toggle()
                    }
                    
                    
                })
                {
                    Text("Submit Review")
                    .offset( y: UIScreen.main.bounds.height * -0.01)
                }
                
            }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
            
            }
            if self.alert
            {
                ErrorView(alert:self.$alert, error: self.$error)

            }
        }
        
    }
}

struct RatingView: View {
    @Binding var rating: Int
    var maxRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        
       HStack
       {
        
            ForEach(1..<maxRating + 1)
            {number in
                self.image(for: number)
                    .foregroundColor(number > self.rating ? self.offColor: self.onColor)
                    .onTapGesture
                    {
                        self.rating = number
                    }
            }
       }
    }
    func image(for number: Int) -> Image
    {
        if number > rating {
            return offImage ?? onImage
        }
        else
        {
            return onImage
        }
    }
}

struct RatingDisplay: View {
    var rating: Int
    var maxRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        
       HStack
       {
        
            ForEach(1..<maxRating + 1)
            {number in
                self.image(for: number)
                    .foregroundColor(number > self.rating ? self.offColor: self.onColor)
                    
            }
       }
    }
    func image(for number: Int) -> Image
    {
        if number > rating {
            return offImage ?? onImage
        }
        else
        {
            return onImage
        }
    }
}
