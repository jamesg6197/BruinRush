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
struct Feature: Identifiable
{
    var id = UUID()
    var name : String
    var desc : String
}
class getData : ObservableObject
{
    @Published var catalog = [String : BaseStructure]()
    @Published var array = [BaseStructure]()
    
    init()
    {
        let db = Firestore.firestore()
        db.collection("All Orgs").getDocuments{ (snap, err) in
            if err != nil
            {
                print((err?.localizedDescription)!)
                return
            }
            for i in snap!.documents
            {
                let id = i.documentID
                let name = i.get("name") as! String
                let image = i.get("image") as! String
                let description = i.get("description") as! String
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
    init()
    {
        self.viewFeatures.fetchData()
        
        
        
    }
    var body: some View {
            TabView{
                   
                ZStack{
                    
                    Color.black
                    Text("Featured Clubs")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    
                }.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                ForEach(self.viewFeatures.features){
                    i in
                    ZStack{
                        Color.gray.opacity(0.3)
                        if dcatalog.catalog[i.name] != nil {
                    NavigationLink (destination: ClubDescriptionView(Base: dcatalog.catalog[i.name]!))
                        {
                        FeaturedView(feature: dcatalog.catalog[i.name]!)
                        }.buttonStyle(PlainButtonStyle())
                        }
                    }
                    }
                
                        
            }
                
                    
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            
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
    init()
    {
        self.data = self.rawdata.array
        
    }
    var body: some View
    {
       

        VStack{
            ScrollView
            {
               
                ScrollView
                {
                    HStack
                    {
                        PageView().environmentObject(rawdata)
                    }
                }
                HStack{
                    HStack
                    {
                        TextField("Search", text: $searchtext)
                            .padding(.leading, 24)
                    }
                    .padding()
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
                                Button (action :{ searchtext = ""})
                                {
                                    Image(systemName: "xmark.circle.fill").padding()
                                }
                            }
                            
                        }.padding(.horizontal, 32)
                        .foregroundColor(.gray)
                    )
                    if isSearching {
                        Button (action :{ isSearching = false
                            searchtext = ""
                        }, label:
                            {
                                Text("Cancel").padding(.trailing)
                            }
                        ).transition(.move(edge: .trailing))
                        .animation(.spring())
                    }
                }
                if isSearching && searchtext != "" {
                    if self.rawdata.array.filter{$0.name.lowercased().contains(self.searchtext.lowercased())}.count == 0
                    {
                        Text("No Results Found").foregroundColor(Color.black.opacity(0.4)).padding()
                    }
                    else
                    {
                        ForEach(self.rawdata.array.filter{$0.name.lowercased().contains(self.searchtext.lowercased())})
                        {i in
                            VStack
                            {
                                NavigationLink (destination: ClubDescriptionView(Base: i))
                                {
                                    Text(i.name)
                                }.isDetailLink(false)
                            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding()
                            Divider()
                            
                        }
                        .listRowBackground(Color.clear)
                        
                    }
                }
                else if isSearching && searchtext == ""
                {
                    
                }
                else
                {
                    CatalogScreen()
                    
                }
            }
            .navigationBarTitle("Discover")
            .background(LinearGradient(gradient: Gradient(colors: [.bruinblue, .white, .bruinyellow]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all))
            
            
                BottomView().padding()
            }.navigationBarBackButtonHidden(true)
        
    }
        
}

//***************//
//Catalog Screen!//
//***************//
struct CatalogScreen: View
{
    var body: some View
    {
        HStack{
            GreekLifeCell()
            OrganizationCell()
        }
        Divider()
        

    }
}

