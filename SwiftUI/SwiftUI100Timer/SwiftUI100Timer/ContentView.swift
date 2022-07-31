//
//  ContentView.swift
//  SwiftUI100Timer
//
//  Created by 9527 on 2022/7/31.
//

import SwiftUI

struct ContentView: View {
    
    @State var timeText: String = "0.00"
    @State var isPause: Bool = false
    
    var body: some View {
        
        VStack {
            
            titleView()
            dinnerImageView()
            timerView()
            Spacer()
            if isPause {
                startBtn()
            }else {
                pauseAndResetBtn()
            }
        }
    }
    
    // 计时器标题
    func titleView() -> some View {
        HStack {
            Text("计时器")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
        }
    }
    
    func dinnerImageView() -> some View {
        Image(systemName: "cup.and.saucer")
            .font(.system(size: 70))
            .foregroundColor(.cyan)
    }
    
    func timerView() -> some View {
        
        Text(timeText)
            .font(.system(size: 48))
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }
    
    // 开始按钮
    func startBtn() -> some View {
        ZStack {
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(.green)
            Image(systemName: "play.fill")
                .foregroundColor(.white)
                .font(.system(size: 32))
        }
        .onTapGesture {
            isPause.toggle()
        }
    }
    
    // 暂停和复位按钮
    func pauseAndResetBtn() -> some View {
        HStack(spacing: 60) {
            // 暂停按钮
            ZStack {
                Circle()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.red)
                Image(systemName: isPause ? "play.fill" : "pause.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 32))
            }
            
            // 复位按钮
            ZStack {
                Circle()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                Image(systemName: "arrow.uturn.backward.circle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 32))
            }
        }
    }
}
