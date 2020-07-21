
import UIKit

final class TeacherDetailViewController: UIViewController {
    private let teacher: Teacher
    
    @IBOutlet private weak var headerBackgroundView: UIView!
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 64
            imageView.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var houseImageView: UIImageView!
    @IBOutlet private weak var houseLabel: UILabel!
    @IBOutlet private weak var yearsAtHogwartsLabel: UILabel!
    
    init?(coder: NSCoder, teacher: Teacher) {
        self.teacher = teacher
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: teacher.imageName)
        nameLabel.text = teacher.name
        yearsAtHogwartsLabel.text = "\(teacher.startingYear)-\(teacher.endingYear)"
        houseLabel.text = teacher.house.name
        
        
        
        
        
//        switch teacher.house {
//        case .gryffindor:
//            houseLabel.textColor = .red
//        case .hufflepuff:
//            houseLabel.textColor = .yellow
//        case .ravenclaw:
//            houseLabel.textColor = .blue
//        case .slytherin:
//            houseLabel.textColor = .green
//        }
        //MARK: - 1. System Colors 替换
        /**
            采用新主题的最重要方面是色彩。 在iOS 13中，Apple对色彩进行了大修，并引入了一些新概念。
            只要存在UIKit，它就提供了一些预定义的颜色，例如.red，.blue和.yellow，您可以在UIColor上进行静态访问。
            现在有一个新的调色板以单词system开头，包括.systemRed和.systemBlue。 这些颜色在浅色和深色背景上均提供合适且清晰的阴影。
            请参阅《 Apple人机界面指南》中的此表。 如您所见，每种系统颜色（也称为淡色）对于明暗模式都有不同的RGB颜色代码。
         */
        switch teacher.house {
        case .gryffindor:
          houseLabel.textColor = .systemRed
        case .hufflepuff:
          houseLabel.textColor = .systemYellow
        case .ravenclaw:
          houseLabel.textColor = .systemBlue
        case .slytherin:
          houseLabel.textColor = .systemGreen
        }
        
        //MARK: - 2. Semantic Colors
        /**
            除了新引入的系统颜色外，iOS 13还提供了语义定义的颜色。 语义颜色传达其目的，而不是其外观或颜色值。 因此，语义颜色也会自动适应黑暗模式。
            您不必知道这些颜色的真实原始值。 相反，您可以根据意图使用它们，并像访问其他颜色一样访问它们：通过对UIColor进行静态调用。 语义颜色的示例包括.label，.separator，.link，.systemBackground和.systemFill。
         */
        
        //MARK: - 3. Background Colors
        /**
         iOS定义了两组背景色：system和grouped。 每个变量都包含主要，次要和第三级变体，可帮助您传达信息的层次结构。
         通常，当您具有分组表格视图时，请使用分组的背景颜色集。 否则，请使用系统设置的背景色。
         对于这两种背景色，您都可以使用变体通过以下方式显示层次结构：
         主要用于整体视图。
         次要的，用于在整体视图中对内容或元素进行分组。
         第三级，用于将内容或元素分组到第二级元素中。
         */
        // Open Main.storyboard. <#In the Dark Arts scene#>, set the Background for both <#Table View#> and <#TeacherCell#> to <#System Background Color#>.
        
        /**
         生成并运行以在亮和暗模式下查看效果。 如您所见，列表的背景颜色会根据外观自动更改，但是在“深色模式”下看不到文本。
         接下来，解决此问题
         */
        
        //MARK: - 4. Foreground Colors
        /**
         对于前景内容，例如标签，还可以使用各种级别的语义颜色来传达内容的重要性。 分级颜色的示例包括.label，.secondaryLabel，.tertiaryLabel。
         */
        //Once again, open <#Main.storyboard#>. Then in the <#Dark Arts#> scene, set the <#Color Name Label#> to <#Label Color#>.
        /**
         您可以在亮和暗模式之间切换模拟器，而无需返回Xcode。 在模拟器中，选择“功能▸切换外观-Shift-Command-A”在它们之间进行切换。
         */
        
