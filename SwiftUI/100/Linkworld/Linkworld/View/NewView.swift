//
// Created by 9527 on 2022/12/6.
//

import SwiftUI

struct NewView: View {
    
    // 双向绑定方式
    @Binding var showNewView:Bool
    
    //声明环境变量
    @Environment(\.presentationMode) private var isPresented
    
    @State var platformIcon: String = "icon_juejin"
    @State var title: String = "移动端签约作者"
    @State var platformName: String = "稀土掘金技术社区"
    @State var indexURL: String = "https://juejin.cn/user/3897092103223517"
    
    var vm: ViewModel
    
    private let platforms = [
        ("稀土掘金技术社区", "12"),
        ("CSDN博客", "13"),
        ("阿里云社区", "14"),
        ("华为云社区", "15"),
    ]
    @State var selectedItem = 0
    
    private let gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                titleInputView()
                platformPicker()
                indexURLView()
                addBtn()
                Spacer()
            }
            .navigationBarTitle("添加身份卡", displayMode: .inline)
            .navigationBarItems(trailing: closeBtn())
        }
        .background(Color.white)
    }
    
    // 头衔名称输入框
    private func titleInputView() -> some View {
        TextField("请输入头衔", text: $title)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
    }
    // 平台选择器
    private func platformPicker() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: gridItemLayout) {
                ForEach(0..<platforms.count, id: \.self) { m in
                    if m == selectedItem {
                        Image(platforms[m].1)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.green, lineWidth: 4))
                    } else {
                        Image(platforms[m].1)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                            .onTapGesture {
                                selectedItem = m
                                platformIcon = platforms[m].1
                                platformName = platforms[m].0
                            }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
        .frame(maxHeight: 180)
    }
    
    // 链接地址
    private func indexURLView() -> some View {
        
        ZStack(alignment: .topLeading) {
            TextEditor(text: $indexURL)
                .font(.system(size: 17))
                .padding(15)
            if indexURL.isEmpty {
                Text("请输入主页链接")
                    .foregroundColor(Color(UIColor.placeholderText))
                    .padding(20)
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding()
        .frame(maxHeight: 240)
    }
    
    // 添加按钮
    func addBtn() -> some View {
        Button(action: {
            let newItem = Model(platformIcon: platformIcon, title: title, platformName: platformName, indexURL: indexURL)
            vm.addCard(newItem: newItem)
        }) {
            Text("添加")
                .font(.system(size: 17))
                .foregroundColor(.white)
                .bold()
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .cornerRadius(8)
                .padding(.horizontal)
        }
    }
    
    private func closeBtn() -> some View {
        Button(action: {
            showNewView.toggle()
            // isPresented.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 17))
                .foregroundColor(.blue)
        }
    }
}
