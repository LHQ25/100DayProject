//
//  ContentView.swift
//  SwiftUIBanner
//
//  Created by 9527 on 2022/7/16.
//

import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        
        GeometryReader { outerView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center) {
                    ForEach(imageModels) {
                        
                        CardView(image: $0.image, name: $0.imageName)
                    }
                }
            }
        }
    }
}


struct imageModel: Identifiable {
    var id = UUID()
    var image: String
    var imageName: String
}

let imageModels = [
    imageModel(image: "1", imageName: "图片01"),
    imageModel(image: "2", imageName: "图片02"),
    imageModel(image: "3", imageName: "图片03"),
    imageModel(image: "4", imageName: "图片04"),
    imageModel(image: "5", imageName: "图片05"),
    imageModel(image: "6", imageName: "图片06"),
    imageModel(image: "7", imageName: "图片07"),
    imageModel(image: "8", imageName: "图片08"),
    imageModel(image: "9", imageName: "图片09")
]
