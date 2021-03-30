//
//  Organizations.swift
//  bruinlabs
//
//  Created by James Guo on 12/6/20.
//  Copyright © 2020 Daniel Hu. All rights reserved.
//

import Foundation
import Firebase
import SwiftUI
class Organization
{
    var id = UUID()
    var name : String
    var image: String
    var children: [OrganizationType]
    init(name: String, image: String, children: [OrganizationType]) {
              self.name = name
              self.image = image
              self.children = children
         }
}
class OrganizationType
{
    let id = UUID()
    let name : String
    let image: String
    let children: [OrganizationTypeDetailed]
    init(name: String, image: String, children: [OrganizationTypeDetailed]) {
              self.name = name
              self.image = image
              self.children = children
    }
}
class OrganizationTypeDetailed: BaseType
{
}

extension Organization
{
    static func getallorgData() -> Organization {
        let businesstypes = [OrganizationTypeDetailed(name: "Consulting Clubs", image: "consulting"), OrganizationTypeDetailed(name: "Investing Clubs", image: "investment"), OrganizationTypeDetailed(name: "Entrepreneurship Clubs", image: "entrepreneurship"), OrganizationTypeDetailed(name: "General Business Clubs", image: "generalbusiness")]
        let technologytypes = [OrganizationTypeDetailed(name:"Computer Science Clubs", image: "computerscience"), OrganizationTypeDetailed(name:"Mechanical Engineering Clubs", image: "mechanicalengineering"), OrganizationTypeDetailed(name: "Chemistry Clubs", image: "chemistry"), OrganizationTypeDetailed(name: "Biomedical Clubs", image: "biomedical"), OrganizationTypeDetailed(name: "Aerospace Clubs", image: "aerospaceengineering"), OrganizationTypeDetailed(name: "Environmental Engineering Clubs", image: "environmental"), OrganizationTypeDetailed(name: "Civil Engineer Clubs", image: "civil"), OrganizationTypeDetailed(name: "General Engineering Clubs", image: "generalengineering")]
        let clubsportstypes = [OrganizationTypeDetailed(name: "Sports", image:"sports"), OrganizationTypeDetailed(name:"Co-Ed Sports", image: "coedsports"), OrganizationTypeDetailed(name:"ESports", image: "esports"), OrganizationTypeDetailed(name: "Martial Arts Classes & Programs", image: "martialarts")]
        let culturaltypes = [OrganizationTypeDetailed(name: "Asian Culutural Clubs", image: "asiancultural"), OrganizationTypeDetailed(name: "African Cultural Clubs", image: "africancultural"), OrganizationTypeDetailed(name: "European Cultural Clubs", image: "europeancultural"), OrganizationTypeDetailed(name: "Latin American Cultural Clubs", image: "latinamericancultural"), OrganizationTypeDetailed(name: "Middle-Eastern Cultural Clubs", image: "middleeasterncultural"), OrganizationTypeDetailed(name: "Native American Cultural Clubs", image: "nativeamericancultural"), OrganizationTypeDetailed(name: "General Cultural Clubs", image: "generalcultural")]
        let artstypes = [OrganizationTypeDetailed(name:"Theater Groups", image: "theater"), OrganizationTypeDetailed(name: "Music Groups", image: "music"), OrganizationTypeDetailed(name: "Dance Groups", image: "dance")]
        let misctypes = [OrganizationTypeDetailed(name: "Out-of-State, International, Transfer Student Groups", image: "oit")]
        let clubtypes  = [OrganizationType(name:"Business", image: "business", children: businesstypes), OrganizationType(name:"Technology", image: "technology", children: technologytypes), OrganizationType(name: "Cultural", image: "cultural", children: culturaltypes), OrganizationType(name: "Club Sports", image: "clubsports", children: clubsportstypes), OrganizationType(name: "Arts", image: "arts", children: artstypes),OrganizationType(name: "Out-of-State, International, Transfer", image: "outofstate", children: misctypes)]
        
        let organizations = Organization(name: "Organizations", image: "organization", children: clubtypes)
        return organizations
    }
    
}
struct OrganizationCell: View
{
    var body: some View
    {
        VStack{

            Image(Organization.getallorgData().image)
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.width * 0.35)
                .cornerRadius(15)
            Text("Organizations")
                .bold()
                .font(.headline)
            Spacer()
            NavigationLink("View", destination: OrganizationTypeView(organization: Organization.getallorgData()))
            
        }
        .padding()
        
    }
}
struct OrganizationTypeCell: View
{
    let organizationtype: OrganizationType
    var body: some View
    {
        HStack{
            Image(organizationtype.image)
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                .cornerRadius(15)
            Text(organizationtype.name)
                .bold()
                .font(.headline)
            Spacer()

            
        }
        .padding()
        
    }
}
struct OrganizationTypeView: View
{
    let organization: Organization
    var body: some View {
    ZStack{
        LinearGradient(gradient: Gradient(colors: [.bruinblue, .white, .bruinyellow]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
        ScrollView{
            ForEach(organization.children, id: \.id)
            {child in
                HStack{
                    OrganizationTypeCell(organizationtype: child)
                    Spacer()
                    NavigationLink("View", destination: OrganizationTypeDetailedView(organizationtype: child))
                        .padding()
                }
            Divider().background(Color(.black))
            }
        }.navigationTitle("Club Types")
        .background(Color.clear)
        }
    }
}
struct OrganizationTypeDetailedCell: View
{
    let organizationtypedetailed: OrganizationTypeDetailed
    var body: some View
    {
        HStack{
            Image(organizationtypedetailed.image)
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                .cornerRadius(15)
            Text(organizationtypedetailed.name)
                .bold()
                .font(.headline)
            Spacer()

            
        }
        .padding()
        
    }
}
struct OrganizationTypeDetailedView: View
{
    let organizationtype: OrganizationType
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.bruinblue, .white, .bruinyellow]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
        ScrollView{
            ForEach(organizationtype.children, id: \.id)
            {child in
                HStack{
                    OrganizationTypeDetailedCell(organizationtypedetailed: child)
                    Spacer()
                    NavigationLink("View", destination: BaseStructureView(Basetype: child))
                        .padding()
                }
            Divider().background(Color(.black))
            }
        }.navigationTitle(organizationtype.name)
        .background(Color.clear)
        }
    }
}
