//
//  ContentView.swift
//  SwiftUIPath
//
//  Created by 9527 on 2022/7/14.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        VStack {
        
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x:0, y: 200))
                path.addLine(to: CGPoint(x: 300, y: 200))
                path.addLine(to: CGPoint(x: 300, y: 0))
                path.closeSubpath()
            }
            //.fill(.blue) // 填充色
            .stroke(Color.red, lineWidth: 2)
            
            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 240))
                    path.addLine(to: CGPoint(x:15, y: 240))
                    path.addQuadCurve(to: CGPoint(x: 285, y: 240), control: CGPoint(x: 150, y: 200))
                    path.addLine(to: CGPoint(x:300, y: 240))
                    path.addLine(to: CGPoint(x:300, y: 300))
                    path.addLine(to: CGPoint(x: 0, y: 300))
                    path.closeSubpath()
                }
                .fill(.blue) // 填充色
                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 240))
                    path.addLine(to: CGPoint(x:15, y: 240))
                    path.addQuadCurve(to: CGPoint(x: 285, y: 240), control: CGPoint(x: 150, y: 200))
                    path.addLine(to: CGPoint(x:300, y: 240))
                    path.addLine(to: CGPoint(x:300, y: 300))
                    path.addLine(to: CGPoint(x: 0, y: 300))
                    path.closeSubpath()
                }
                .stroke(Color.red, lineWidth: 2)
            }
            
            Path { path in
                path.move(to: CGPoint(x: 150, y: 180))
                path.addArc(center: CGPoint(x: 150, y: 180), radius: 90, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: true)
            }
            .fill(.blue) // 填充色
            
            Spacer()
        }
        
        
    }
}
