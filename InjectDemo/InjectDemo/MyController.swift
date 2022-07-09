//
//  MyController.swift
//  InjectDemo
//
//  Created by 9527 on 2022/7/6.
//

import UIKit
import Inject

class MyController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
//        let v = Inject.ViewHost(MyView(frame: self.view.bounds))
//        v.backgroundColor = .yellow
//        view.addSubview(v)
        let label = UILabel()
        label.frame = CGRect(x: 10, y: 200, width: 100, height: 30)
        label.backgroundColor = .yellow
        label.text = "12"
        view.addSubview(label)
        
    }
    
    @objc func injected()  {
#if DEBUG
        
        self.viewDidLoad()
        
#endif
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class MyView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel()
        label.frame = CGRect(x: 10, y: 200, width: 100, height: 30)
        label.text = "12341312312"
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
