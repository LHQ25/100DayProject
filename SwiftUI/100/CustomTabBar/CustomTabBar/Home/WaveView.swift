//
//  WaveView.swift
//  CustomTabBar
//
//  Created by 9527 on 2022/10/7.
//

import SwiftUI

struct Wave: Shape {
    
    var waveHeight: CGFloat
    var phase: Angle

    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        
        for x in stride(from: 0, through: rect.width, by: 1) {
            let relativeX: CGFloat = x / 50 // waveHeight
            let sine = CGFloat(sin(relativeX + CGFloat(phase.radians)))
            let y = waveHeight * sine // + rect.idY
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return path
    }
}

struct WaveMaskModifier: AnimatableModifier {
    
    var pct: CGFloat
    
    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .mask(
                GeometryReader(content: { geo in
                    
                    VStack {
                        Spacer()
                            .background(Color.white.opacity(0.1))
                        ZStack {
                            
                            Wave(waveHeight: 30, phase: Angle(degrees: (Double(geo.frame(in: .global).minY) + 45) * -1 * 0.7))
                                .opacity(0.5)
                                .scaleEffect(x: 1.0, y: 1.2, anchor: .center)
                                .offset(x: 0, y: 30)
                            
                            Wave(waveHeight: 30, phase: Angle(degrees: Double(geo.frame(in: .global).minY) * 0.7))
                                .scaleEffect(x: 1.0, y: 1.2, anchor: .center)
                                .offset(x: 0, y: 30)
                        }
                        .frame(height: geo.size.height * pct, alignment: .bottom)
                    }
                })
            )
    }
}

extension AnyTransition {
    
    static let waveMask = AnyTransition.asymmetric(insertion: AnyTransition.modifier(active: WaveMaskModifier(pct: 0), identity: WaveMaskModifier(pct: 1)),
                                                   removal: .scale(scale: 1))
}

struct WaveView: View {
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center) {
                GeometryReader { geo in
                    ZStack {
                        Wave(waveHeight: 30, phase: Angle(degrees: (Double(geo.frame(in: .global).minY) + 45) * -1 * 0.7))
                            .foregroundColor(Color.green)
                        Wave(waveHeight: 30, phase: Angle(degrees: Double(geo.frame(in: .global).minY) * 0.7))
                            .foregroundColor(.red)
                    }
                }
                .frame(height: 70, alignment: .center)
            }
        }
    }
}

struct WaveView2: View {
    
    @State var index: Int = 0
    
    var images: [Image] = [
        Image("1"),
        Image("2"),
        Image("3"),
        Image("4"),
    ]
    
    var body: some View {
        
        ZStack {
            ForEach(images.indices, id: \.self) { i in
                if i == index {
                    images[index]
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .transition(.waveMask)
                }
            }
        }
        .onTapGesture {
            withAnimation(.easeOut(duration: 3)) {
                index = (index + 1) % images.count
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct WaveView_Previews: PreviewProvider {
    static var previews: some View {
        WaveView()
    }
}
