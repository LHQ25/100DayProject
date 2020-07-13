
import UIKit

class CAShapeLayerViewController: UIViewController {
    @IBOutlet weak var viewForShapeLayer: UIView!
    @IBOutlet weak var hueSlider: UISlider!
    @IBOutlet weak var lineWidthSlider: UISlider!
    @IBOutlet weak var lineDashSwitch: UISwitch!
    @IBOutlet weak var lineCapSegmentedControl: UISegmentedControl!
    @IBOutlet weak var lineJoinSegmentedControl: UISegmentedControl!
    
    enum LineCap: Int {
        case butt, round, square, cap
    }
    enum LineJoin: Int {
        case miter, round, bevel
    }
    
    let shapeLayer = CAShapeLayer()
    var color = swiftOrangeColor
    let openPath = UIBezierPath()
    let closedPath = UIBezierPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPath()
        setUpShapeLayer()
    }
}

// MARK: - Layer setup
extension CAShapeLayerViewController {
    func setUpPath() {
        //起始点
        openPath.move(to: CGPoint(x: 30, y: 196))
        //曲线
        openPath.addCurve(
            to: CGPoint(x: 112.0, y: 12.5),
            controlPoint1: CGPoint(x: 110.56, y: 13.79),
            controlPoint2: CGPoint(x: 112.07, y: 13.01))
        //曲线
        openPath.addCurve(
            to: CGPoint(x: 194, y: 196),
            controlPoint1: CGPoint(x: 111.9, y: 11.81),
            controlPoint2: CGPoint(x: 194, y: 196))
        //直线
        openPath.addLine(to: CGPoint(x: 30.0, y: 85.68))
        openPath.addLine(to: CGPoint(x: 194.0, y: 48.91))
        openPath.addLine(to: CGPoint(x: 30, y: 196))
    }
    
    func setUpShapeLayer() {
        // 1  路径
        shapeLayer.path = openPath.cgPath

        // 2  lineJoin和lineCap定义路径中的线如何相交和结束   相交的圆角
        shapeLayer.lineCap = .butt
        shapeLayer.lineJoin = .miter
        shapeLayer.miterLimit = 4.0

        // 3 路径线的宽度和颜色  闭合填充颜色
        shapeLayer.lineWidth = CGFloat(lineWidthSlider.value)
        shapeLayer.strokeColor = swiftOrangeColor.cgColor
        shapeLayer.fillColor = UIColor.cyan.cgColor

        // 4 lineDashPattern和lineDashPhase允许您绘制虚线。 在这种情况下，您将绘制不带破折号的简单线条
        shapeLayer.lineDashPattern = nil
        shapeLayer.lineDashPhase = 0.0

        viewForShapeLayer.layer.addSublayer(shapeLayer)
    }
}

// MARK: - IBActions
extension CAShapeLayerViewController {
    //MARK: - 画笔颜色
    @IBAction func hueSliderChanged(_ sender: UISlider) {
        let hue = CGFloat(sender.value / 359.0)
        let color = UIColor(hue: hue, saturation: 0.81, brightness: 0.97, alpha: 1.0)
        shapeLayer.strokeColor = color.cgColor
        self.color = color
    }
    //MARK: - 线宽
    @IBAction func lineWidthSliderChanged(_ sender: UISlider) {
        shapeLayer.lineWidth = CGFloat(sender.value)
    }
   //MARK: - 线段 虚线 样式
    @IBAction func lineDashSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            shapeLayer.lineDashPattern = [50, 50]
            shapeLayer.lineDashPhase = 25.0
        } else {
            shapeLayer.lineDashPattern = nil
            shapeLayer.lineDashPhase = 0
        }
    }
    //MARK: - 线段结尾处 样式
    @IBAction func lineCapSegmentedControlChanged(_ sender: UISegmentedControl) {
        shapeLayer.path = openPath.cgPath
        
        let lineCap: CAShapeLayerLineCap
        switch sender.selectedSegmentIndex {
        case LineCap.round.rawValue:
            lineCap = .round
        case LineCap.square.rawValue:
            lineCap = .square
        default:
            lineCap = .butt
        }
        
        shapeLayer.lineCap = lineCap
    }
     //MARK: - 线段连接处 样式
    @IBAction func lineJoinSegmentedControlChanged(_ sender: UISegmentedControl) {
        let lineJoin: CAShapeLayerLineJoin
        
        switch sender.selectedSegmentIndex {
        case LineJoin.round.rawValue:
            lineJoin = .round
        case LineJoin.bevel.rawValue:
            lineJoin = .bevel
        default:
            lineJoin = .miter
        }
        
        shapeLayer.lineJoin = lineJoin
    }
}
