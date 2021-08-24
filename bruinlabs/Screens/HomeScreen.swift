
//
//  ContentView.swift
//  bruinlabs
//
//  Created by Daniel Hu on 7/14/20.
//  Copyright © 2020 Daniel Hu. All rights reserved.
//
import SwiftUI
import Firebase
import FirebaseFirestore
import SwiftyJSON
import SDWebImageSwiftUI
//***********//
//Main Screen//
//***********//

struct FeaturedView : View
{
    var link : BaseStructure
    init(feature: BaseStructure) {
        self.link = feature
    }
    var body: some View {
        if (self.link.name == "blank") {
            ProgressView()
        }
        else {
            HStack{
                Image(self.link.image)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .frame(width: UIScreen.main.bounds.height * 0.15, height: UIScreen.main.bounds.height * 0.15
                   , alignment: .leading)
                .padding()
                Text(self.link.description)
            }
        }
    }
}
