
import UIKit

class CAEmitterLayerViewController: UIViewController {
    @IBOutlet weak var viewForEmitterLayer: UIView!
    
    @objc var emitterLayer = CAEmitterLayer()
    @objc var emitterCell = CAEmitterCell()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpEmitterCell()
        setUpEmitterLayer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //    if segue.identifier == "DisplayEmitterControls" {
        //      (segue.destination as? CAEmitterLayerControlsViewController)?.emitterLayerViewController = self
        //    }
    }
}

// MARK: - Layer setup
extension CAEmitterLayerViewController {
    func setUpEmitterLayer() {
        // 1 重置图层并将其添加到视图中。
        resetEmitterCells()
        emitterLayer.frame = viewForEmitterLayer.bounds
        viewForEmitterLayer.layer.addSublayer(emitterLayer)
         
        // 2 该层的随机数生成器提供种子。 反过来，这会随机化层的发射器单元的某些属性，例如速度
        emitterLayer.seed = UInt32(Date().timeIntervalSince1970)
        
        // 3 发射器位置
        emitterLayer.emitterPosition = CGPoint(x: viewForEmitterLayer.bounds.midX * 1.5, y: viewForEmitterLayer.bounds.midY)
        
        // 4 定义粒子单元如何渲染到图层中
        emitterLayer.renderMode = .additive
    }
    
    func setUpEmitterCell() {
        // 1 将发射器单元的内容设置为图像来设置发射器单元
        emitterCell.contents = UIImage(named: "smallStar")?.cgImage
            
        // 2 VelocityRange指定初始速度和最大方差。发射器层使用上述种子创建随机数生成器。随机数生成器通过使用初始值加上和减去范围值来随机化范围内的值。对于以Range结尾的所有属性，都会发生这种随机化
        emitterCell.velocity = 50.0
        emitterCell.velocityRange = 500.0
            
        // 3 将颜色设置为黑色。这样可以使方差与默认的白色不同，从而导致粒子过亮
        emitterCell.color = UIColor.black.cgColor

        // 4 velocityRange相同的随机化设置一系列颜色范围。这次，随机化指定每种颜色的方差范围。速度值决定了每种颜色在单元的整个生命周期内变化的速度
        emitterCell.redRange = 1.0
        emitterCell.greenRange = 1.0
        emitterCell.blueRange = 1.0
        emitterCell.alphaRange = 0.0
        emitterCell.redSpeed = 0.0
        emitterCell.greenSpeed = 0.0
        emitterCell.blueSpeed = 0.0
        emitterCell.alphaSpeed = -0.5
        emitterCell.scaleSpeed = 0.1
            
        // 5 指定如何在整个圆锥周围分布像元。您可以通过设置发射器单元的旋转速度和发射范围来实现。 missionRange定义以弧度指定的圆锥。 missionRange确定如何在锥体周围分布发射器单元
        let zeroDegreesInRadians = degreesToRadians(0.0)
        //弧度的旋转速度
        emitterCell.spin = degreesToRadians(130.0)
        emitterCell.spinRange = zeroDegreesInRadians
        emitterCell.emissionLatitude = zeroDegreesInRadians
        emitterCell.emissionLongitude = zeroDegreesInRadians
        emitterCell.emissionRange = degreesToRadians(360.0)
            
        // 6 寿命设置为1秒。该属性的默认值为0，因此，如果您未显式设置它，则永远不会显示单元格！每秒的bornRate也是如此。 birthRate的默认值为0，因此必须将其设置为正数才能显示单元格。
        emitterCell.lifetime = 1.0
        emitterCell.birthRate = 250.0

        // 7 单元格x和y的加速度。这些值会影响粒子发射的视角
        emitterCell.xAcceleration = -800
        emitterCell.yAcceleration = 1000
    }
    
    func resetEmitterCells() {
        emitterLayer.emitterCells = nil
        emitterLayer.emitterCells = [emitterCell]
    }
}

// MARK: - Triggered actions
extension CAEmitterLayerViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: viewForEmitterLayer) {
            emitterLayer.emitterPosition = location
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: viewForEmitterLayer) {
            emitterLayer.emitterPosition = location
        }
    }
}
