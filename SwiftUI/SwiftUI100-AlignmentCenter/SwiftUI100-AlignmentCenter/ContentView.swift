//
//  ContentView.swift
//  SwiftUI100-AlignmentCenter
//
//  Created by 9527 on 2022/9/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 8) {
            center1()
                    .frame(width: 300, height: 60)
                    .background(Color.blue)
                    .cornerRadius(8)

            center2()
                    .frame(width: 300, height: 60)
                    .background(Color.blue)
                    .cornerRadius(8)
        }
    }

    func center1() -> some View {
        HStack {
            Spacer(minLength: 0)
            Text("居中1 Spacer、居中1 Spacer、居中1 Spacer、居中1 Spacer、居中1 Spacer、居中1 Spacer、居中1 Spacer")
                    .foregroundColor(.white)
                    .font(.title)
                    .lineLimit(1)
            Spacer(minLength: 0)
        }
    }

    func center2() -> some View {
        HStack {
            Color.blue
                    .layoutPriority(0)
            Text("居中2 其它填充物")
                    .foregroundColor(.white)
                    .font(.title)
                    .lineLimit(1)
                    .layoutPriority(1)
            Color.blue
                    .layoutPriority(0)

        }
    }
}
