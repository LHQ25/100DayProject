//
// Created by 9527 on 2022/7/12.
//

import SwiftUI

struct Model: Identifiable {

    var id = UUID()
    var imageName: String
    var color: Color
}

let sampleModels = (1...9).map({ Model(imageName: "a\($0)", color: Color.randColor)  })

extension Color {

    static var randColor = Color(.init(red: CGFloat((1...255).randomElement() ?? 1)/255.0, green: CGFloat((1...255).randomElement() ?? 1)/255.0, blue: CGFloat((1...255).randomElement() ?? 1)/255.0, alpha: 1))
}
