//
// Created by 9527 on 2022/11/5.
//

import UIKit

let backButtonAction = #selector(BaseViewController.backButtonAction(_ :))
let doneButtonAction = #selector(BaseViewController.doneButtonAction(_ :))

class BaseViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @objc
    func backButtonAction(_ sender: UIButton) {}


    @objc
    func doneButtonAction(_ sender: UIButton) {}
}
