//
//  ReviewsViewModel.swift
//  bruinlabs
//
//  Created by Daniel Hu on 7/26/20.
//  Copyright © 2020 Daniel Hu. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ReviewsViewModel: ObservableObject {
    @Published var users = [String]()
    @Published var reviews = [completedReviews]()
    @Published var average: Double = 0
    @Published var total : Int = 0
    private var db = Firestore.firestore()
    func fetchData(org: String){
        db.collection("reviews: \(org)").addSnapshotListener{(QuerySnapshot, error) in
            guard let documents = QuerySnapshot?.documents else{
                print("No documents")
                return
            }
           
            self.reviews = documents.map{ (QueryDocumentSnapshot) -> completedReviews in
                let data = QueryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let review = data["review"] as? String ?? ""
                let rating = data["rating"] as? Int ?? 0
                let uid = data["uid"] as? String ?? ""
                self.users.append(uid)
                let year = data["year"] as? String ?? ""
                let time = data["time"] as? String ?? ""
                let club = data["club"] as? String ?? ""
                let timestamp = data["rawtime"] as? Timestamp ?? Timestamp()
                let rawtime = timestamp.dateValue()
                return completedReviews(suid: uid, sName: name, sReview: review, sRating: rating, sYear: year, sTime: time, sClub: club, rawTime: rawtime)
                //return completedReviews(sReview: review)
            }
            
        }
        self.reviews = reviews.sorted{
            $0.rawTime < $1.rawTime
        }
    }
}
