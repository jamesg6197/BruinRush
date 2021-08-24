//
//  SwiftUIView.swift
//  bruinlabs
//
//  Created by James Guo on 1/2/21.
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
            .aspectRatio(contentMode: .fit)
            .frame(width: 150, height: 150)
    }
    
    static var defaultImage = UIImage(named: "defaultpfp")
}


