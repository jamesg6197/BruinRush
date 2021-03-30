//
//  SwiftUIView.swift
//  bruinlabs
//
//  Created by James Guo on 1/2/21.
//  Copyright © 2021 Daniel Hu. All rights reserved.
//
import Foundation
import SwiftUI
struct UrlImageView: View {
    @ObservedObject var urlImageModel: UrlImageModel
    
    init(urlString: String?) {
        urlImageModel = UrlImageModel(urlString: urlString)
    }
    
    var body: some View {
        Image(uiImage: urlImageModel.image ?? UrlImageView.defaultImage!)
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
    }
    
    static var defaultImage = UIImage(named: "defaultpfp")
}


