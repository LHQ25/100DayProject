//
//  ContentView.swift
//  SwiftUISwipeCard
//
//  Created by 9527 on 2022/7/15.
//

import SwiftUI

/* 使用Gestures手势和Animations动画实现SwipeCard卡片滑动的效果 */
struct ContentView: View {
    
    @State var albums: [Album] = []
    
    @GestureState
    private var dragState = DragState.inactive
    @State
    private var offset: CGFloat = .zero
    
    private let dragPosition: CGFloat = 80.0
    
    //转场类型动画
    @State private var removalTransition = AnyTransition.trailingBottom
    
    var body: some View {
        
        VStack {
            TopBarMenu()
            
            ZStack {
                ForEach(albums) { album in
                    CardView(image: album.image, name: album.name)
                    
                        // SwiftUI提供了zIndex修饰符来来确定ZStack中视图的顺序，zIndex值越高，视图层级也就越高
                        .zIndex(isTopCard(cardView: album) ? 1 : 0)
                    
                        //判断喜欢或者不喜欢
                        .overlay(
                            ZStack(content: {
                                Image(systemName: "hand.thumbsdown.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 100))
                                    .opacity(self.dragState.translation.width < -self.dragPosition && self .isTopCard(cardView: album) ? 1.0 : 0)
                                
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 100))
                                .opacity(self.dragState.translation.width > self.dragPosition && self .isTopCard(cardView: album) ? 1.0 : 0.0)
                            })
                        )
                        
                        // 偏移
                        .offset(x: isTopCard(cardView: album) ? dragState.translation.width : 0, y: isTopCard(cardView: album) ? dragState.translation.height : 0)
                        // 旋转
                        .rotationEffect(Angle(degrees: isTopCard(cardView: album) ? Double(dragState.translation.width / 10) : 0))
                    
                        // 缩放
                        .scaleEffect( dragState.isDragging && isTopCard(cardView: album) ? 0.95 : 1)
                    
                        // 动画
                        .animation(.interpolatingSpring(stiffness: 180, damping: 100), value: offset)
                    
                        // 转场类型动画
                        .transition(removalTransition)
                    
                        // 手势
                        .gesture(
                            LongPressGesture()
                                .sequenced(before: DragGesture())
                                .updating($dragState, body: { value, state, transaction in
                                    switch value {
                                    case .first:
                                        state = .pressing
                                    case let .second(true, drag):
                                        state = .dragging(tanslation: drag?.translation ?? .zero)
                                    default:
                                        break
                                    }
                                })
                                .onChanged({ value in
                                    guard case .second(true, let drag?) = value else {
                                        return
                                    }
                                    if drag.translation.width < -dragPosition {
                                        removalTransition = .leadingBottom
                                    }
                                    
                                    if drag.translation.width > dragPosition {
                                        removalTransition = .trailingBottom
                                    }
                                })
                                .onEnded({ value in
                                    guard case .second(true, let drag?) = value else {
                                        return
                                    }
                                    
                                    if drag.translation.width < -self.dragPosition || drag.translation.width > self.dragPosition {
                                        self.updateItes(id: album.id)
                                    }
                                })
                        )
                        
                }
            }.onAppear {
                albums.append(contentsOf: data.prefix(2))
            }
           
            Spacer(minLength: 20)
            BottomBarMenu(delAction: {
                // self.dragState = .dragging(tanslation: CGSize(width: -81, height: 0))
            }, heartAction: {
                // self.dragState = .dragging(tanslation: CGSize(width: 81, height: 0))
            })
            .opacity(dragState.isDragging ? 0 : 1)  // 左右滑动CardView卡片视图时，隐藏BottomBarMenu底部导航栏
            .animation(.default, value: offset)
        }
    }
    
    func isTopCard(cardView: Album) -> Bool {
        guard let index = albums.firstIndex(where: { $0.id == cardView.id }) else { return false }
        return index == 0
    }
    
    func updateItes(id: UUID) {
        guard let index = data.firstIndex(where: { $0.id == id }) else { return }
        albums.removeFirst()
        
        if (index + 2) < data.count {
            albums.append(data[index + 2])
        }else {
            albums.append(data[(index + 2)%10])
        }
    }
    
    //创建演示数据
    var data = [
        Album(name: "image01", image: "1"),
        Album(name: "image02", image: "2"),
        Album(name: "image03", image: "3"),
        Album(name: "image04", image: "4"),
        Album(name: "image05", image: "5"),
        Album(name: "image06", image: "6"),
        Album(name: "image07", image: "7"),
        Album(name: "image08", image: "8"),
        Album(name: "image09", image: "9"),
        Album(name: "image10", image: "10")
    ]
}

//创建Album定义变量
struct Album: Identifiable {
    var id = UUID()
    var name: String
    var image: String
}


//MARK: - Transition转场动画
extension AnyTransition {
    
    static var trailingBottom: AnyTransition {
        AnyTransition.asymmetric(insertion: .identity, removal: .move(edge: .trailing).combined(with: .move(edge: .bottom)))
    }
    
    static var leadingBottom: AnyTransition {
        AnyTransition.asymmetric(insertion: .identity, removal: .scale(scale: 1.5).combined(with: .move(edge: .leading).combined(with: .move(edge: .bottom)) ))
    }
}


enum DragState {
    case inactive
    case pressing
    case dragging(tanslation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive, .pressing:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .dragging:
            return true
        case .pressing, .inactive:
            return false
        }
    }
    
    var isPressing: Bool {
        switch self {
        case .pressing, .dragging:
            return true
        case .inactive:
            return false
        }
    }
}
