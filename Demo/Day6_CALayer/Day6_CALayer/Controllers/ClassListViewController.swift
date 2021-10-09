
import UIKit

class ClassListViewController: UITableViewController {
    //数据模型
    let classes: [ClassDescription] = [
        ClassDescription(title: "CALayer", description: "管理视觉内容并制作动画"), //CALayerViewController
        ClassDescription(title: "CAScrollLayer", description: "显示可滚动层的部分"), //CAScrollLayerViewController
        ClassDescription(title: "CATextLayer", description: "呈现纯文本或属性字符串"), //CATextLayerViewController
        ClassDescription(title: "AVPlayerLayer", description: "显示AVPlayer"),  //AVPlayerLayerViewController
        ClassDescription(title: "CAGradientLayer", description: "颜色渐变"),  //CAGradientLayerViewController
        ClassDescription(title: "CAReplicatorLayer", description: "复制Layer"),  //CAReplicatorLayerViewController
        ClassDescription(title: "CAShapeLayer", description: "使用可缩放矢量路径进行绘制"),  //CAShapeLayerViewController
        ClassDescription(title: "CATransformLayer", description: "绘制3D结构"), //CATransformLayerViewController
        ClassDescription(title: "CAEmitterLayer", description: "渲染动画粒子") //CAEmitterLayerViewController
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
    }
}

// MARK: - UITableViewDataSource
extension ClassListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCell", for: indexPath)
        let classDescription = classes[indexPath.row]
        cell.textLabel?.text = classDescription.title
        cell.detailTextLabel?.text = classDescription.description
        cell.imageView?.image = UIImage(named: classDescription.title)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ClassListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let identifier = classes[indexPath.row].title
        performSegue(withIdentifier: identifier, sender: nil)
    }
}
