//
//  ContentView.swift
//  SwiftUI100Sentence
//
//  Created by 9527 on 2022/7/31.
//

import SwiftUI

struct ContentView: View {
    
    @State var sentenceText = "外表干净是尊重别人，内心干净是尊重自己，言行干净是尊重灵魂。"
    
    
    private var models = [
        "你的能力是否能在全世界通用，如果不能，那么需要重新评估你的能力。",
        "将自身所学回馈社会，不也是一件幸福的事么。",
        "当你作为演讲者时，你要装作自己是最了不起的一个人。而当你作为倾听者时，也请一定要装作自己什么也不懂。",
        "当需要你提出建议时，就应该要畅所欲言，不要将想法锁在自己脑子里。",
        "一个人若没有深厚的知识积累，就无法轻易说出自己到底喜欢什么。",
        "通过沉浸思考，不断积累，就能逐步踏实地将一些知识转变为自己的东西。",
        "外表干净是尊重别人，内心干净是尊重自己，言行干净是尊重灵魂。",
        "人的精神思想方面的优势越大，给无聊留下的空间就越小。"
    ]
    
    var body: some View {
        
        ZStack {
            Color(red: 67 / 255, green: 71 / 255, blue: 224 / 255)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                titleView()
                Spacer()
                sentenceView()
                Spacer()
                refreshView()
            }
            .padding()
        }
    }
    
    
    func titleView() -> some View {
        HStack {
            Text("每日一句")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
        }
    }
    
    func sentenceView() -> some View {
        
        Text(sentenceText)
            .foregroundColor(Color(.systemGray))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 200)
            .padding()
            .background(.white)
            .cornerRadius(8)
    }
    
    func refreshView() -> some View {
        
        Image(systemName: "repeat.circle.fill")
            .font(.system(size: 32))
            .foregroundColor(.white)
            .padding()
            .onTapGesture {
                sentenceText = models.randomElement() ?? ""
            }
    }
}
