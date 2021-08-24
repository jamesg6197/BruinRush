//
//  UserModel.swift
//  bruinlabs
//
//  Created by James Guo on 12/28/20.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import Combine
class CurrentUser: ObservableObject
{
    var handle: AuthStateDidChangeListenerHandle?
    
    @Published var displayName = ""
    @Published var bio = ""
    @Published var year = ""
    @Published var major = ""
    @Published var email = ""
    @Published var password = ""
    @Published var imageurl: String?
    @Published var uid = ""
    @Published var reviewsref = [String]()
    @Published var reviews = [completedReviews]()

    // Used to create reviews List
    var pname = ""
    var preview = ""
    var prating = 0
    var puid = ""
    var ptime = ""
    var imageurls: Array<String>?
    var pclub = ""
    var prawtime = Timestamp()
    var pdate = Date()
    func listen() {
        self.handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                let docRef = Firestore.firestore().collection("Users").document(user.uid)
                self.email = user.email ?? ""
                self.uid = user.uid
                self.reviews = []
                docRef.getDocument{ (document, error) in
                    if let document = document {
                        self.displayName = document.get("displayName") as? String ?? ""
                        self.bio = document.get("bio") as? String ?? ""
                        self.year = document.get("year")as? String ?? ""
                        self.major = document.get("major")as? String ?? ""
                        self.imageurls = document.get("imageurls")as? Array ?? nil
                        self.imageurl = self.imageurls?[0]
                        self.reviewsref = document.get("reviews") as? Array ?? []
                        for review in self.reviewsref {
                            let revRef = Firestore.firestore().document("All Reviews/\(review)")
                            revRef.getDocument { (document, error) in
                                if let document = document {
                                    self.pname = document.get("name") as? String ?? "failed"
                                    self.preview = document.get("review") as? String ?? "failed"
                                    self.prating = document.get("rating") as? Int ?? 0
                                    self.puid = document.get("uid") as? String ?? "failed"
                                    self.ptime = document.get("time") as? String ?? "failed"
                                    self.pclub = document.get("club") as? String ?? "failed"
                                    self.prawtime = document.get("rawtime") as? Timestamp ?? Timestamp()
                                    self.pdate = self.prawtime.dateValue()
                                    self.reviews.append(completedReviews(suid: self.puid, sName : self.pname,  sReview: self.preview, sRating: self.prating, sYear: "", sTime: self.ptime, sClub: self.pclub, rawTime: self.pdate))
                                }
                                else{
                                    print("Document does not exist in cache")
                                }
                            }
                        }
                    }
                    else {
                        print("Document does not exist in cache")
                    }
                }
            }
            else {
                print("Failed")
            }
        })
    }
    func leave() {
        self.displayName = ""
        self.bio = ""
        self.year = ""
        self.major = ""
        self.email = ""
        self.password = ""
        self.imageurl = ""
        self.uid = ""
        self.reviewsref = [String]()
        self.reviews = [completedReviews]()
    }
    
}
class AccountCreationViewModel: ObservableObject
{
    @Published var displayName = ""
    @Published var PFP = Array(repeating: Data(count : 0), count: 1)
    @Published var bio = ""
    @Published var year = ""
    @Published var major = ""
    
    
    @Published var email = ""
    @Published var password = ""
    @Published var retype = ""
    
    @Published var reviews = Array(repeating: String(), count: 0)

    @Published var pageNumber = 0
    @Published var picker = false
    @Published var alert = false
    @Published var error = ""
    @Published var isLoading = false
    @Published var loggedIn = false
    func login()
    {
        isLoading.toggle()
        if self.email != "" && self.password != ""
        {
            
            Auth.auth().signIn(withEmail: self.email, password: self.password) { (res, err) in
                self.isLoading.toggle()
                if err != nil {
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                print("success")
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
                
            }
        }
        else
        {
            self.isLoading.toggle()
            self.error = "Please fill out all respected fields"
            self.alert.toggle()
        }
    }
    func checkReg()
    {
        var errorcheck = false
        if self.email != "" {
            if self.password == self.retype {
                Auth.auth().createUser(withEmail: self.email, password: self.password){
                    (res, err) in
                    if err != nil {
                        errorcheck.toggle()
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    self.register()
                    print("success")
                    self.pageNumber = 3
                }
            }
            else{
                self.error = "Password and Retyped Password don't match!"
                self.alert.toggle()
            }
        }
        else
        {
            self.error = "Please fill out all required fields!"
            self.alert.toggle()
        }
    }
    func SignUp(){
        
        let storage = Storage.storage().reference()
        let ref = storage.child("profile_Pic").child(Auth.auth().currentUser!.uid)
        var urls : [String] = []
        for index in PFP.indices
        {
            ref.child("img\(index)").putData(PFP[index], metadata: nil) { (_, err)
                in
                if err != nil
                {
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                ref.child("img\(index)").downloadURL {(url, _) in
                    guard let imageUrl = url else{return}
                    urls.append("\(imageUrl)")
                    if urls.count == self.PFP.count {
                        self.register()
                    }
                }

            }
        }
        self.pageNumber = 1
    }
        
    func register() {
        let db = Firestore.firestore()
        db.collection("Users").document(Auth.auth().currentUser!.uid).setData([
            "displayName": self.displayName,
            "bio": self.bio,
            "year": self.year,
            "major": self.major,
            "reviews": self.reviews
            
        ])
        {(err) in
            if err != nil
            {
                self.error = err!.localizedDescription
                self.alert.toggle()
                return
            }
            self.isLoading.toggle()
            
        }
        
    }
    func registerImage(urls: [String])
    {
        let db = Firestore.firestore()
        db.collection("Users").document(Auth.auth().currentUser!.uid).setData([
            "imageurls": urls,
            
        ])
        {(err) in
            if err != nil
            {
                self.error = err!.localizedDescription
                self.alert.toggle()
                return
            }
            self.isLoading.toggle()
            
        }
        
    }
    func reset()
    {
        if self.email != ""
        {
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                if err != nil {
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                self.error = "RESET"
                self.alert.toggle()
            }
        }
        else
        {
            self.error = "Please type an Email"
            self.alert.toggle()
        }
    }
}

struct ErrorView : View
{
    @State var color = Color.black.opacity(0.7)
    @Binding var alert : Bool
    @Binding var error : String
    var body: some View
    {
        ZStack {
        GeometryReader{_ in
            
        }
        .background(Color.black.opacity(0.3).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        VStack {
        HStack
        {
            Text(self.error == "RESET" ? "Message" :"Error" )
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(self.color)
        }
        .padding(.horizontal, 25)
            Text(self.error == "RESET" ? "Password Reset link has been sent!": self.error)
            .foregroundColor(self.color)
            .padding(.top)
            .padding(.horizontal, 25)
        Button(action: {
            self.alert.toggle()
        })
        {
            Text(self.error == "RESET" ? "Done" : "Cancel")
                .foregroundColor(self.color)
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width - 120)
        }
        .background(Color("Color"))
        .cornerRadius(10)
        .padding(.top, 25)
        }
                .padding(.vertical, 25)
                .frame(width: UIScreen.main.bounds.width - 70)
                .background(Color.white)
                .cornerRadius(15)
        }
        
    }
}

