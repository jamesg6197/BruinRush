//
//  Greek Life.swift
//  bruinlabs
//
//  Created by James Guo on 12/6/20.
//

//
//  GreekLife.swift
//  bruinlabs
//
//  Created by James Guo on 11/27/20.
//
import SwiftUI
import Foundation

class GreekLife
{
    let id = UUID()
    let name: String
    let image: String
    let children: [GreekLifeTypes]
    init(name: String, image: String, children: [GreekLifeTypes]) {
              self.name = name
              self.image = image
              self.children = children
         }
}
class GreekLifeTypes: BaseType
{
}

extension GreekLife
{
    static func getGlifeData() -> GreekLife
    {

        let councils : [GreekLifeTypes] = [GreekLifeTypes(name: "AGC", image: "agc"), GreekLifeTypes(name: "IFC", image: "ifc"), GreekLifeTypes(name:"LGC", image: "lgc"), GreekLifeTypes(name: "PFC", image: "pfc"), GreekLifeTypes(name: "MIGC", image: "migc"), GreekLifeTypes(name:"NPC", image: "npc"), GreekLifeTypes(name: "NPHC", image: "nphc")]
        let greekLife = GreekLife(name: "Greek Life", image: "greeklife", children: councils)
        return greekLife
    }
}
struct GreekLifeCell: View
{
    var body: some View
    {
        NavigationLink(destination: CouncilView(greeklife: GreekLife.getGlifeData()))
        {
        ZStack{
            //Color.white
            VStack{

            Image(systemName: "sum")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.width * 0.15)
                
                
            Text("Greek Life")
                .bold()
                .font(.subheadline)
                
            
            
            
        }
        .padding()
        }.cornerRadius(15)
        //.shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
        //.shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
        
        }.buttonStyle(PlainButtonStyle())
    }
}
struct CouncilCell: View
{
    let council: GreekLifeTypes
    var body: some View
    {
        HStack{
            Image(council.image)
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                .cornerRadius(15)
            Text(council.name)
                .bold()
                .font(.headline)
            Spacer()
        }
        .padding()
    }
    
}
struct CouncilView: View
{
    let greeklife: GreekLife
    var body: some View
    {
        ZStack{
            Color("Background").edgesIgnoringSafeArea(.all)
        ScrollView{
            ForEach(greeklife.children, id: \.id)
            {child in
                HStack{
                    CouncilCell(council: child)
                        
                    Spacer()
                    NavigationLink("View", destination:
                                    BaseStructureView(Basetype: child))
                        .padding()
                }
                .border(Color.gray.opacity(0.2))
                .cornerRadius(7)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                .padding()
            
            }
        }.navigationTitle("Councils")
        .background(Color.clear)
        }
    }
}

