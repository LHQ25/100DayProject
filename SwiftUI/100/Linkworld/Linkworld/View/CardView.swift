//
// Created by 9527 on 2022/12/6.
//

import SwiftUI

struct CardView: View {
    
    var platformIcon: String
    var title: String
    var platformName: String
    var indexURL: String
    
    @State var viewState = CGSize.zero
    @State var valueToBeDeleted: CGFloat = -75
    @State var readyToBeDeleted: Bool = false
    
    @State var showDeleteAlert: Bool = false
    
    var viewModel: ViewModel
    var itemId: UUID
    var item: Model? {
        return viewModel.getItemById(itemId: itemId)
    }
    
    var body: some View {
        
        HStack(spacing: 15) {
            Image(platformIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48, height: 48)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 5){
                Text(title)
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                Text(platformName)
                    .font(.system(size: 14))
            }
            Spacer()
        }
        .foregroundColor(Color.black)
        .padding()
        .frame(maxHeight: 80)
        .cornerRadius(8)
        // 滑动删除
        .background(withAnimation(.linear(duration: 0.2),{
            self.readyToBeDeleted ? Color(.systemRed) : .white
        }))
        .offset(x: viewState.width < 0 ? viewState.width : 0)
        .gesture(
            DragGesture()
                .onChanged({ value in
                    viewState = value.translation
                    readyToBeDeleted = viewState.width < valueToBeDeleted ? true : false
                })
                .onEnded({ value in
                    if viewState.width < valueToBeDeleted {
                        Haptics.hapticWarning()
                        showDeleteAlert = true
                    }
                    viewState = .zero
                    readyToBeDeleted = false
                })
        )
        .alert(isPresented: $showDeleteAlert) {
            deleteAlert
        }
    }
    
    // 删除弹窗
    private var deleteAlert: Alert {
        let alert = Alert(title: Text(""), message: Text("确定要删除吗？"), primaryButton: .destructive(Text("确认")) {
            viewModel.deleteItem(itemId: itemId)
        }, secondaryButton: .cancel(Text("取消")))
        return alert
    }
}
