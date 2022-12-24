//
//  Haptics.swift
//  Linkworld
//
//  Created by 9527 on 2022/12/7.
//

import Foundation
import SwiftUI

// 震动反馈
struct Haptics {
    static func hapticSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    static func hapticWarning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
}
