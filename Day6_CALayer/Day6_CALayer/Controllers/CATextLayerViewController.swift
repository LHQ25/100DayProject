
import UIKit

class CATextLayerViewController: UIViewController {
    @IBOutlet weak var viewForTextLayer: UIView!
    @IBOutlet weak var fontSizeSliderValueLabel: UILabel!
    @IBOutlet weak var fontSizeSlider: UISlider!
    @IBOutlet weak var wrapTextSwitch: UISwitch!
    @IBOutlet weak var alignmentModeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var truncationModeSegmentedControl: UISegmentedControl!
    
    enum Font: Int {
        case helvetica, noteworthyLight
    }
    
    enum AlignmentMode: Int {
        case left, center, justified, right
    }
    enum TruncationMode: Int {
        case start, middle, end
    }
    
    private enum Constants {
        static let baseFontSize: CGFloat = 24.0
    }
    let noteworthyLightFont = CTFontCreateWithName("Noteworthy-Light" as CFString, Constants.baseFontSize, nil)
    let helveticaFont = CTFontCreateWithName("Helvetica" as CFString, Constants.baseFontSize, nil)
    let textLayer = CATextLayer()
    var previouslySelectedTruncationMode = TruncationMode.end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextLayer()
        viewForTextLayer.layer.addSublayer(textLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textLayer.frame = viewForTextLayer.bounds
    }
}

// MARK: - Layer setup
extension CATextLayerViewController {
    func setUpTextLayer() {
        textLayer.frame = viewForTextLayer.bounds
        
        let string = (1...20)
            .map { _ in
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce auctor arcu quis velit congue dictum."
        }
        .joined(separator: " ")
        //字符串
        textLayer.string = string
        
        // 1 文本图层的字体。 请注意，这是CTFont，而不是UIFont。 您可以使用CTFontCreateWithName（_：_：_ :)创建这些文件。
        textLayer.font = helveticaFont
        textLayer.fontSize = Constants.baseFontSize

        // 2 设置字体大小。 接下来，设置文本颜色，换行，对齐和截断模式。 所有这些都可以在常规UILabel或UITextView上获得。
        textLayer.foregroundColor = UIColor.darkGray.cgColor
        textLayer.isWrapped = true
        textLayer.alignmentMode = .left
        textLayer.truncationMode = .end

        // 3 图层的contentsScale设置为与屏幕的比例相匹配。 默认情况下，所有图层类（不仅是CATextLayer）都以比例因子1进行渲染。 将图层附加到视图会自动将其contentScale设置为当前屏幕的适当比例因子。 但是，对于您手动创建的任何图层，必须显式设置contentsScale。 否则，其比例因子将为1，从而使其在Retina显示器上显示为像素化。
        textLayer.contentsScale = UIScreen.main.scale
    }
}

// MARK: - IBActions
extension CATextLayerViewController {
    //MARK: - 修改字体
    @IBAction func fontSegmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case Font.helvetica.rawValue:
            textLayer.font = helveticaFont
        case Font.noteworthyLight.rawValue:
            textLayer.font = noteworthyLightFont
        default:
            break
        }
    }
    //MARK: - 修改字体大小
    @IBAction func fontSizeSliderChanged(_ sender: UISlider) {
        fontSizeSliderValueLabel.text = "\(Int(sender.value * 100.0))%"
        textLayer.fontSize = Constants.baseFontSize * CGFloat(sender.value)
    }
    //MARK: - 文本是否自动换行以适合接收者的范围
    @IBAction func wrapTextSwitchChanged(_ sender: UISwitch) {
        alignmentModeSegmentedControl.selectedSegmentIndex = AlignmentMode.left.rawValue
        textLayer.alignmentMode = CATextLayerAlignmentMode.left
        
        if sender.isOn {
            if let truncationMode = TruncationMode(rawValue: truncationModeSegmentedControl.selectedSegmentIndex) {
                previouslySelectedTruncationMode = truncationMode
            }
            
            truncationModeSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
            textLayer.isWrapped = true
        } else {
            textLayer.isWrapped = false
            truncationModeSegmentedControl.selectedSegmentIndex = previouslySelectedTruncationMode.rawValue
        }
    }
    //MARK: - 对齐方式
    @IBAction func alignmentModeSegmentedControlChanged(_ sender: UISegmentedControl) {
        wrapTextSwitch.isOn = true
        textLayer.isWrapped = true
        truncationModeSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
        textLayer.truncationMode = CATextLayerTruncationMode.none
        
        switch sender.selectedSegmentIndex {
        case AlignmentMode.left.rawValue:
            textLayer.alignmentMode = .left
        case AlignmentMode.center.rawValue:
            textLayer.alignmentMode = .center
        case AlignmentMode.justified.rawValue:
            textLayer.alignmentMode = .justified
        case AlignmentMode.right.rawValue:
            textLayer.alignmentMode = .right
        default:
            textLayer.alignmentMode = .left
        }
    }
    //MARK: - 截断模式
    @IBAction func truncationModeSegmentedControlChanged(_ sender: UISegmentedControl) {
        wrapTextSwitch.isOn = false
        textLayer.isWrapped = false
        alignmentModeSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
        textLayer.alignmentMode = .left
        
        switch sender.selectedSegmentIndex {
        case TruncationMode.start.rawValue:
            textLayer.truncationMode = .start
        case TruncationMode.middle.rawValue:
            textLayer.truncationMode = .middle
        case TruncationMode.end.rawValue:
            textLayer.truncationMode = .end
        default:
            textLayer.truncationMode = .none
        }
    }
}
