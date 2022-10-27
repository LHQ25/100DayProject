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

// MARK: - 模糊滤镜
/// 模糊
/// - Parameter radius:
/// - Returns:
func blur(radius: Double) -> Filter {

    { image in
        let parameters: [String: Any] = [kCIInputRadiusKey: radius, kCIInputImageKey: image]

        guard let filter = CIFilter(name: "CIGaussianBlur", parameters: parameters) else {
            fatalError()
        }

        guard let outputImage = filter.outputImage else {
            fatalError()
        }
        return outputImage
    }
}

// MARK: - 颜色叠层滤镜
// Core Image 默认不包含这样一个滤镜，但是我们完全可以用已经存在的滤镜来组成它。
// 使用的两个基础组件：颜色生成滤镜 (CIConstantColorGenerator) 和图像覆盖合成滤镜 (CISourceOverCompositing)

// 颜色生成滤镜
func generate(color: UIColor) -> Filter {
    { _ in
        let color = CIColor(cgColor: color.cgColor)
        let parameter: [String: Any] = [kCIInputColorKey: color]
        guard let filter = CIFilter(name: "CIConstantColorGenerator", parameters: parameter) else { fatalError() }
        guard let outputImage = filter.outputImage else { fatalError() }
        return outputImage
    }
}

// 图像覆盖合成滤镜（CISourceOverCompositing）
func compositeSourceOver(overlay: CIImage) -> Filter {

    { image in
        let parameter: [String: Any] = [kCIInputBackgroundImageKey: image, kCIInputImageKey: overlay]
        guard let filter = CIFilter(name: "CISourceOverCompositing", parameters: parameter) else { fatalError() }
        guard let outputImage = filter.outputImage else { fatalError() }
        return outputImage.cropped(to: image.extent)
    }
}

/// 颜色叠层滤镜
/// - Parameter color:
/// - Returns:
func overLay(color: UIColor) -> Filter {
    { image in
        let overlay = generate(color: color)(image).cropped(to: image.extent)
        return  compositeSourceOver(overlay: overlay)(image)
    }
}

// MARK: - 组合滤镜
//复合函数
func compose(filtr filter1: @escaping Filter, with filter2: @escaping Filter) -> Filter {
    { image in
        filter2(filter1(image))
    }
}

// MARK: - 运算符重载方式
infix operator >>>
func >>>(filter1: @escaping Filter, filter2: @escaping Filter) -> Filter {
    { image in
        filter2(filter1(image))
    }
}

func test() -> UIImage {

    let image =  CIImage(cgImage: UIImage(named: "11")!.cgImage!)
    let radius = 5.0
    let color = UIColor.red.withAlphaComponent(0.2)
    
    // 直接使用
//    let blurredImage = blur(radius: radius)(image)
//    let overlaidImage = overLay(color: color)(blurredImage)
    
    // 复合函数  看着就很费劲
//    let overlaidImage = overLay(color: color)(blur(radius: radius)(image))
    
//    let overlaidImage = compose(filtr: blur(radius: radius), with: overLay(color: color))(image)
    
    let overlaidImage = (blur(radius: radius) >>> overLay(color: color))(image)
    return UIImage(ciImage: overlaidImage)
}
