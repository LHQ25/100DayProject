//
// Created by 9527 on 2022/12/6.
//

import SwiftUI
import Foundation

struct Model: Identifiable, Codable {
    var id = UUID()
    var platformIcon: String
    var title: String
    var platformName: String
    var indexURL: String
    
    enum CodingKeys: String, CodingKey {
        case platformIcon, title, platformName, indexURL
    }
}
