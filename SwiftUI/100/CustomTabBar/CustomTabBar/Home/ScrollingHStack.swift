//
//  ScrollingHStack.swift
//  CustomTabBar
//
//  Created by 9527 on 2022/10/7.
//

import SwiftUI

struct ScrollingHStack: View {
    
    var colors: [Color] = [.blue, .green, .red]//, .orange]
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 30) {
            
            ForEach(colors.indices, id: \.self) { i in
                colors[i]
                    .frame(width: 250, height: 400, alignment: .center)
                    .cornerRadius(10)
            }
        }
        .modifier(ScrollingHStackModifier(items: colors.count, itemWidth: 250, itemSpacing: 30))
    }
}

struct ScrollingHStack_Previews: PreviewProvider {
    static var previews: some View {
        ScrollingHStack()
    }
}

struct ScrollingHStackModifier: ViewModifier {
    
    @State
    private var scrollOffset: CGFloat
    @State
    private var dragOffset: CGFloat
    
    var items: Int
    var itemWidth: CGFloat
    var itemSpacing: CGFloat
    
    init(items: Int, itemWidth: CGFloat, itemSpacing: CGFloat) {
        self.items = items
        self.itemWidth = itemWidth
        self.itemSpacing = itemSpacing
        
        
        let contentWidth = CGFloat(items) * itemWidth + CGFloat(items - 1) * itemSpacing
        let screenWidth = UIScreen.main.bounds.width
        
        let initiaOffset: CGFloat = (contentWidth / 2.0) + (screenWidth - itemWidth) / 2.0 - (itemWidth / 2.0) - itemSpacing
        
        debugPrint(contentWidth, initiaOffset)
        
        self._scrollOffset = State(initialValue: initiaOffset)
        self._dragOffset = State(initialValue: 0)
    }
    
    func body(content: Content) -> some View {
        
        content
            .offset(x: scrollOffset + dragOffset, y: 0)
            .gesture(
                DragGesture()
                    .onChanged({ event in
                        dragOffset = event.translation.width
                    })
                    .onEnded({ event in
                        scrollOffset += event.translation.width
                        dragOffset = 0

                        let contentWidth = CGFloat(items) + itemWidth + CGFloat(items - 1) * itemSpacing
                        let screenWidth = UIScreen.main.bounds.width

                        let center = scrollOffset + (screenWidth / 2.0) + (contentWidth / 2.0)

                        var index = (center - (screenWidth / 2.0)) / (itemWidth + itemSpacing)

                        if index.remainder(dividingBy: 1) > 0.5 {
                            index += 1
                        }else{
                            index = CGFloat(Int(index))
                        }

                        index = max(0, min(index, CGFloat(items) - 1))

                        let newOffset = index * itemWidth + (index - 1) * itemSpacing - (contentWidth / 2.0) + (screenWidth / 2.0) - ((screenWidth - itemWidth) / 2.0) + itemSpacing

                        withAnimation {
                            scrollOffset = newOffset
                        }
                    })

            )
    }
}
