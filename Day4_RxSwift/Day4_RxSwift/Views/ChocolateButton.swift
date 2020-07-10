
import UIKit

@IBDesignable
class ChocolateButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            updateAlphaForEnabledState()
        }
    }
    
    enum ButtonStyle {
        case standard, warning
    }
    
    ///Workaround for enum values not being IBInspectable.
    @IBInspectable var isStandard: Bool = false {
        didSet {
            if isStandard {
                style = .standard
            } else {
                style = .warning
            }
        }
    }
    
    private var style: ButtonStyle = .standard {
        didSet {
            updateBackgroundColorForCurrentType()
        }
    }
    
    
    //MARK: Initialization
    
    private func commonInit() {
        setTitleColor(.white, for: .normal)
        updateBackgroundColorForCurrentType()
        updateAlphaForEnabledState()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    //根据Style修改背景色
    func updateBackgroundColorForCurrentType() {
        switch style {
        case .standard:
            backgroundColor = .brown
        case .warning:
            backgroundColor = .red
        }
    }
    
    //是否可用修改北京透明度
    func updateAlphaForEnabledState() {
        if isEnabled {
            alpha = 1
        } else {
            alpha = 0.5
        }
    }
}
