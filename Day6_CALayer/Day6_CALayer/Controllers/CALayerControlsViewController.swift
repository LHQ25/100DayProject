

import UIKit

class CALayerControlsViewController: UITableViewController {
    @IBOutlet weak var contentsGravityPickerValueLabel: UILabel!
    @IBOutlet weak var contentsGravityPicker: UIPickerView!
    @IBOutlet var switches: [UISwitch]!
    @IBOutlet var sliderValueLabels: [UILabel]!
    @IBOutlet var sliders: [UISlider]!
    @IBOutlet weak var borderColorSlidersValueLabel: UILabel!
    @IBOutlet var borderColorSliders: [UISlider]!
    @IBOutlet weak var backgroundColorSlidersValueLabel: UILabel!
    @IBOutlet var backgroundColorSliders: [UISlider]!
    @IBOutlet weak var shadowOffsetSlidersValueLabel: UILabel!
    @IBOutlet var shadowOffsetSliders: [UISlider]!
    @IBOutlet weak var shadowColorSlidersValueLabel: UILabel!
    @IBOutlet var shadowColorSliders: [UISlider]!
    @IBOutlet weak var magnificationFilterSegmentedControl: UISegmentedControl!
    
    enum Row: Int {
        case
        contentsGravity,
        contentsGravityPicker,
        displayContents,
        geometryFlipped,
        hidden,
        opacity,
        cornerRadius,
        borderWidth,
        borderColor,
        backgroundColor,
        shadowOpacity,
        shadowOffset,
        shadowRadius,
        shadowColor,
        magnificationFilter
    }
    enum Switch: Int {
        case displayContents, geometryFlipped, hidden
    }
    enum Slider: Int {
        case opacity, cornerRadius, borderWidth, shadowOpacity, shadowRadius
    }
    enum ColorSlider: Int {
        case red, green, blue
    }
    enum MagnificationFilter: Int {
        case linear, nearest, trilinear
    }
    
    // swiftlint:disable:next implicitly_unwrapped_optional
    weak var layerViewController: CALayerViewController!
    let contentsGravityValues: [CALayerContentsGravity] = [
        .center,
        .top,
        .bottom,
        .left,
        .right,
        .topLeft,
        .topRight,
        .bottomLeft,
        .bottomRight,
        .resize,
        .resizeAspect,
        .resizeAspectFill
    ]
    var contentsGravityPickerVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSliderValueLabels()
    }
}

// MARK: - IBActions
extension CALayerControlsViewController {
    //MARK: - contents内容  是否翻转视图   是否隐藏
    @IBAction func switchChanged(_ sender: UISwitch) {
        let switchesArray = switches as NSArray
        // swiftlint:disable:next force_unwrapping
        let theSwitch = Switch(rawValue: switchesArray.index(of: sender))!
        
        switch theSwitch {
        case .displayContents:
            layerViewController.layer.contents = sender.isOn ? UIImage(named: "star")?.cgImage : nil
        case .geometryFlipped:
            layerViewController.layer.isGeometryFlipped = sender.isOn
        case .hidden:
            layerViewController.layer.isHidden = sender.isOn
        }
    }
    
    //MARK: - 透明度  圆角  边框宽度  阴影透明度  阴影圆角
    @IBAction func sliderChanged(_ sender: UISlider) {
        let slidersArray = sliders as NSArray
        // swiftlint:disable:next force_unwrapping
        let slider = Slider(rawValue: slidersArray.index(of: sender))!
        
        switch slider {
        case .opacity://修改透明度
            layerViewController.layer.opacity = sender.value
        case .cornerRadius://修改圆角
            layerViewController.layer.cornerRadius = CGFloat(sender.value)
        case .borderWidth://修改边框宽度
            layerViewController.layer.borderWidth = CGFloat(sender.value)
        case .shadowOpacity://修改阴影透明度
            layerViewController.layer.shadowOpacity = sender.value
        case .shadowRadius://修改阴影圆角
            layerViewController.layer.shadowRadius = CGFloat(sender.value)
        }
        
        updateSliderValueLabel(slider)
    }
    
    //MARK: - 边框颜色
    @IBAction func borderColorSliderChanged(_ sender: UISlider) {
        let colorLabel = colorAndLabel(forSliders: borderColorSliders)
        layerViewController.layer.borderColor = colorLabel.color
        borderColorSlidersValueLabel.text = colorLabel.label
    }
    
    //MARK: - 背景色
    @IBAction func backgroundColorSliderChanged(_ sender: UISlider) {
        let colorLabel = colorAndLabel(forSliders: backgroundColorSliders)
        layerViewController.layer.backgroundColor = colorLabel.color
        backgroundColorSlidersValueLabel.text = colorLabel.label
    }
    
    //MARK: - 阴影 偏移
    @IBAction func shadowOffsetSliderChanged(_ sender: UISlider) {
        let width = CGFloat(shadowOffsetSliders[0].value)
        let height = CGFloat(shadowOffsetSliders[1].value)
        layerViewController.layer.shadowOffset = CGSize(width: width, height: height)
        shadowOffsetSlidersValueLabel.text = "Width: \(Int(width)), Height: \(Int(height))"
    }
    
