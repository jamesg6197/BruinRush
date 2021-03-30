//
//  InfoPage.swift
//  bruinlabs
//
//  Created by James Guo on 12/21/20.
//  Copyright © 2020 Daniel Hu. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseFirestore
struct InfoPage: View
{
    @EnvironmentObject var currentUser: CurrentUser
    
    var body: some View
    {
        ZStack
        {
            LinearGradient(gradient: Gradient(colors: [.bruinblue, .white, .bruinyellow]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            VStack
            {
                ScrollView
                {
                    Spacer()
                    Text("We are a UCLA startup that seeks to connect communities across campus by providing student and alumni reviews for organizations. See contact below if you want to see your club added!")
                            .frame(alignment: .trailing)
                            .padding()
                    Spacer()
                    VStack()
                    {
                        Text("Contact:")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                        Text("RushOutreach@gmail.com")
                            .padding(.top)
                                          
                        Spacer()
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: UIScreen.main.bounds.height/3.5)
                            .padding(.top)
                                            
                                                
                    }
                        
                }.navigationBarTitle("About")
            }
        }
    }
}
