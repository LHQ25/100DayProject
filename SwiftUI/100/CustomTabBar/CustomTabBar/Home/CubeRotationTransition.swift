//
//  CubeRotationTransition.swift
//  CustomTabBar
//
//  Created by 9527 on 2022/10/8.
//

import SwiftUI
import Combine

struct CubeRotationModifier: AnimatableModifier {
    
    enum SlideDirection {
        case enter
        case exit
    }
    
    var direction: SlideDirection
    
    var pct: Double
    
    var animatableData: Double {
        get { pct }
        set { pct = newValue }
    }
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            content
                .rotation3DEffect(
                    Angle(degrees: calcRotation()),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    anchor: direction == .enter ? .leading : .trailing,
                    anchorZ: 0,
                    perspective: 0.1
                ).transformEffect(.init(translationX: calcTranslation(geo: geo), y: 0))
        }
    }
    
    private func calcRotation() -> Double {
        switch direction {
        case .enter:
            return 90 - pct * 90
        case .exit:
            return -1 * pct * 90
        }
    }
    
    func calcTranslation(geo: GeometryProxy) -> CGFloat {
        if direction == .enter {
            return geo.size.width - (CGFloat(pct) * geo.size.width)
        } else {
            return -1 * (CGFloat(pct) * geo.size.width)
        }
    }
}

extension AnyTransition {
    
    static var cubeRotation: AnyTransition {
        get {
            AnyTransition.asymmetric(
                insertion: AnyTransition.modifier(active: CubeRotationModifier(direction: .enter, pct: 0), identity: CubeRotationModifier(direction: .enter, pct: 1)),
                removal: AnyTransition.modifier(active: CubeRotationModifier(direction: .exit, pct: 1), identity: CubeRotationModifier(direction: .exit, pct: 0)))
        }
    }
}

struct CubeRotationTransition: View {
    
    @State
    var index: Int = 0
    
    @State
    var timer = Timer.publish(every: 2, on: RunLoop.main, in: RunLoop.Mode.common).autoconnect()
    
    var colors: [Color] = [Color.red, Color.blue, Color.green, Color.orange, Color.purple]

    
    var body: some View {
        ZStack {
            ForEach(colors.indices, id: \.self) { i in
                if index == i {
                    colors[i]
                        .transition(.cubeRotation)
                }
            }
            
        }
        .frame(width: 200, height: 200, alignment: .center)
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 1.3)) {
                index = (index + 1) % colors.count
            }
        }
    }
}

struct CubeRotationTransition_Previews: PreviewProvider {
    static var previews: some View {
        CubeRotationTransition()
    }
}