        //MARK: - 5. Elevation
        /**
         Elevation: 是z轴上两层用户界面之间的距离。 在灯光模式下，当一层用户界面位于另一层之上时，开发人员可以使用阴影来增强深度感知。
         但这在黑暗模式下不起作用。 虽然黑色阴影不够明显，但深色图层的较浅阴影看起来并不正确。
         为了解决此问题，暗模式使用两组背景颜色：基色和高色。 基色较暗，因此背景界面看起来已退去。 相反，升高的颜色较浅，这使得前景界面看起来突出。
         */
        
        /**
         打开Main.storyboard。 在“Teacher Detail View Controller”中，将根视图的“View”的“Background”System Background Color”。 这与您在先前步骤中为列表背景设置的值完全相同。
         在这里时，请同时更改以下内容：
         首先，将“Color”设置为“Label Color”。
         其次，将“Taught at Hogwarts”Tertiary Label Color”。
         第三，将“Years at Hogwarts”设置为”Secondary Label Color“。
         */
        
        /**
         查看背面的视图控制器和正面的详细信息屏幕的背景色。 尽管将它们都设置为相同的.systemBackgroundColor，但它们看起来却有所不同。 在黑暗模式下更明显。
         请记住，应用程序中的列表在黑暗模式下具有.systemBackgroundColor的纯黑色背景。 但是在详细信息屏幕中，当以模态形式显示在其父级顶部时，它具有深灰色的背景色。 此行为是正常现象，无需任何额外努力即可提供给您。
         黑暗模式是动态的。 这意味着，当界面（如弹出框或模式表）位于前景中时，背景颜色会自动从基本颜色变为高色
         */
        
        
        //MARK: - 6. Dynamic Colors
        /**
         这些新引入的系统颜色和语义颜色很有用，但并非在所有情况下都有效。 例如，如果您需要使用品牌颜色或设计要求使用Apple提供的颜色以外的颜色，它们将对您没有帮助。
         在使用深色模式之前，您可以通过多种方式合并自定义颜色。 使用UIColor初始化程序时，开发人员经常使用代码或Asset Catalogs目录。 幸运的是，Apple进行了更新，将暗模式考虑在内。
         您将首先解决编码方法。
         */
        
        /**
         UITraitCollection
         但是，在继续之前，您首先需要了解UITraitCollection的概念。
         iOS通过UITraitEnvironment协议的traitCollection属性公开了任何应用程序的界面环境。 UIWindow，UIViewController和UIView都是符合此协议的类。
         您可以在iOS应用中访问许多用户界面特征，例如尺寸类别，强制触摸功能和样式。 通过考虑这些属性和相关方法，可以使用户界面适应系统的建议。
         黑暗模式是由特质收集的magic处理的。 这是一个新特性，接下来您将学习如何使用它。
         */
        ///UIColor Dynamic Provider
        //要在代码中构造颜色，您将使用基于闭包的初始化程序。
        
