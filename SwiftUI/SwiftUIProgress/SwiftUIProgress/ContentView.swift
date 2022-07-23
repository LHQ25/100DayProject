//
//  ContentView.swift
//  SwiftUIProgress
//
//  Created by 9527 on 2022/7/12.
//

import SwiftUI


//MARK: - 使用Shape形状和Animation动画创建一个圆形进度条

struct ContentView: View {
    
    var thickness: CGFloat = 30.0
    var width: CGFloat = 250.0
    
    var startAngle = -90.0
    
    @State var progress = 0.0
    
    var body: some View {
        
        VStack {
            ZStack {
                
                Circle()
                    .stroke(Color(.systemGray6), lineWidth: thickness)
                
                RingShape(progress: progress, thickness: thickness)
                // 添加渐变色， AngularGradient角梯度，AngularGradient角梯度是SwiftUI提供的一种绘制渐变色的方法，可以跟随不同角度变化，从起点到终点，颜色按顺时针做扇形渐变
                    .fill(AngularGradient(gradient: Gradient(colors: [.gradientPink, .gradientYellow]), center: .center, startAngle: .degrees(startAngle), endAngle: .degrees(360 * 0.3 + startAngle)))
                    .animation(.easeInOut(duration: 1.0), value: progress)
            }
            .frame(width: width, height: width, alignment: .center)
            //进度调节
            HStack {
                /*
                 我们发现内环的Animation动画好像不起效果，进度加载仍旧很生硬。
                 这是因为我们在实现RingShape内环构建的过程中，它符合Shape协议，而恰巧是Shape协议它有一个默认的动画，也就是没有数据的动画。
                 因此在ContentView中，我们怎么加Animation动画效果都没有作用。
                 要解决这个问题也很简单，我们只需要在构建RingShape内环时，赋予progress新的值就可以了
                 */
                Group {
                    Text("0%")
                        .font(.system(.headline, design: .rounded))
                        .onTapGesture {
                            self.progress = 0.0
                        }
                    
                    Text("50%")
                        .font(.system(.headline, design: .rounded))
                        .onTapGesture {
                            self.progress = 0.5
                        }
                    
                    Text("100%")
                        .font(.system(.headline, design: .rounded))
                        .onTapGesture {
                            self.progress = 1.0
                        }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))
                .padding()
            }
            .padding()
        }
    }
}



extension Color {
    
    public init(red: Int, green: Int, blue: Int, opacity: Double = 1.0) {
        let redValue = Double(red) / 255.0
        let greenValue = Double(green) / 255.0
        let blueValue = Double(blue) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, opacity: opacity)
    }
    
    public static let gradientPink = Color(red: 210, green: 153, blue: 194)
    public static let gradientYellow = Color(red: 254, green: 249, blue: 215)
}
