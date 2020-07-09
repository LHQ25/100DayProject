
import Foundation

extension NSNumber {
    ///数字格式化  默认小数类型
    func formatted(withStyle style: NumberFormatter.Style = .decimal) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = style
        return numberFormatter.string(from: self)
    }
}
