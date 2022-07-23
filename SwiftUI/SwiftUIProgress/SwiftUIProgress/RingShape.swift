//
//  RingShape.swift
//  SwiftUIProgress
//
//  Created by 9527 on 2022/7/12.
//

import SwiftUI

//内环
/*
 创建了RingShape结构体，它遵循Shape协议。然后我们和外环一样，定义了它的厚度thickness，另外还有内环的进度百分比progress参数。
 startAngle开始角度为-90，这是因为我们圆放在坐标轴上，它的开始点是圆右边中间的位置，而我们进度的圆环是从圆的顶部的顶点开始，所以startAngle开始角度需要设置为-90度。
 内环的绘制我们使用addArc的方法，起始角度为0，结束角度用360度乘以progress进度的值，而且要加上startAngle开始角度来计算
 */
struct RingShape: Shape {
    
    var progress: Double = 0.0
    var thickness: CGFloat = 30.0
    var startAngle: Double = -90.0
    
    var animatableData: Double {
        set { progress = newValue }
        get { progress }
    }
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        path.addArc(center: CGPoint(x: rect.width/2.0, y: rect.width/2.0), radius: min(rect.width, rect.height) / 2.0, startAngle: .degrees(startAngle), endAngle: .degrees(360 * progress+startAngle), clockwise: false)
        return path.strokedPath(.init(lineWidth: thickness, lineCap: .round))
    }
    
}

