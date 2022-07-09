//
//  LoadingView.swift
//  ColourAtla
//
//  Created by 9527 on 2022/7/9.
//

import SwiftUI

struct LoadingView: View {
    
    @State var show: Bool = false
    
    var body: some View {
        
        Image(systemName: "sun.min.fill")
            .resizable()
            .foregroundColor(Color.Hex(0xFAD0C4))
            .aspectRatio(contentMode: .fit)
            .frame(width: 60, height: 60)
            .rotationEffect(.degrees(show ? 360 : 0))
            .onAppear {
                doAnimation()
            }
        
    }
    
    func doAnimation() {
        
        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            show.toggle()
        }
    }
    
}
