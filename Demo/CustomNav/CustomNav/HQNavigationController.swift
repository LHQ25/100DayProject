//
// Created by 9527 on 2022/11/5.
//

import UIKit

let device_systemVersion = Float(UIDevice.current.systemVersion) ?? 0

class HQNavigationController: UINavigationController {

    /// 设置导航栏主题
    static func settingAppearance() {
        // 设置全局导航条外观
        settingUINavigationBarAppearance()

        if (device_systemVersion <= 7) {
            return//不需要设置全局导航条按钮主题
        }

        settingBarButtonItemAppearance()
    }

    static func settingUINavigationBarAppearance() {
        /*
        @protocol UIAppearance <NSObject>  协议的代理方法+ (instancetype)appearance;
        @interface UIView : UIResponder < UIAppearance>
        */

        // 方式一：获取全局外观
        // let navigationBar = UINavigationBar.appearance(); //获取所有导航条外观
        // 方式二：获取我们自己导航控制器的导航条－－ 确保系统的其它功能（短信）的导航条与自己的冲突，尤其在短信分享这方面要注意
        let navigationBar = UINavigationBar.appearance(whenContainedInInstancesOf: [HQNavigationController.self])

        /**
            导航栏背景的出图规格
            iOS6导航栏背景的出图规格
            非retina：320x44 px
            retina：640x88 px
            iOS7导航栏背景的出图规格
            retina：640x128 px
     */
        setupUINNavigationBarestBackgroundImage(navigationBar: navigationBar)

        /*2.
        ＊标题：@property(nonatomic,copy) NSDictionary *titleTextAttributes;// 字典中能用到的key在UIStringDrawing.h中// 最新版本的key在UIKit框架的NSAttributedString.h中
        */
        // NSDictionary *dict = @{UITextAttributeTextColor:[UIColor whiteColor]};
        let dict: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 18)]
        navigationBar.titleTextAttributes = dict
        //2、The tint color to apply to the navigation items and bar button items. 导航条的主题颜色
        navigationBar.tintColor = .white
    }

    static func settingBarButtonItemAppearance() {

    }

    /// 导航条渐变颜色
    static func setupUINNavigationBarestBackgroundImage(navigationBar: UINavigationBar) {
        navigationBar.setBackgroundImage(UIImage(color: UIColor.red, size: CGSize(width: UIScreen.main.bounds.size.width, height: 64)), for: .default)
    }

    func setupNavigationBarBarStyle(barStyle: Int) {

    }

    /// 设置列表控制器的样式
    func setupListNavigationItemAndBarStyle(vc: UIViewController) {

    }

    func setupDetailNavigationItemAndBarStyle(vc: UIViewController) {

    }

    @objc
    func navBackButtonAction(_ sender: UIButton) {
        popViewController(animated: true)
    }

    /// 90%的拦截，都是通过自定义类，重写自带的方法实现
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {

        if viewControllers.count > 0 {
            setNavigationBarHidden(false, animated: false)
            viewController.hidesBottomBarWhenPushed = true

            if viewController.responds(to: backButtonAction) {
                let tmp = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: viewController, action: backButtonAction)
                viewController.navigationItem.leftBarButtonItem = tmp
            } else {
                let tmp = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: self, action: #selector(navBackButtonAction(_:)))
                viewController.navigationItem.leftBarButtonItem = tmp
            }
        }
        super.pushViewController(_: viewController, animated: animated)
    }
/// 重写: animated:
/**
 1）自定义导航控制器的价值
 重写push方法就可以拦截所有压入栈中的子控制器，统一做一些处理
 */
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {

    if let viewControllerToPresent = viewControllerToPresent as? UINavigationController {

        if viewControllerToPresent.topViewController?.responds(to: backButtonAction) ?? false {

            let tmp = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: viewControllerToPresent.topViewController, action: backButtonAction)
//            tmp.baseVC = viewControllerToPresent
            viewControllerToPresent.topViewController?.navigationItem.leftBarButtonItem = tmp
        }else{
            let tmp = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: viewControllerToPresent.topViewController, action: #selector(presentBackAction(_ :)));
//            tmp.baseVC = viewControllerToPresent
            viewControllerToPresent.topViewController?.navigationItem.leftBarButtonItem = tmp
        }
    }
    super.present(_: viewControllerToPresent, animated: flag, completion: completion)
}


    @objc
    func presentBackAction(_ bar: UIBarButtonItem){
        //一旦点击返回，就要打断首次流程
        //[bar.baseVC dismissViewControllerAnimated:YES completion:nil];
    }

}

extension UIImage {

    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)

        defer {
            UIGraphicsEndImageContext()
        }

        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }

        self.init(cgImage: aCgImage)
    }
}