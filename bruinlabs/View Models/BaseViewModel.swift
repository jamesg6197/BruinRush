//
//  Organization View Model.swift
//  bruinlabs
//
//  Created by James Guo on 12/6/20.
//  Copyright © 2020 Daniel Hu. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseFirestore
class BaseType
{
    let id = UUID()
    let name: String
    let image: String
    init(name: String, image: String) {
              self.name = name
              self.image = image
    }
}

struct BaseStructure: Identifiable
{
    
    var id = UUID().uuidString
    var name: String
    var image: String
    var description: String
    
}
class BaseViewModel: ObservableObject {
    @Published var BaseStructures = [BaseStructure]()
    
    private var db = Firestore.firestore()
    
    func fetchData(org: String){
        db.collection(org).addSnapshotListener { (QuerySnapshot, error) in
            guard let documents = QuerySnapshot?.documents else{
                print("No documents")
                return
            }
            self.BaseStructures = documents.map{ (QueryDocumentSnapshot) -> BaseStructure in
                
                let data = QueryDocumentSnapshot.data()
                let name = data["Name"] as? String ?? ""
                
                let image = data["Image"] as? String ?? ""
                
                let description = data["Description"] as? String ?? ""
                
                return BaseStructure(name: name, image: image, description: description)

            }
        }
    }
}
struct BaseStructureView: View
{
    let Basetype : BaseType
    @ObservedObject private var viewModel = BaseViewModel()
    var body: some View
    {
        ZStack{
            Color("Background").edgesIgnoringSafeArea(.all)
        ScrollView{
        ForEach(viewModel.BaseStructures)
            {base in
        
                HStack
                {
                    Image(base.image)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                            .cornerRadius(15)
                        .padding()
                    Text(base.name)
                        .bold()
                        .font(.headline)
                    Spacer()
                    NavigationLink("View", destination: ClubDescriptionView(Base: base))
                        .padding()
                }.border(Color.gray.opacity(0.2))
                .cornerRadius(7)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                .padding()
            
            }
            .navigationBarTitle(self.Basetype.name)
            .onAppear()
            {
                self.viewModel.fetchData(org: self.Basetype.name)
            
            }
        }.background(Color.clear)
        
        }
    }
}

