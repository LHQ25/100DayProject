//
//  ContentView.swift
//  SwiftUIScrollViewReader
//
//  Created by 9527 on 2022/7/12.
//
//

import SwiftUI

struct ContentView: View {

    @State private var photoSet = sampleModels

    @State private var selectedPhotos: [Model] = []
    @State private var selectedPhotoId: UUID?

    var body: some View {
        VStack {
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                    ForEach(photoSet) { photo in
                        Image(photo.imageName)
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(photo.color)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 150)
                            .cornerRadius(8)
                            .onTapGesture {
                                selectedPhotoId = photo.id
                                selectedPhotos.append(photo)
                                photoSet.removeAll(where: { $0.id == photo.id })
                            }
                    }
                }
            }
            
            ScrollViewReader { scrollProxy in   // 滚动视图锚点组件，它可以让滚动视图移动到特定位置
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: [GridItem()]) {
                        ForEach(selectedPhotos) { photo in
                            Image(photo.imageName)
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(photo.color)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height: 150)
                                .cornerRadius(8)
                                .onTapGesture {
                                    photoSet.append(photo)
                                    selectedPhotos.removeAll(where: { $0.id == photo.id })
                                }
                        }
                    }
                }
                .frame(height: 100)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(6)
                .onChange(of: selectedPhotoId) { newValue in
                    guard let newValue = newValue else {return}
                    scrollProxy.scrollTo(newValue)
                }
            }
            
            
        }.padding()
    }
}
