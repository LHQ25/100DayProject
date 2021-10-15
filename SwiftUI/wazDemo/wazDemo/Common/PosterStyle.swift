//
//  PosterStyle.swift
//  wazDemo
//
//  Created by cbkj on 2021/7/16.
//

import SwiftUI

struct PosterStyle: ViewModifier {
    enum Size {
        case small, medium, big, tv
        case customSize(size: CGSize)
        
        func width() -> CGFloat {
            switch self {
            case .small: return 53
            case .medium: return 100
            case .big: return 250
            case .tv: return 333
            case let .customSize(size: s): return s.width
            }
        }
        func height() -> CGFloat {
            switch self {
            case .small: return 80
            case .medium: return 150
            case .big: return 375
            case .tv: return 500
            case let .customSize(size: s): return s.height
            }
        }
    }
    
    let loaded: Bool
    let size: Size
    
    func body(content: Content) -> some View {
        return content
            .frame(width: size.width(), height: size.height())
            .cornerRadius(5)
            .opacity(loaded ? 1 : 0.1)
            .shadow(radius: 8)
    }
}

extension View {
    func posterStyle(loaded: Bool, size: PosterStyle.Size) -> some View {
        return ModifiedContent(content: self, modifier: PosterStyle(loaded: loaded, size: size))
    }
}