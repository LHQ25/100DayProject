//
//  Model.swift
//  SolidColor
//
//  Created by 9527 on 2022/7/31.
//

import SwiftUI

struct Model: Identifiable {
    
    var id = UUID()
    var colorName: String
    var color: Color
    var colorRGBName: String
}
