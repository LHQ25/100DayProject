//
// Created by 9527 on 2022/7/27.
//

import SwiftUI

struct PolygonShapeExample: View {
    
    @State var isSquare = 3
    
    var body: some View {
        
        VStack {
            
            GeometryReader { geometryProxy in
                PolygonShape(sides: isSquare)
                    .stroke(Color.blue, lineWidth: 3)
                    .animation(.easeInOut(duration: 3))
                    .frame(width: geometryProxy.size.width, height: 200)
            }

            
            Spacer()
            
            HStack {
                MyButton(label: "Add") {
                    isSquare += 1
                }.cornerRadius(6)

                MyButton(label: "Rel") {
                    isSquare -= 1
                }.cornerRadius(6)
            }
        }
        
    }
}

struct PolygonShape: Shape {

    var sides: Double

    /*
     为了使形状可动画化，我们需要 SwiftUI 多次渲染视图，使用从原点到目标数之间的所有边值。幸运的是，Shape已经符合了Animatable协议的要求。
     这意味着，有一个计算的属性（animatableData），我们可以用它来处理这个任务。然而，它的默认实现被设置为EmptyAnimatableData。所以它什么都不做
     */
    var animatableData: Double {
        get { sides }
        set {  sides = newValue }
    }

    init(sides: Int) {
        self.sides = Double(sides)
    }

    func path(in rect: CGRect) -> Path {

        let h = Double(min(rect.size.width, rect.size.height)) / 2.0

        let c = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)

        var path = Path()

        // 如何绘制一个边数为非整数的多边形。我们将稍微改变我们的代码。随着小数部分的增长，这个新的边将从零到全长。其他顶点将相应地平稳地重新定位。这听起来很复杂，但这是一个最小的变化
        let extra: Int = Double(sides) != Double(Int(sides)) ? 1 : 0
        
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
