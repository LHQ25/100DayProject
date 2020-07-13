
import UIKit

class CAReplicatorLayerViewController: UIViewController {
    @IBOutlet weak var viewForReplicatorLayer: UIView!
    @IBOutlet weak var layerSizeSlider: UISlider!
    @IBOutlet weak var layerSizeSliderValueLabel: UILabel!
    @IBOutlet weak var instanceCountSlider: UISlider!
    @IBOutlet weak var instanceCountSliderValueLabel: UILabel!
    @IBOutlet weak var instanceDelaySlider: UISlider!
    @IBOutlet weak var instanceDelaySliderValueLabel: UILabel!
    @IBOutlet weak var offsetRedSwitch: UISwitch!
    @IBOutlet weak var offsetGreenSwitch: UISwitch!
    @IBOutlet weak var offsetBlueSwitch: UISwitch!
    @IBOutlet weak var offsetAlphaSwitch: UISwitch!
    
    let lengthMultiplier: CGFloat = 3.0
    let replicatorLayer = CAReplicatorLayer()
    let instanceLayer = CALayer()
    let fadeAnimation = CABasicAnimation(keyPath: "opacity")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpReplicatorLayer()
        setUpInstanceLayer()
        setUpLayerFadeAnimation()
        instanceDelaySliderChanged(instanceDelaySlider)
        updateLayerSizeSliderValueLabel()
        updateInstanceCountSliderValueLabel()
        updateInstanceDelaySliderValueLabel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpReplicatorLayer()
        setUpInstanceLayer()
    }
}

// MARK: - Layer setup
extension CAReplicatorLayerViewController {
    func setUpReplicatorLayer() {
        // 1
        replicatorLayer.frame = viewForReplicatorLayer.bounds

        // 2 创建的复制数量以及两次创建之间的时间延迟。
        let count = instanceCountSlider.value
        replicatorLayer.instanceCount = Int(count)
        replicatorLayer.instanceDelay = CFTimeInterval(instanceDelaySlider.value / count)

        // 3 定义所有复制实例的基础颜色以及要添加到每个颜色组件的增量值。 每个默认值均为0，可有效保留所有实例的颜色值。 但是，在这种情况下，实例颜色最初设置为白色。 这意味着红色，绿色和蓝色已经是1.0。 例如，如果将红色设置为0，并将绿色和蓝色设置为负数，则红色将成为突出的颜色。 同样，将alpha偏移量添加到每个连续复制实例的alpha中。
        replicatorLayer.instanceColor = UIColor.white.cgColor
        replicatorLayer.instanceRedOffset = offsetValueForSwitch(offsetRedSwitch)
        replicatorLayer.instanceGreenOffset = offsetValueForSwitch(offsetGreenSwitch)
        replicatorLayer.instanceBlueOffset = offsetValueForSwitch(offsetBlueSwitch)
        replicatorLayer.instanceAlphaOffset = offsetValueForSwitch(offsetAlphaSwitch)

        //4 旋转每个实例以创建一个圆形效果
        let angle = Float.pi * 2.0 / count
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)

        //5
        viewForReplicatorLayer.layer.addSublayer(replicatorLayer)
    }
    
    func setUpInstanceLayer() {
        let layerWidth = CGFloat(layerSizeSlider.value)
        let midX = viewForReplicatorLayer.bounds.midX - layerWidth / 2.0
        instanceLayer.frame = CGRect(x: midX, y: 0.0, width: layerWidth, height: layerWidth * lengthMultiplier)
        instanceLayer.backgroundColor = UIColor.white.cgColor
        replicatorLayer.addSublayer(instanceLayer)
    }
    
    func setUpLayerFadeAnimation() {
        fadeAnimation.fromValue = 1.0
        fadeAnimation.toValue = 0.0
        fadeAnimation.repeatCount = Float(Int.max)
    }
}

// MARK: - IBActions
extension CAReplicatorLayerViewController {
    //MARK: - 复制Layer尺寸改变
    @IBAction func layerSizeSliderChanged(_ sender: UISlider) {
        let value = CGFloat(sender.value)
        instanceLayer.bounds = CGRect(origin: .zero, size: CGSize(width: value, height: value * lengthMultiplier))
        updateLayerSizeSliderValueLabel()
    }
    //MARK: - 复制Layer数量改变
    @IBAction func instanceCountSliderChanged(_ sender: UISlider) {
        replicatorLayer.instanceCount = Int(sender.value)
        replicatorLayer.instanceAlphaOffset = offsetValueForSwitch(offsetAlphaSwitch)
        updateInstanceCountSliderValueLabel()
    }
    //MARK: - 复制Layer延迟创建时间
    @IBAction func instanceDelaySliderChanged(_ sender: UISlider) {
        if sender.value > 0.0 {
            replicatorLayer.instanceDelay = CFTimeInterval(sender.value / Float(replicatorLayer.instanceCount))
            setLayerFadeAnimation()
        } else {
            replicatorLayer.instanceDelay = 0.0
            instanceLayer.opacity = 1.0
            instanceLayer.removeAllAnimations()
        }
        
        updateInstanceDelaySliderValueLabel()
    }
    //MARK: - 复制Layer  红绿蓝透明度改变
    @IBAction func offsetSwitchChanged(_ sender: UISwitch) {
        switch sender {
        case offsetRedSwitch:
            replicatorLayer.instanceRedOffset = offsetValueForSwitch(sender)
        case offsetGreenSwitch:
            replicatorLayer.instanceGreenOffset = offsetValueForSwitch(sender)
        case offsetBlueSwitch:
            replicatorLayer.instanceBlueOffset = offsetValueForSwitch(sender)
        case offsetAlphaSwitch:
            replicatorLayer.instanceAlphaOffset = offsetValueForSwitch(sender)
        default:
            break
        }
    }
}

// MARK: - Triggered actions
extension CAReplicatorLayerViewController {
    func setLayerFadeAnimation() {
        instanceLayer.opacity = 0.0
        fadeAnimation.duration = CFTimeInterval(instanceDelaySlider.value)
        instanceLayer.add(fadeAnimation, forKey: "FadeAnimation")
    }
}

// MARK: - Helpers
extension CAReplicatorLayerViewController {
    func offsetValueForSwitch(_ offsetSwitch: UISwitch) -> Float {
        if offsetSwitch == offsetAlphaSwitch {
            let count = Float(replicatorLayer.instanceCount)
            return offsetSwitch.isOn ? -1.0 / count : 0.0
        } else {
            return offsetSwitch.isOn ? 0.0 : -0.05
        }
    }
    
    func updateLayerSizeSliderValueLabel() {
        let value = layerSizeSlider.value
        layerSizeSliderValueLabel.text = String(format: "%.0f x %.0f", value, value * Float(lengthMultiplier))
    }
    
    func updateInstanceCountSliderValueLabel() {
        instanceCountSliderValueLabel.text = String(format: "%.0f", instanceCountSlider.value)
    }
    
    func updateInstanceDelaySliderValueLabel() {
        instanceDelaySliderValueLabel.text = String(format: "%.0f", instanceDelaySlider.value)
    }
}
