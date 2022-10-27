//
//  ToggleStyles.swift
//  CustomTabBar
//
//  Created by 9527 on 2022/10/7.
//

import SwiftUI

struct CheckmarkToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .foregroundColor(configuration.isOn ? .green : .gray)
                .frame(width: 51, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .padding(.all, 3)
                        .overlay(
                            Image(systemName: configuration.isOn ? "checkmark" : "xmark")
                                .aspectRatio(contentMode: .fit)
                                .font(Font.body.weight(.black))
                                .frame(width: 8, height: 8, alignment: .center)
                                .foregroundColor(configuration.isOn ? .green : .gray)
                        )
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                        .animation(.linear(duration: 0.1))
                )
                .cornerRadius(20)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}

struct PowerToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .foregroundColor(configuration.isOn ? .green : .gray)
                .frame(width: 51, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .padding(.all, 3)
                        .overlay(
                            
                            GeometryReader(content: { geo in
                                Path { p in
                                    if !configuration.isOn {
                                        p.addRoundedRect(in: CGRect(x: 10, y: 10, width: 10.5, height: 10.5), cornerSize: CGSize(width: 7.5, height: 7.5), style: .circular, transform: .identity)
                                    }else{
                                        p.move(to: CGPoint(x: geo.size.width/2.0, y: 10))
                                        p.addLine(to: CGPoint(x: geo.size.width/2.0, y: geo.size.height-10))
                                    }
                                }
                                .stroke(configuration.isOn ? Color.green: Color.gray, lineWidth: 2)
                            })
                        )
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                        .animation(.linear(duration: 0.1))
                )
                .cornerRadius(20)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}


struct ImageToggleStyle: ToggleStyle {
    
    var onImageName: String
    var offImageName: String
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Image(configuration.isOn ? onImageName : offImageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 51, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .padding(.all, 3)
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                        .animation(.linear(duration: 0.1))
                )
                .cornerRadius(20)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}


struct ToggleStylesView: View {
    
    @State
    var isOn: Bool = true
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            Toggle(isOn: $isOn) {
                Text("CheckmarkToggle")
            }
            .toggleStyle(CheckmarkToggleStyle())
            .padding()
            
            Toggle(isOn: $isOn) {
                Text("PowerToggle")
            }
            .toggleStyle(PowerToggleStyle())
            .padding()
            
            Toggle(isOn: $isOn) {
                Text("ImageToggleStyle")
            }
            .toggleStyle(ImageToggleStyle(onImageName: "1", offImageName: "2"))
            .padding()
        }
    }
}

struct ToggleStyles_Previews: PreviewProvider {
    static var previews: some View {
        ToggleStylesView()
    }
}