    //MARK: - 阴影颜色
    @IBAction func shadowColorSliderChanged(_ sender: UISlider) {
        let colorLabel = colorAndLabel(forSliders: shadowColorSliders)
        layerViewController.layer.shadowColor = colorLabel.color
        shadowColorSlidersValueLabel.text = colorLabel.label
    }
    
    //MARK: - 内容填充  过滤属性
    @IBAction func magnificationFilterSegmentedControlChanged(_ sender: UISegmentedControl) {
        // swiftlint:disable:next force_unwrapping
        let filter = MagnificationFilter(rawValue: sender.selectedSegmentIndex)!
        let filterValue: CALayerContentsFilter
        
        switch filter {
        case .linear:
            filterValue = .linear  //kCAFilterTrilinear和kCAFilterLinear非常相似，大部分情况下二者都看不出来有什么差别。但是，较双线性滤波算法而言，三线性滤波算法存储了多个大小情况下的图片（也叫多重贴图），并三维取样，同时结合大图和小图的存储进而得到最后的结果
        case .nearest:
            filterValue = .nearest  //这个算法（也叫最近过滤）就是取样最近的单像素点而不管其他的颜色。这样做非常快，也不会使图片模糊。但是，最明显的效果就是，会使得压缩图片更糟，图片放大之后也显得块状或是马赛克严重
        case .trilinear:
            filterValue = .trilinear
        }
        
        layerViewController.layer.magnificationFilter = filterValue
    }
}

// MARK: - Triggered actions
extension CALayerControlsViewController {
    func showContentsGravityPicker() {
        contentsGravityPickerVisible = true
        relayoutTableViewCells()
        let index = contentsGravityValues.firstIndex(of: layerViewController.layer.contentsGravity) ?? 0
        contentsGravityPicker.selectRow(index, inComponent: 0, animated: false)
        contentsGravityPicker.isHidden = false
        contentsGravityPicker.alpha = 0.0
        
        UIView.animate(withDuration: 0.25) {
            self.contentsGravityPicker.alpha = 1.0
        }
    }
    
    func hideContentsGravityPicker() {
        if contentsGravityPickerVisible {
            tableView.isUserInteractionEnabled = false
            contentsGravityPickerVisible = false
            relayoutTableViewCells()
            
            UIView.animate(
                withDuration: 0.25,
                animations: {
                    self.contentsGravityPicker.alpha = 0.0
            }, completion: { _ in
                self.contentsGravityPicker.isHidden = true
                self.tableView.isUserInteractionEnabled = true
            })
        }
    }
}

// MARK: - Helpers
extension CALayerControlsViewController {
    //MARK: - contents布局   居中  靠右或者靠左  类似等等
    func updateContentsGravityPickerValueLabel() {
        contentsGravityPickerValueLabel.text = layerViewController.layer.contentsGravity.rawValue
    }
    
    func updateSliderValueLabels() {
        for slider in Slider.opacity.rawValue...Slider.shadowRadius.rawValue {
            // swiftlint:disable:next force_unwrapping
            updateSliderValueLabel(Slider(rawValue: slider)!)
        }
    }
    
    func updateSliderValueLabel(_ sliderEnum: Slider) {
        let index = sliderEnum.rawValue
        let label = sliderValueLabels[index]
        let slider = sliders[index]
        
        switch sliderEnum {
        case .opacity, .shadowOpacity:
            label.text = String(format: "%.1f", slider.value)
        case .cornerRadius, .borderWidth, .shadowRadius:
            label.text = "\(Int(slider.value))"
        }
    }
    
    func colorAndLabel(forSliders sliders: [UISlider]) -> (color: CGColor, label: String) {
        let red = CGFloat(sliders[0].value)
        let green = CGFloat(sliders[1].value)
        let blue = CGFloat(sliders[2].value)
        let color = UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0).cgColor
        let label = "RGB: \(Int(red)), \(Int(green)), \(Int(blue))"
        return (color: color, label: label)
    }
    
    func relayoutTableViewCells() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

// MARK: - UITableViewDelegate
extension CALayerControlsViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // swiftlint:disable:next force_unwrapping
        let row = Row(rawValue: indexPath.row)!
        
        if row == .contentsGravityPicker {
            return contentsGravityPickerVisible ? 162.0 : 0.0
        } else {
            return 44.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // swiftlint:disable:next force_unwrapping
        let row = Row(rawValue: indexPath.row)!
        
        switch row {
        case .contentsGravity where !contentsGravityPickerVisible:
            showContentsGravityPicker()
        default:
            hideContentsGravityPicker()
        }
    }
}

// MARK: - UIPickerViewDataSource
extension CALayerControlsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return contentsGravityValues.count
    }
}

// MARK: - UIPickerViewDelegate
extension CALayerControlsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return contentsGravityValues[row].rawValue
    }
    //MARK: - contents布局   居中  靠右或者靠左  类似等等
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        layerViewController.layer.contentsGravity = CALayerContentsGravity(rawValue: contentsGravityValues[row].rawValue)
        updateContentsGravityPickerValueLabel()
    }
}
