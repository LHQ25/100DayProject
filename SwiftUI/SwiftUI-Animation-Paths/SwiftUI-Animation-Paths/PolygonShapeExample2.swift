//
//  PolygonShapeExample2.swift
//  SwiftUI-Animation-Paths
//
//  Created by 9527 on 2022/7/28.
//

import SwiftUI

/* 不止一个参数的动画 */

struct PolygonShapeExample2: View {
    
    @State var sides: Double = 3
    @State var scale: Double = 1
    
    var body: some View {
        
        VStack {

            PolygonShape2(sides: sides, scale: scale)
                    .stroke(Color.blue, lineWidth: 3)
                    .padding(20)
                    .animation(.easeInOut(duration: 3))
                    .layoutPriority(1)

            Text("\(Int(sides)) sides, \(String(format: "%.2f", scale as Double)) scale")

            HStack(spacing: 20) {
                MyButton(label: "1") {
                    self.sides = 1.0
                    self.scale = 1.0
                }
                MyButton(label: "3") {
                    self.sides = 3.0
                    self.scale = 0.7
                }
                MyButton(label: "7") {
                    self.sides = 7.0
                    self.scale = 0.4
                }
                MyButton(label: "30") {
                    self.sides = 30.0
                    self.scale = 1.0
                }
            }
        }.navigationBarTitle("Example 3").padding(.bottom, 50)
        
    }
}

struct PolygonShape2: Shape {

    var sides: Double
    var scale: Double

    /*
     不止一个参数设置动画，我们可以使用AnimatablePair<First, Second> ,这里的First和Second都要遵循VectorArithmetic
     */
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(sides, scale) }
        set {
            sides = newValue.first
            scale = newValue.second
        }
    }

    init(sides: Double, scale: Double) {
        self.sides = sides
        self.scale = scale
    }

    func path(in rect: CGRect) -> Path {

        let h = Double(min(rect.size.width, rect.size.height)) / 2.0

        let c = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)

        var path = Path()

        // 如何绘制一个边数为非整数的多边形。我们将稍微改变我们的代码。随着小数部分的增长，这个新的边将从零到全长。其他顶点将相应地平稳地重新定位。这听起来很复杂，但这是一个最小的变化
        let extra: Int = sides != Double(Int(sides)) ? 1 : 0
        
        for i in 0..<(Int(sides) + extra) {
            
            let angle = (Double(i) * (360 / sides)) * ( Double.pi / 180)

            let pt = CGPoint(x: c.x + CGFloat(cos(angle) * h), y: c.y + CGFloat(sin(angle) * h))

            if i == 0 {
                path.move(to: pt)
            } else {
                path.addLine(to: pt)
            }
        }
        path.closeSubpath()
        return path
    }
}
