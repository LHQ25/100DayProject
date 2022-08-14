//
//  CoreImageTest.swift
//  函数式Swift
//
//  Created by 9527 on 2022/8/12.
//

import UIKit
import Foundation
import CoreImage

typealias Filter = (CIImage) -> CIImage

func blur(raudius: Double) -> Filter {
    
    return { image in
        let parameters: [String: Any] = [kCIInputRadiusKey: raudius, kCIInputImageKey: image]
        
        guard let filter = CIFilter(name: "CIGaussianBlur", parameters: parameters) else {
            fatalError()
        }
        
        guard let outputImage = filter.outputImage else {
            fatalError()
        }
        return outputImage
    }
}


func generate(color: UIColor) -> Filter {
    return { _ in
        let parameter: [String: Any] = [kCIInputColorKey: color.cgColor]
        guard let filter = CIFilter(name: "CIConstantCOlorGenerator", parameters: parameter) else { fatalError() }
        guard let outputImage = filter.outputImage else { fatalError() }
        return outputImage
    }
}

func compositeSourceOver(overlay: CIImage) -> Filter {
    
    return { image in
        let parameter: [String: Any] = [kCIInputBackgroundImageKey: image, kCIInputImageKey: overlay]
        guard let filter = CIFilter(name: "CISourceOverCompositing", parameters: parameter) else { fatalError() }
        guard let outputImage = filter.outputImage else { fatalError() }
        return outputImage.cropped(to: image.extent)
        
    }
}
func test() {
    
    let blurFilter = blur(raudius: 3)
    let colorFilter = generate(color: .red)
    
}
