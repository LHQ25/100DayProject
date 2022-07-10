//
//  LogoView.swift
//  ColourAtla
//
//  Created by 娄汉清 on 2022/7/10.
//

import SwiftUI

struct LogoView: View {
    
    @State var logoImage: String = "applelogo"
    @State var logoColor: Color = Color.black
    @State var bgColor: Color = Color(.systemGray6)
    
    private var segmentTitle = ["背景色", "图标", "填充色"]
    @State var selectedSegment = 0
    
    private var appleSymbols = ["house.circle", "person.circle", "bag.circle", "location.circle", "bookmark.circle", "gift.circle", "globe.asia.australia.fill", "lock.circle", "pencil.circle", "link.circle"]
    
    private var gridItemLayout = [GridItem(.flexible()),
                                  GridItem(.flexible()),
                                  GridItem(.flexible()),
                                  GridItem(.flexible())]
    
    @State var cardItem: [CardModel] = []
    
    @State var showChooseImageSheet = false
    
    @State var showImagePicker: Bool = false
    @State var image: UIImage?
    
    // 加载数据
    func loadData() {
        
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            if let data = try? Data(contentsOf: url), let jsons = try? JSONDecoder().decode([CardModel].self, from: data) {
                self.cardItem = jsons
            }
        }
    }
    
    var body: some View {
        VStack {
//            TitleView
            Spacer()
            if image == nil {
                showLogoView
            }else {
                showLogoView
            }
            
            Spacer()
            
            VStack(spacing: -10) {
                segmentView
                if selectedSegment == 0 {
                    bgColorView
                }else if selectedSegment == 1 {
                    SwitchIconView
                }else {
                    LogoColorView
                }
            }
        }
        .onAppear {
            loadData()
        }
        .onTapGesture {
            print(123)
            _ = ImagePickerView(sourceType: .photoLibrary) { image in
                
                self.image = image
            }
        }
//        .sheet(isPresented: $showChooseImageSheet, content: {
////            chooseImageSheet
//            Text("action")
//        })
    }
    
    //MARK: - Sheet 弹窗
    private var chooseImageSheet: ActionSheet {
        
        return ActionSheet(title: Text("选择来源"), buttons: [.default(Text("相册"), action: {
            
        }), .cancel(Text("取消"), action: {
            
        })])
    }
    
    //MARK: - 本地图片
    private var showImageView: some View {
        Image(uiImage: image!)
            .resizable()
            .frame(width: 68, height: 68, alignment: .center)
            .clipShape(Circle())
            .padding(20)
            .background(bgColor)
            .cornerRadius(8)
            .onTapGesture {
                showChooseImageSheet.toggle()
            }
    }
    
    //MARK: - 填充色
    private var LogoColorView: some View {
        
        ScrollView {
            
            LazyVGrid(columns: gridItemLayout, spacing: 20) {
                
                ForEach(cardItem, id: \.cardColorRBG) { item in
                    Rectangle()
                        .fill(Color.Hex(item.cardBGColor))
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                        .onTapGesture {
                            logoColor = Color.Hex(item.cardBGColor)
                        }
                }
            }
        }
        .padding()
    }
    
    private var SwitchIconView: some View {
        
        ScrollView {
            
            LazyVGrid(columns: gridItemLayout, spacing: 20) {
                
                ForEach(appleSymbols.indices, id: \.self) { item in
                    Image(systemName: appleSymbols[item])
                        .font(.system(size: 30))
                        .foregroundColor(logoColor)
                        .frame(width: 80, height: 80)
                        .background(bgColor)
                        .cornerRadius(8)
                        .onTapGesture {
                            logoImage = appleSymbols[item]
                        }
                }
            }
        }
        .padding()
    }
    
    //MARK: - 背景颜色
    private var bgColorView: some View {
        ScrollView {
            
            LazyVGrid(columns: gridItemLayout, spacing: 20) {
                
                ForEach(cardItem, id: \.cardColorRBG) { item in
                    Rectangle()
                        .fill(Color.Hex(item.cardBGColor))
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                        .onTapGesture {
                            bgColor = Color.Hex(item.cardBGColor)
                        }
                }
            }
        }
        .padding()
    }
    
    //MARK: - 分选择器
    private var segmentView: some View {
        Picker("", selection: $selectedSegment) {
            ForEach(0..<3) {
                Text(self.segmentTitle[$0]).tag($0)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
    
    private var showLogoView: some View {
        Image(systemName: logoImage)
            .font(.system(size: 18))
            .foregroundColor(logoColor)
            .frame(minWidth: 80, maxWidth: 120, minHeight: 80, maxHeight: 120)
            .background(bgColor)
            .cornerRadius(8)
    }
    
    private var TitleView: some View {
        Text("Logo")
            .font(.system(size: 17))
            .fontWeight(.bold)
    }
}
