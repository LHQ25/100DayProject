//
//  UserDefaultsTest.swift
//  Codable_project
//
//  Created by 9527 on 2022/8/3.
//

import Foundation


/*
 在此之前我们一直在用 Codable 来处理 JSON。 Codable 的一个优势是它对于支持 Encoder 或 Decoder 的任何格式的数据的支持都一样好。
 Foundation 框架提供了内建的属性列表 property list 的编码解码器（PropertyListDecoder 和 PropertyListEncoder）。

 看看属性列表 property list 如何配合使用 Codable 加载库存，以及如何使用 UserDefaults 进行订单数据持久化
 */
struct UserDefaultsTest {
    
    static func loadData() {
        
        guard let url = Bundle.main.url(forResource: "Inventory", withExtension: ".plist") else {
            fatalError("Inventory.plist missing from main bundle")
        }
        
        var inventory: [Item]
        do {
            let data = try Data(contentsOf: url)

            let decoder = PropertyListDecoder()
            let plist = try decoder.decode([String: [Item]].self, from: data)
            inventory = plist["items"]!
            
            
            let order = Order(seat: "32", itemCounts: [(1, inventory.first!)])
            
            let encoder = PropertyListEncoder()
            UserDefaults.standard.set(try encoder.encode([order]), forKey: "Orders")
            
            
            print(order)
        } catch {
            fatalError("Cannot load inventory \(error)")
        }
    }
    
    
}

struct Item: Codable {
    var name: String
    var unitPrice: Int
}

struct Order: Codable {
    var seat: String

    struct LineItem: Codable {
        var item: Item
        var count: Int

        var price: Int {
            return item.unitPrice * count
        }
    }

    var lineItems: [LineItem]

    let creationDate: Date = Date()
    
    
    static func loadOrder() {
        
        var oders: [Order]?
        // 如果指定的键不存在，object(forKey:) 会返回 nil。在应用启动之后使用 registerDefaults 方法来设定初始值，就可以减少这个地方的复杂度了
        if let data = UserDefaults.standard.object(forKey: "Orders") as? Data {
            let decoder = PropertyListDecoder()
            
            do {
                oders = try decoder.decode([Order].self, from: data)
                print(oders)
            } catch  {
                print(error)
            }
        }
    }
    
    static func delOrder() {
        UserDefaults.standard.removeObject(forKey: "Orders")
    }
}

extension Order {
    
    init(seat: String, itemCounts: [(Int, Item)]) {
//        var lineItems: [LineItem] = []
//        for (count, item) in itemCounts {
//           guard count > 0 else { continue }
//           let lineItem = LineItem(item: item, count: count)
//           lineItems.append(lineItem)
//        }
        
        let lineItems = itemCounts.compactMap({ LineItem(item: $1, count: $0) })
        
        self.seat = seat
        self.lineItems = lineItems
    }
    
    func getTotalPrice() -> Int {
        lineItems.map{ $0.price }.reduce(0, +)
    }
}
