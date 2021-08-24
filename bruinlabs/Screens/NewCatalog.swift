//
//  Catalogfixed.swift
//  bruinlabs
//
//  Created by James Guo on 3/30/21.

import Foundation
import SwiftUI
import Firebase

//*************//
//Search Screen//
//*************//
struct Feature: Identifiable {
    var id = UUID()
    var name : String
    var desc : String
}
class getData : ObservableObject {
    @Published var catalog = [String : BaseStructure]()
    @Published var array = [BaseStructure]()
    
    init()
    {
        let db = Firestore.firestore()
        db.collection("All Orgs").getDocuments{ (snap, err) in
            if (err != nil){
                print((err?.localizedDescription)!)
                return
            }
            for i in snap!.documents {
                let id = i.documentID
                let name = i.get("name") as? String ?? ""
                let image = i.get("image") as? String ?? ""
                let description = i.get("description") as? String ?? ""
                self.catalog[name] = (BaseStructure(id: id, name: name, image: image, description: description))
                self.array.append(BaseStructure(id: id, name: name, image: image, description: description))
            }
        }
        
    }
}
struct PageView: View {
    @State var color = Color.black.opacity(0.7)
    @EnvironmentObject var dcatalog : getData
    @State var clubs = [BaseStructure]()
    @State private var show = false
    @ObservedObject private var viewFeatures = FeaturedViewModel()
    init(){
        self.viewFeatures.fetchData()
        
    }
    var body: some View {
            TabView{
                    Image("landscape")
                        .resizable()
                ForEach(self.viewFeatures.features){
                    i in
                    ZStack{
                        Color.white
                        
                        
                    NavigationLink (destination: ClubDescriptionView(Base: dcatalog.catalog[i.name]!)) {
                         HStack {
                            Image(dcatalog.catalog[i.name]?.image ?? "")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            VStack{
                                HStack {
                                    Text(i.name)
                                        .fontWeight(.bold)
                                        .font(.subheadline)
                                    Spacer()
                                }
                             Text(dcatalog.catalog[i.name]?.description ?? "")
                                .padding()
                            }
                         }.padding()
                        
                    }.buttonStyle(PlainButtonStyle())
                        
                }
            }
        }.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
         .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
         .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
         .padding(.all)
            .frame(width: UIScreen.main.bounds.width, height: 200)
            .tabViewStyle(PageTabViewStyle())
    }
}
struct SearchScreen: View {
    @State var searchtext = ""
    @State var isSearching = false
    @State var data = [BaseStructure]()
    @ObservedObject var rawdata = getData()
    init() {
        self.data = self.rawdata.array
        
    }
    var body: some View {
        VStack{
            ScrollView {
                HStack {
                    Text("Discover").bold().font(.largeTitle)
                    Spacer()
                }.padding()
                HStack{
                    HStack {
                        TextField("Search", text: $searchtext)
                            .padding(.leading, 24)
                    }.padding()
                     .background(Color(.quaternarySystemFill).opacity(1.5))
                     .cornerRadius(15)
                     .padding(.horizontal)
                     .onTapGesture {
                        isSearching = true
                    }
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Spacer()
                            if isSearching {
                                Button (action :{ searchtext = ""}) {
                                    Image(systemName: "xmark.circle.fill").padding()
                                }
                            }
                        }.padding(.horizontal, 32)
                         .foregroundColor(.gray)
                    )
                    if isSearching {
                        Button (action :{ isSearching = false
                            searchtext = ""
                        }, label:{
                                Text("Cancel").padding(.trailing)
                            }
                        ).transition(.move(edge: .trailing))
                        .animation(.spring())
                    }
                }
                HStack {
                    Text("Featured")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        
                    Spacer()
                }
                ScrollView {
                    HStack {
                        PageView().environmentObject(rawdata)
                    }
                }
                if (isSearching && searchtext != "") {
                    if (self.rawdata.array.filter{$0.name.lowercased().contains(self.searchtext.lowercased())}.count == 0) {
                        Text("No Results Found").foregroundColor(Color.black.opacity(0.4)).padding()
                    }
                    else {
                        ForEach(self.rawdata.array.filter{$0.name.lowercased().contains(self.searchtext.lowercased())}) {i in
                            VStack {
                                NavigationLink (destination: ClubDescriptionView(Base: i)) {
                                    Text(i.name)
                                }.isDetailLink(false)
                            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding()
                            Divider()
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                else if isSearching && searchtext == "" {
                }
                else {
                    HStack{
                        Text("Organization Types")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            
                        Spacer()
                    }
                    CatalogScreen()
                }
            }
            .background(Color("Background").edgesIgnoringSafeArea(.all))
                BottomView().padding()
            }.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
    }
}

//***************//
//Catalog Screen!//
//***************//
struct CatalogScreen: View {
    private var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        LazyVGrid(columns: threeColumnGrid) {
            GreekLifeCell()
            OrganizationTypeView(organization: Organization.getallorgData())
            JobReviewCell()
        }.padding(5)
    }
}

