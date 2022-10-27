//
//  AlignmentControl.swift
//  CustomTabBar
//
//  Created by 9527 on 2022/10/7.
//

import SwiftUI



struct AlignmentControl: View {
    
    @State
    var alignment: HorizontalAlignment = .leading
    @State
    var textAlignment: TextAlignment = .leading
    
    var tintColor: Color
    var baseColor: Color
    
    var body: some View {
        
        
        ZStack(alignment: Alignment(horizontal: alignment, vertical: .center)) {
            HStack(spacing: 20) {
                AlignmentButton(alignment: .leading) {
                    alignment = .leading
                    textAlignment = .leading
                }
                
                AlignmentButton(alignment: .center) {
                    alignment = .center
                    textAlignment = .center
                }
                
                AlignmentButton(alignment: .trailing) {
                    alignment = .trailing
                    textAlignment = .trailing
                }
            }
            .foregroundColor(baseColor)
            
            VStack(alignment: alignment, spacing: 4) {
                AlignmentLine()
                    .animation(.easeOut)
                AlignmentLine()
                    .frame(width: 14, height: 3, alignment: .center)
                    .cornerRadius(1.5)
                    .animation(Animation.easeOut.delay(0.03))
                AlignmentLine()
                    .animation(Animation.easeOut.delay(0.06))
                AlignmentLine()
                    .frame(width: 14, height: 3, alignment: .center)
                    .cornerRadius(1.5)
                    .animation(Animation.easeOut.delay(0.09))
            }
            .foregroundColor(tintColor)
        }
    }
}

struct AlignmentControl_Previews: PreviewProvider {
    static var previews: some View {
        AlignmentControl(tintColor: .yellow, baseColor: .red)
    }
}


struct AlignmentButton: View {
    
    var alignment: HorizontalAlignment
    var action: ()->Void
    
    var body: some View {

        Button(action: action) {
            VStack(alignment: alignment, spacing: 4) {
                AlignmentLine()
                AlignmentLine()
                    .frame(width: 14, height: 3, alignment: .center)
                    .cornerRadius(1.5)
                AlignmentLine()
                AlignmentLine()
                    .frame(width: 14, height: 3, alignment: .center)
                    .cornerRadius(1.5)
            }
        }
    }
}

struct AlignmentLine: View {
    var body: some View {
        Rectangle()
            .frame(width: 25, height: 3, alignment: .center)
            .cornerRadius(1.5)
    }
}
