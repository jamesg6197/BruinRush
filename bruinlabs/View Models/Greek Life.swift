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
        VStack{

            Image(GreekLife.getGlifeData().image)
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.width * 0.35)
                .cornerRadius(15)
            Text("Greek Life")
                .bold()
                .font(.headline)
            Spacer()
            NavigationLink("View", destination: CouncilView(greeklife: GreekLife.getGlifeData()))
            
        }
        .padding()
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
            LinearGradient(gradient: Gradient(colors: [.bruinblue, .white, .bruinyellow]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
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
            Divider().background(Color(.black))
            }
        }.navigationTitle("Councils")
        .background(Color.clear)
        }
    }
}

