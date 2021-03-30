//
//  ContentView.swift
//  bruinlabs
//
//  Created by James Guo on 12/28/20.
//  Copyright © 2020 Daniel Hu. All rights reserved.
//

import SwiftUI
import Firebase

struct Display: View {
    @ObservedObject var accountCreation = AccountCreationViewModel()
    @EnvironmentObject var currentUser : CurrentUser
    @State var status = false
    @State var count = 1
    var body: some View {
        NavigationView
        {
            if self.status
            {
                
                SearchScreen()
                    .onAppear()
                    {
                        if self.count == 1
                        {
                            currentUser.listen()
                            self.count += 1
                        }
                    }
            }
            
            else
            {
                ZStack{

                    MainView().environmentObject(accountCreation)
                    if accountCreation.isLoading
                    {
                        LoadingScreen()
                    }
                }.navigationTitle("")
                .navigationBarHidden(true)
                .onAppear {
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                    }
                }
            }
            }
    }
}
struct ContentView: View {
    @ObservedObject var currentUser = CurrentUser()
    init()
    {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    var body: some View
    {
        Display().environmentObject(currentUser)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