        // headerBackgroundView.backgroundColor = .white
        //替换
        headerBackgroundView.backgroundColor = UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? UIColor(white: 0.3, alpha: 1.0) : UIColor(white: 0.7, alpha: 1.0)
        }
        
        
        //MARK: - 7. Asset Catalog
        /**
         从iOS 11开始，您可以将颜色保存在Asset Catalogs中，并在代码和Interface Builder中使用它们。 您可以通过简单的调整使颜色动态。
         打开Assets.xcassets并查看colors文件夹。 在属性检查器的新“Color"部分下，您可以添加颜色的变体。 最简单的选择是“Any , Dark”，您可以在其中为深色外观提供新的颜色。 对于Colors，您会发现一种动态颜色，称为 thumbnail-border 。 对于黑暗模式，它提供 green color；对于明亮模式，它提供 gray color。
         */
        //使用
        /**
            打开Main.storyboard。 在“Dark Arts”场景中，有一个Border View，它充当教师头像上的笔触。 当前，其Background设置为静态颜色：rw-dark。 由于您不会留下最小的细节，因此请将其更改为thumbnail-border
         */
        
        //MARK: - 8. Dynamic Images
        /**
         您可能已经在详细信息页面的底部注意到了一幅精美的霍格沃茨画作。 如果应用程序处于黑暗模式时在夜间显示霍格沃茨，那会不会很酷？
         好消息！ 您可以使用dynamic images来做到这一点。
         遵循用于在图像的“Asset Catalog”中向颜色添加变体的相同过程。
         */
        //操作
        /**
         打开Assets.xcassets。 您会看到两张名为 hogwarts 和 hogwarts-night 的图像。 单击 hogwarts。
         在“属性”检查器中，单击“Appearances”，然后选择“Any, Dark”。 出现一个新的空插槽。
         右键单击hogwarts-night，然后单击在Finder中显示。 将图像从Finder拖到您在hogwarts中创建的空白位置。 现在删除hogwarts-night，因为两个图像的名称都为hogwarts。
         */
        
        
        //MARK: - 9. SFSymbols
        /**
         苹果公司为iOS 13推出的最酷的功能之一是SFSympols，这是一整套的一致且高度可配置的图像。 这些符号根据外观，大小和重量可以很好地缩放。 最重要的是，您还可以在应用程序中免费使用它们。
         他们还准备好黑暗模式。 您可以将它们着色为任何动态颜色，并且它们的适应效果很好。 除非您的应用程序需要特定的图像和资产，否则SFSymbols可以满足您的插图需求。
         是时候使用SFSymbols在房屋名称旁边添加房屋icon 。
         */
        houseImageView.image = UIImage(systemName: "house.fill")
        /**
            这行代码使用新的UIImage初始化程序，该初始化程序使用 SFSymbols 目录中的 symbol
         */
        /**
         房子在明亮模式下很漂亮，但它却是黑色的，在黑暗模式下很难看清。 您知道如何解决该问题！
         在您刚刚插入的行上方，有一段代码设置了houseImageView的tintColor。
         */
        //houseImageView.tintColor = .black
        //替换
        houseImageView.tintColor = houseLabel.textColor
        /**
         注意：Apple为SFSymbols提供了配套的Mac应用程序。 您可以在此处下载并浏览目录: https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/ 您在UIColor的初始值设定项中使用的字符串名称来自此应用程序。
         */
        
        //MARK: - 10  Opting Out of Dark Mode
        /**
         黑暗模式比以往更受欢迎。 您可以在全系统范围内将设备设置为暗模式，现在所有Apple和许多第三方应用程序都将其包括在内。 虽然您可以选择退出黑暗模式，但对于喜欢在黑暗中进行所有操作的用户而言，可能会造成眼睛疲劳。 我们非常鼓励您在选择不支持黑暗模式之前重新考虑。
         
         但是，如果您确定要退出暗模式，则可以选择以下几种方法：
         1. 通过使用 Info.plist 中的 UIUserInterfaceStyle 键为整个应用程序关闭暗模式。
         
         2. 在应用程序的UIWindow上设置界面样式，这通常意味着整个应用程序。
         3. 设置特定UIView或UIViewController的界面样式。
         您将为应用程序一一设置。
            由于最终项目违反了本教程的目的，因此最终项目将保持黑暗状态。 另外，在浏览下面的每个选项时，请记住在尝试新方法之前删除用于退出暗模式的代码
         */
        
        //MARK: - 10.1 Opting Out with Info.plist
        /**
         打开Info.plist。 然后添加一个名为 UIUserInterfaceStyle 的键并将其设置为Light。
         */
        
        // 在继续下一步之前，请记住要删除之前的操作
        
        //MARK: - 10.2 Opting Out in UIWindow
        /**
         打开SceneDelegate.swift。 替换：
            var window: UIWindow?
            为
            var window: UIWindow? {
                didSet {
                window?.overrideUserInterfaceStyle = .light
                }
            }
         */
        /**
         由于此应用使用storyboards，因此系统会设置 window
         此代码块在window上设置Swift属性观察器。 一旦设置了此属性，就可以将界面样式覆盖为.light。 由于此应用程序仅使用一个窗口，因此覆盖窗口上的样式会使该应用程序像在Info.plist中设置该键一样起作用。
         */
        
        //MARK: - 10.3 Opting Out in UIViewController
        /**
         打开TeacherDetailViewController.swift。 您将使该视图控制器成为 不遵守 黑暗模式 。
         在viewDidLoad（）中，在对super.viewDidLoad（）的调用之后，添加代码：
         overrideUserInterfaceStyle = .light
         
         该行 覆盖此特定 视图控制器 的样式。
         */
    }
}
