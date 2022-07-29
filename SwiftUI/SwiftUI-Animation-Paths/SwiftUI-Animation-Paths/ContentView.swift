//
//  ContentView.swift
//  SwiftUI-Animation-Paths
//
//  Created by 9527 on 2022/7/27.
//
//

import SwiftUI

struct ContentView: View {

    
    var body: some View {

        NavigationView {
            List {
                Section(header: Text("Animation")) {
                    NavigationLink(destination: AnimationExample()) {
                        Text("显式动画和隐式动画")
                    }
                }
                Section (header: Text("Shape")){

                    NavigationLink(destination: PolygonShapeExample()) {
                        Text("Animation Shap1")
                    }

                    NavigationLink(destination: PolygonShapeExample2()) {
                        Text("Animation Shap2")
                    }
                }
            }

        }
    }
}

struct MyButton: View {
    let label: String
    var font: Font = .title
    var textColor: Color = .white
    let action: () -> ()
    var body: some View {
        Button(action: {
            self.action()
        }, label: {
            Text(label)
                    .font(font)
                    .padding(10)
                    .frame(width: 70)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.green).shadow(radius: 2))
                    .foregroundColor(textColor)
        })
    }
}