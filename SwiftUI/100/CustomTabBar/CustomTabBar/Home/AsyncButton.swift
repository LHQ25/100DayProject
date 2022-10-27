//
//  AsyncButton.swift
//  CustomTabBar
//
//  Created by 9527 on 2022/10/7.
//

import SwiftUI

struct AsyncButton<Content: View>: View {
    
    var isComplete: Bool
    let action: ()->Void
    let content: Content
    
    @State(initialValue: false)
    private var inProgress: Bool
    
    init(isComplete: Bool, action: @escaping () -> Void, @ViewBuilder label: ()->Content) {
        self.isComplete = isComplete
        self.action = action
        self.content = label()
    }
    
    var body: some View {
        
        Button {
            if !inProgress { action() }
            withAnimation(.easeInOut(duration: 0.4)) {
                inProgress = true
            }
        } label: {
            VStack(alignment: .trailing) {
                if inProgress && !isComplete {
                    ProgressView()
                        .foregroundColor(.white)
                } else if isComplete {
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 15, height: 15, alignment: .center)
                        .foregroundColor(.white)
                } else {
                    content
                }
            }
            .frame(maxWidth: isComplete || inProgress ? 50 : .infinity, maxHeight: isComplete || inProgress ? 50 : nil, alignment: .center)
            .padding(.vertical, isComplete || inProgress ? 0 : 12)
            .foregroundColor(.white)
            .background(.green)
            .cornerRadius(isComplete || inProgress ? 25 : 8)
            .font(.body.weight(.semibold))
            .padding(.all, 20)
        }
    }
}

struct AsyncButton_Previews: PreviewProvider {
    static var previews: some View {
        
        AsyncButtonShow()
    }
}


struct AsyncButtonShow: View {
    
    @State var complete: Bool = false
    @State var inProgress: Bool = false
    
    var body: some View {
        
        AsyncButton(isComplete: complete) {
            inProgress = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    complete = true
                }
            }
        } label: {
            Text(complete || inProgress ? "" : "Submit")
        }

    }
}
