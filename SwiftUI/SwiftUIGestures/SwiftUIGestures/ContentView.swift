//
//  ContentView.swift
//  SwiftUIGestures
//
//  Created by 9527 on 2022/7/15.
//

import SwiftUI

/*
 1、onTapGesture点击手势
 2、LongPressGesture长按手势
 3、DragGesture拖拽手势
 4、多种手势组合使用
 */

struct ContentView: View {
    
    //定义状态
    @State private var circleColorChanged = false
    @State private var heartColorChanged = false
    @State private var heartSizeChanged = false
    
    // @GestureState属性包装器。和之前的章节学习的@State一样，它可以监测长按手势的状态，也就是点击的时候它能“知道”
    // 使用@GestureState的好处是，当手势结束时，它会自动将手势状态属性的值设置为初始值
    @GestureState private var longPressTap = false

    // 需要使用@GestureState属性包装器定义一个拖拽位置参数dragOffset，用来记录我们的拖拽前的初始位置CGSize.zero，也用来监听和更新UI
    @GestureState private var dragOffset = CGSize.zero
    
    // 由于我们使用@GestureState属性包装器监听变化，因此拖动结束后，视图还会回到初始位置。
    // 如果我们想要拖动之后，就把视图放在拖拽后的位置，还记得之前的章节么？没错，我们需要使用@State把拖动后的位置存储起来
    @State private var position = CGSize.zero


    
    var body: some View {
        VStack {
            gestureDemo()
            muliGestureDemo()
        }
    }
    
    func muliGestureDemo() -> some View {
        ZStack {
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor( circleColorChanged ? Color(.systemGray5) : .red)
            Image(systemName: "heart.fill")
                .foregroundColor(heartColorChanged ? .red : .white)
                .font(.system(size: 30))
                .scaleEffect(heartSizeChanged ? 1.0 : 0.5)
                .opacity(longPressTap ? 0.4 : 1.0)  // 心形加个透明度的效果，长按时，即longPressTap被点击时，透明度变化
        }
        .offset(x: dragOffset.width + position.width, y: dragOffset.height + position.height)
        .gesture(
            // 长按手势
            LongPressGesture(minimumDuration: 1.0)
                // 长按手势更新方法
                .updating($longPressTap, body: {(currentState, state, transaction) in
                    state = currentState
                    self.circleColorChanged.toggle()
                    self.heartColorChanged.toggle()
                    self.heartSizeChanged.toggle()
                })
                .sequenced(before: DragGesture())   // LongPressGesture长按手势后承接的是DragGesture拖拽手势，承接的手势组合顺序的用的修饰符是.sequenced序列
                .updating($dragOffset, body: { currentPostion, state, translation in    // 实现拖拽手势的更新方法
                    switch currentPostion {         // 这里我们用switch语句来区分手势，使用.first和.second case来找出要处理的手势，首先识别的是LongPressGesture长按手势，再识别DragGesture拖拽手势
                    case .first(true):
                        print("点击")                // 因为LongPressGesture长按手势之前已经被触发了，所以这里就print打印信息供我们参考
                    case .second(true, let drag):
                        state = drag?.translation ?? .zero // 第二个被识别DragGesture拖拽手势，我们选取拖动数据并使用相应的转换更新dragOffset
                    default:
                        break
                    }
                })
                .onEnded({ currentPostion in                // 当拖动结束时，调用onEnded函数更新样式就行
                    guard case .second(true, let drag?) = currentPostion else { return }
                    self.position.height += drag.translation.height
                    self.position.width += drag.translation.width
                    self.circleColorChanged.toggle()
                    self.heartColorChanged.toggle()
                    self.heartSizeChanged.toggle()
                })
            
        )
    }
    
    func gestureDemo() -> some View {
        ZStack {
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor( circleColorChanged ? Color(.systemGray5) : .red)
            Image(systemName: "heart.fill")
                .foregroundColor(heartColorChanged ? .red : .white)
                .font(.system(size: 30))
                .scaleEffect(heartSizeChanged ? 1.0 : 0.5)
                .opacity(longPressTap ? 0.4 : 1.0)  // 心形加个透明度的效果，长按时，即longPressTap被点击时，透明度变化
        }
        .offset(x: dragOffset.width + position.width, y: dragOffset.height + position.height)      // 给整个ZSkcak视图加一个可以拖动的偏移位置
//        .gesture(TapGesture()
//            .onEnded({ _ in
//                circleColorChanged.toggle()
//                heartColorChanged.toggle()
//                heartSizeChanged.toggle()
//            }))
        .onTapGesture {                             // 要实现更加复杂的手势，我们需要引用.gesture修饰符，
                                                    // 在.gesture修饰符下我们需要实现.onTapGesture点击手势，就只需要使用TapGesture()方法
            circleColorChanged.toggle()
            heartColorChanged.toggle()
            heartSizeChanged.toggle()
        }
        .gesture(
            LongPressGesture(minimumDuration: 2.0)
                /*
                 .updating更新方法有三个参数，value、state和transaction。
                 value参数可以自定义，我们这里用的是手势的当前状态currentState，currentState当前状态表示检测到点击。
                 state参数实际上是一个in-out参数，它允许您更新longPressTap属性的值。
                 在上面的代码中，我们将state的值设置为currentState当前状态，也就是longPressTap属性需要一直跟踪长按手势的最新状态。
                 一句话概括就是：state参数存储currentState当前状态来处理updating更新的上下文
                 */
                .updating($longPressTap, body: { (currentState, state, transaction) in
                    state = currentState
                })
                .onEnded({ _ in
                    circleColorChanged.toggle()
                    heartColorChanged.toggle()
                    heartSizeChanged.toggle()
                }))
//        .onLongPressGesture(minimumDuration: 2.0) {
//            circleColorChanged.toggle()
//            heartColorChanged.toggle()
//            heartSizeChanged.toggle()
//        }
        .gesture(
            DragGesture(minimumDistance: 3, coordinateSpace: .global)
                .updating($dragOffset, body: { currentPostion, state, translation in
                    state = currentPostion.translation
                })
                .onEnded({ currentPostion in
                    position.height = currentPostion.translation.height
                    position.width = currentPostion.translation.width
                })
        )
    }
    
}
