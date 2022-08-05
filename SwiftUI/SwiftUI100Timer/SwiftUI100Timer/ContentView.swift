//
//  ContentView.swift
//  SwiftUI100Timer
//
//  Created by 9527 on 2022/7/31.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State var timeText: String = "0.00"
    @State var isStart: Bool = false
    @State var isPause: Bool = false
    
    @State var startTime = Date()
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common)//.autoconnect()
    
    @State var cancel: AnyCancellable?
    
    var body: some View {
        
        VStack {
            
            titleView()
                .padding()
            dinnerImageView()
            timerView()
            Spacer()
            if !isPause {
                startBtnView()
            }else {
                pauseAndResetBtn()
            }
        }
    }
    
    func startTimer() {
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
        cancel = timer.autoconnect()
            .map({ "\(Int($0.timeIntervalSince1970))" })
            .assign(to: \.timeText, on: self)
    }
    
    func stopTimer() {
        
        cancel?.cancel()
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
    func startBtnView() -> some View {
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
            isStart = true
            startTimer()
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
            }.onTapGesture {
                isPause.toggle()
                isStart.toggle()
                stopTimer()
            }
            
            // 复位按钮
            ZStack {
                Circle()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                Image(systemName: "arrow.uturn.backward.circle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 32))
            }.onTapGesture {
                isPause.toggle()
                isStart.toggle()
                timeText = "0"
                stopTimer()
            }
        }
    }
}
