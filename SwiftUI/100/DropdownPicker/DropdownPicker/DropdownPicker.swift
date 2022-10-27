//
//  DropdownPicker.swift
//  DropdownPicker
//
//  Created by 9527 on 2022/10/7.
//

import SwiftUI

struct DropdownPicker: View {
    
    var title: String
    @Binding
    var selection: Int
    var options: [String]
    
    @State
    private var showOptions: Bool = false
    
    var body: some View {
        ZStack {
            HStack {
                Text(title)
                Spacer()
                Text(options[selection])
                    .foregroundColor(Color.black.opacity(0.6))
                Image(systemName: "chevron.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 10, height: 10)
            }
            .font(Font.custom("Avenir Next", size: 16).weight(.medium))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white)
            .onTapGesture {
                withAnimation(Animation.spring().speed(2)){
                    showOptions = true
                }
            }
            
            if showOptions {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(Font.custom("Avenir Next", size: 16).weight(.semibold))
                        .foregroundColor(.white)
                    HStack {
                        Spacer()
                        ForEach(options.indices, id: \.self) { i in
                            
                            if i == selection {
                                Text(options[i])
                                    .font(.system(size: 12))
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(4)
                                    .onTapGesture {
                                        withAnimation(Animation.spring().speed(2)){
                                            showOptions = false
                                        }
                                    }
                            } else {
                                Text(options[i])
                                    .font(.system(size: 12))
                                    .onTapGesture {
                                        withAnimation(Animation.spring().speed(2)){
                                            selection = i
                                            showOptions = false
                                        }
                                    }
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 2)
                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.black)
                .foregroundColor(.white)
                .transition(.opacity)
            }
        }
    }
}
