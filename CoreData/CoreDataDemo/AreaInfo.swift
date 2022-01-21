//
//  Area.swift
//  CoreDataDemo
//
//  Created by 娄汉清 on 2022/1/6.
//

import Foundation

struct AreaTotalModel: Decodable {
    
    let list: [AreaModel]
}

struct AreaModel: Decodable {
    
    var title: String
    var enTitle: String
    var areaId: String
    var faid: String = "0"
    
    var child: [AreaModel] = []
    
    enum CodingKeys: String, CodingKey {
        case title, enTitle, areaId, child
    }

    init(title: String, enTitle: String, areaId: String, child: [AreaModel]) {
        self.title = title
        self.enTitle = enTitle
        self.areaId = areaId
        self.child = child
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let title = try container.decode(String.self, forKey: .title)
        
        var enTitle = ""
        if container.contains(.enTitle) {
            enTitle = try container.decode(String.self, forKey: .enTitle)
        }
        
        let areaId = try container.decode(String.self, forKey: .areaId)
        
        var child: [AreaModel] = []
        if container.contains(.child) {
            child = try container.decode([AreaModel].self, forKey: .child)
        }
        
        self.init(title: title, enTitle: enTitle, areaId: areaId, child: child)
    }
}
