
import UIKit

class CALayerViewController: UIViewController {
    @IBOutlet weak var viewForLayer: UIView!
    
    let layer = CALayer()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayer()
        
        viewForLayer.layer.addSublayer(layer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplayLayerControls" {
            (segue.destination as? CALayerControlsViewController)?.layerViewController = self
        }
    }
}

// MARK: - Layer
extension CALayerViewController {
    func setUpLayer() {
        //1 将图像设置为图层的内容
        layer.frame = viewForLayer.bounds
        layer.contents = UIImage(named: "star")?.cgImage

        //图像居中放置在图层中。 您可以使用contentsGravity来更改大小（如调整大小，调整方面的大小和调整方面填充的大小）以及位置（中心，顶部，右上角，右边等）。magnificationFilter控制放大图像的行为
        // 2 决定内容在图层的边界中怎么对齐  kCAGravityResizeAspect的效果等同于UIViewContentModeScaleAspectFit， 同时它还能在图层中等比例拉伸以适应图层的边界。默认值是kCAGravityResize
        layer.contentsGravity = .center
        //扩大图片时使用的过滤器  图像放大时  使用双线性滤波 通过对多个像素取样最终生成新的值，得到一个平滑的表现不错的拉伸，但是当放大倍数比较大的时候图片就模糊不清
        layer.magnificationFilter = .linear

        // 3 CALayer的背景颜色，使其变圆并为其添加边框。 请注意，您正在使用基础CGColor对象更改图层的颜色属性
        layer.cornerRadius = 100.0
        layer.borderWidth = 12.0
        layer.borderColor = UIColor.white.cgColor
        layer.backgroundColor = swiftOrangeColor.cgColor

        //4 创建阴影。 当isGeometryFlipped为true时，位置几何形状和阴影将上下颠倒
        layer.shadowOpacity = 0.75
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 3.0
        layer.isGeometryFlipped = false
    }
}
