//
//  addProfilePicture.swift
//  bruinlabs
//
//  Created by James Guo on 12/29/20.
//  Copyright © 2020 Daniel Hu. All rights reserved.
//

import SwiftUI
import PhotosUI
struct PickImage: UIViewControllerRepresentable
{
    @Binding var show: Bool
    @Binding var ImageData: Data
    func makeCoordinator() -> Coordinator {
        return PickImage.Coordinator(parent: self)
    }
    func makeUIViewController(context: Context) -> PHPickerViewController
    {
        let controller = PHPickerViewController(configuration: PHPickerConfiguration())
        controller.delegate = context.coordinator
        return controller
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context)
    {
        
    }
    class Coordinator : NSObject, PHPickerViewControllerDelegate
    {
        var parent: PickImage
        init(parent: PickImage)
        {
            self.parent = parent
        }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if !results.isEmpty
            {
                if results.first!.itemProvider.canLoadObject(ofClass: UIImage.self)
                {
                    results.first!.itemProvider.loadObject(ofClass:UIImage.self)
                    { (image, _) in
                        guard let imageData = image else {return}
                        let data = (imageData as! UIImage).pngData()!
                        DispatchQueue.main.async
                        {
                            self.parent.ImageData = data
                            self.parent.show.toggle()
                        }
                    }
                }
                else
                {
                    self.parent.show.toggle()
                }
            }
            else
            {
                self.parent.show.toggle()
            }
        }
    }
}
struct addProfilePicture: View {
    @State var currentImage = 0
    @EnvironmentObject var accountCreation: AccountCreationViewModel
    var body: some View {
        VStack
        {
            HStack
            {
                Text("Show Yourself")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                Spacer()
                if check()
                {
                    Button(action: {accountCreation.SignUp()} , label: {
                        Text("Create")
                            .fontWeight(.heavy)
                            .foregroundColor(Color("bruinblue"))
                    
                    })
                }
                else
                {
                    Button(action: {accountCreation.SignUp()} , label: {
                        Text("Skip")
                            .fontWeight(.heavy)
                            .foregroundColor(Color("bruinblue"))
                })
            }
            
        }
            .padding(.top, 30)
            GeometryReader{geometry in
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing:15), count: 1), spacing: 20, content: {
                    ForEach(accountCreation.PFP.indices, id: \.self)
                    {
                        index in
                        ZStack{
                            if accountCreation.PFP[index].count == 0
                            {
                                Image(systemName: "person.badge.plus")
                                    .font(.system(size:50))
                                    .foregroundColor(Color("bruinblue"))
                            }
                            else
                            {
                                Image(uiImage: UIImage(data: accountCreation.PFP[index])!)
                                    .resizable()
                            }
                            
                        }.frame(width: (geometry.frame(in: .global).width)/1.5, height: (geometry.frame(in: .global).height)/1.5)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color("bruinblue"), lineWidth: 4))
                            .onTapGesture()
                            {
                                currentImage = index
                                accountCreation.picker.toggle()
                            }
                        
                    }
                })
                                         
                    
            }
            
        }
        .padding(.horizontal)
        .sheet(isPresented: $accountCreation.picker, content: {
            PickImage(show :$accountCreation.picker, ImageData: $accountCreation.PFP[currentImage])
        })
    }
    func check() -> Bool
    {
        for data in accountCreation.PFP {
            if data.count == 0
            {
                return false
            }
        }
        return true
    }
}

