//
//  ViewModel.swift
//  Linkworld
//
//  Created by 9527 on 2022/12/7.
//

import SwiftUI
import Foundation

class ViewModel: ObservableObject {
    
    private let JsonURL = "http://192.168.17.171:8000/test"
    
    @Published var models = [Model]()
    
    //网络请求
    func getData() {
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: JsonURL)!) { data, _, _ in
            guard let jsonData = data else { return }
            DispatchQueue.main.async {
                do {
                    let data = try JSONDecoder().decode([Model].self, from: jsonData)
                    self.models = data
                } catch {
                    print(error)
                }
            }
        }
        .resume()
    }
    
    // 创建身份卡
    func addCard(newItem: Model) {
        models.append(newItem)
    }
    
    // 删除身份卡片
    func deleteItem(itemId: UUID) {
        models.removeAll(where: {$0.id == itemId})
    }
    
    // 获得数据项的UUID
    func getItemById(itemId: UUID) -> Model? {
        return models.first(where: { $0.id == itemId }) ?? nil
    }
}
