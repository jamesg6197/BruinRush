//
//  Job Reviews.swift
//  bruinlabs
//
//  Created by James Guo on 12/6/20.
//  Copyright © 2020 Daniel Hu. All rights reserved.
//

import SwiftUI
import Foundation

class JobReviews {
    let id = UUID()
    let name: String
    let image: String
    let children: [JobReviewType]
    init(name: String, image: String, children: [JobReviewType]) {
        self.name = name
        self.image = image
        self.children = children
    }
}
class JobReviewType: BaseType {
    
}

extension JobReviews
{
    static func getData() -> JobReviews
    {
        let locations : [JobReviewType] = [JobReviewType(name: "Los Angeles Startups", image: "la")]
        let jobreviews = JobReviews(name: "Incubator Companies", image: "incubator", children:locations)
        return jobreviews
    }
}
struct JobReviewCell: View
{
    var body: some View
    {
        NavigationLink(destination: JobReviewTypeView(jobreviews: JobReviews.getData()))
        {
            ZStack{
                //Color.white
        VStack{
            
            Image(systemName: "lightbulb")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.width * 0.15)
                
            Text("Startups")
                .bold()
                .font(.subheadline)
            
            }.padding()
            }.cornerRadius(15)
            //.shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
            //.shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
            
        
        
        }.buttonStyle(PlainButtonStyle())
    }
}
struct JobReviewTypeCell: View
{
    let jobtype: JobReviewType
    var body: some View
    {
        HStack{
            Image(jobtype.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                .cornerRadius(15)
            Text(jobtype.name)
                .bold()
                .font(.headline)
            Spacer()
        }
        .padding()
    }
    
}
struct JobReviewTypeView: View
{
    let jobreviews: JobReviews
    var body: some View
    {
        ZStack{
            Color("Background").edgesIgnoringSafeArea(.all)
        ScrollView{
            ForEach(jobreviews.children, id: \.id)
            {child in
                HStack{
                    JobReviewTypeCell(jobtype: child)

                    Spacer()
                    NavigationLink("View", destination: BaseStructureView(Basetype: child))
                        .padding()
                }
                
                .border(Color.gray.opacity(0.2))
                .cornerRadius(7)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                .padding()
           
            }
        }.navigationTitle("Locations")
        .background(Color.clear)
        }
    }
}


