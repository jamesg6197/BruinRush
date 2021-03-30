//
//  FeaturedViewModel.swift
//  bruinlabs
//
//  Created by James Guo on 3/24/21.
//  Copyright © 2021 Daniel Hu. All rights reserved.
//

import Foundation
import FirebaseFirestore
class FeaturedViewModel: ObservableObject
{
    @Published var features = [BaseStructure]()
    private var db = Firestore.firestore()
    func fetchData(){
        db.collection("Home Page").addSnapshotListener{( QuerySnapshot, error) in
            guard let documents = QuerySnapshot?.documents else{
                print("No documents")
                return
            }
            
            self.features = documents.map{ (QueryDocumentSnapshot) -> BaseStructure in
                let data = QueryDocumentSnapshot.data()
                let cname = data["name"] as? String ?? "blank"
                let cdesc = data["description"] as? String ?? "blank"
                let cimage = data["image"] as? String ?? "blank"
                return BaseStructure(name: cname, image: cimage, description: cdesc)
                
                
            }
            
        }
    }
}
