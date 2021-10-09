//
//  ViewController.swift
//  Day15_1  Swift(UITableView)
//
//  Created by 亿存 on 2020/7/29.
//  Copyright © 2020 亿存. All rights reserved.
//

import UIKit

struct Person: Hashable{
    
    var name: String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for i in 0..<5 {
            var array = [Person]()
            for j in 0..<10 {
                let ii = Person(name: "name: \(i) - \(j)")
                array.append(ii)
            }
            datas.append(array)
        }
        
        self.view.addSubview(self.tableView)
    }

    @IBAction func editAction(_ sender: UIBarButtonItem) {
        
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    var datas = [[Person]]()
    
    lazy var tableView: UITableView = {
        let t = UITableView(frame: self.view.bounds, style: .plain)
        t.delegate = self
        t.dataSource = self
        t.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        t.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: "TableHeaderView")
        t.register(TableFooterView.self, forHeaderFooterViewReuseIdentifier: "TableFooterView")
        
        t.allowsSelection = true  //允许选中
        t.allowsMultipleSelection = true  //允许多个选中
        t.allowsSelectionDuringEditing = true  //编辑是允许选中
        t.allowsMultipleSelectionDuringEditing = true //编辑时允许多个选中  (双指滑动选中多个需要打开)
        
        t.prefetchDataSource = self
        
//        t.dragDelegate = self
        return t
    }()
    
    
    
}

extension ViewController: UITableViewDelegate {
    
    //MARK: - 配置Cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        print("即将显示的Cell --  \(indexPath)")
    }
    /// 缩进
    /// - Parameters:
    ///   - tableView: 当前TableView
    ///   - indexPath: 要缩进的 indexPath
    /// - Returns: 返回指定行的深度以显示其在部分中的层次结构位置
//    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int{
//        return 0
//    }
    
    /// 加载弹簧效果
    /// - Parameters:
    ///   - tableView: 当前TableView
    ///   - indexPath: Cell的indexPath
    ///   - context: 弹簧效果上下文
    /// - Returns: 是否执行
    func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
//        context.targetView = tableView.cellForRow(at: indexPath)?.contentView
//        context.
        return true
    }
    
    //MARK: - 响应Cell选择
    ///将要选择的Cell
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?{
        print("将要选择的Cell  \(indexPath)")
        return indexPath
    }
    ///选择的Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("选择的Cell  \(indexPath)")
        let cell = tableView.cellForRow(at: indexPath)
        
    }
    ///将要取消选择的Cell
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath?{
        print("将要取消选择的Cell  \(indexPath)")
        return indexPath
    }
    ///取消选择的Cell
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath){
        print("取消选择的Cell  \(indexPath)")
    }
    ///是否可以使用两指平移手势来选择tableView中的多个cell。
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
       return true
    }
    ///开始使用两指平移手势在tableView中选择多行。
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath){
        print("使用两指平移手势在tableView中选择多行  \(indexPath)")
    }
    ///停止使用两指平移手势在tableView中选择多行。
    func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView){
        print("停止使用两指平移手势在tableView中选择多行  \(tableView.indexPathsForSelectedRows ?? [])")
    }
    
    //MARK: - 提供自定义的Section  Header和Footer 视图
    ///Section  HeaderView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeaderView") as! TableHeaderView
        headerView.label.text = "SectionHeaderView：(\(section))"
         return headerView
    }
    ///Section  FooterView
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableFooterView") as! TableFooterView
        footerView.label.text = "SectionFooterView：(\(section))"
        return footerView
    }
    ///即将显示的HeaderView
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        print("即将显示的HeaderView --  \(section)")
    }
    ///即将显示的FooterView
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int){
        print("即将显示的FooterView --  \(section)")
    }
    
    //MARK: - 提供SectionHeaderView、SectionFooterView和Row高
    ///Cell的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60
    }
    ///Section HeaderView 高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 50
    }
    ///Section FooterView 高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 50
    }
    
    //MARK: - 预估 高度
    ///预估计 Cell 的高度
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60
    }
    
    ///预估计  Section HeaderView 高度
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    ///预估计 Section FooterView 高度
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat{
        return 50
    }
    
    //MARK: - 管理附件视图点击
    ///accessoryButtonTapped 点击事件
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath){
        print("accessoryButtonTappedForRowWith  \(indexPath)")
        
//        if indexPath.section == 0 && indexPath.row == 4 {
//            if #available(iOS 13.0, *) {
//                let interaction = UIContextMenuInteraction(delegate: self)
//                let cell = tableView.cellForRow(at: indexPath)
//                cell?.addInteraction(interaction)
//            }
//        }
    }
    
    //MARK: - Cell的响应事件
    ///Cell向右滑动时  以 显示 在行的左边的一系列动作。
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        let swipeActionFiguration = UISwipeActionsConfiguration(actions: [.init(style: .normal, title: "Normal", handler: { (action, view, resl) in
            print("Left - Normal - Action")
            resl(true)
        }), .init(style: .destructive, title: "Destructive", handler: { (action, view, result) in
            print("Left - Destructive - Action")
            result(true)
        })])
        return swipeActionFiguration
    }
    ///Cell向左滑动时  以 显示 在行的左边的一系列动作。
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        let swipeActionFiguration = UISwipeActionsConfiguration(actions: [.init(style: .normal, title: "Normal", handler: { (action, view, resl) in
            print("Right - Normal - Action")
            resl(true)
        }), .init(style: .destructive, title: "Destructive", handler: { (action, view, result) in
            print("Right - Destructive - Action")
            result(true)
        })])
        return swipeActionFiguration
    }
    
    ///是否应在某一行显示编辑菜单   长按cell的copy和paste
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool{
        if indexPath.row == 2 && indexPath.section == 0 {
            return true
        }
        return false
    }
    ///编辑菜单是否应忽略给定行的“复制”或“粘贴”命令。
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        print("action: \(action), indexPath: \(indexPath), sender: \(sender)")
        return true
    }
    ///对给定行的内容执行复制或粘贴操作。
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?){
        print("对给定行的内容执行复制或粘贴操作  \(indexPath)")
    }
    
    ///响应于指定行中的滑动而显示的动作  和 上面  左滑&右滑弹出的动作是冲突的，上面的会覆盖当前方法，
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        let ac1 = UITableViewRowAction(style: .normal, title: "ac1") { (action, indexPath) in
            print("ac2 \(indexPath)")
        }
        let ac2 = UITableViewRowAction(style: .destructive, title: "ac2") { (action, indexPath) in
            print("ac2 \(indexPath)")
        }
        let ac3 = UITableViewRowAction(style: .default, title: "ac3") { (action, indexPath) in
            print("ac3 \(indexPath)")
        }
        return [ac1, ac2, ac3]
    }
    
    //MARK: - Cell高亮 设置
    ///选中的Cell 是否可以高亮
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        print("选中的Cell 是否可以高亮   \(indexPath)")
        return true
    }
    ///选中的Cell  高亮 状态
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath){
        print("选中的Cell  高亮状态   \(indexPath)")
    }
    ///选中的Cell  高亮 状态 取消
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath){
        print("选中的Cell  高亮状态取消(手指点按状态消失)  \(indexPath)")
    }
    
    //MARK: - 编辑Cell
    ///即将开始 编辑 模式
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath){
        print("即将开始编辑行为  \(indexPath)")
    }
    ///结束 编辑 模式
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?){
        print("开始编辑行为  \(String(describing: indexPath))")
    }
    ///Cell 的 编辑行为(删除 和 添加)
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        //添加
        return .insert
        //        //删除
        //        return .delete
        //        //多选
        //        return UITableViewCell.EditingStyle(rawValue: 1 | 2)!
    }
    ///删除按钮文字
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
        return "自定义删除文字"
    }
    ///当tableView处于编辑模式时，是否应缩进指定行的背景
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    //MARK: - 重新排序/调整位置  Cell
    /// Cell 移动  sourceIndexPath
    /// - Parameters:
    ///   - tableView: 当前TableView
    ///   - sourceIndexPath: 源路径
    ///   - proposedDestinationIndexPath: 目标路径
    /// - Returns: 目标路径
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath{
        print("移动是目标源路径：  \(sourceIndexPath)")
        print("移动过程中路径：  \(proposedDestinationIndexPath)")
        return proposedDestinationIndexPath
    }

    //MARK: - Cell & HeaderView & FooterView显示
    ///显示的Cell
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath){
        print("显示的Cell --  \(indexPath)")
    }
    ///即将显示的HeaderView
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int){
        print("显示的HeaderView --  \(section)")
    }
    ///即将显示的FooterView
    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int){
        print("显示的FooterView --  \(section)")
    }
    
    //MARK: - Cell视图焦点   （使用Apple TV遥控器控制屏幕上的用户界面 😭😭😭)
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator){
        print("context.nextFocusedIndexPath: \(context.nextFocusedIndexPath)")
        print("context.previouslyFocusedIndexPath : \(context.previouslyFocusedIndexPath)")
        //添加动画
        
        coordinator.addCoordinatedAnimations({
            UIView.animate(withDuration: 2.0) {
                tableView.backgroundColor = .orange
            }
        }) {
            print("完成1")
        }
//
//        coordinator.addCoordinatedFocusingAnimations({ (animationContext) in
//
//        }) {
//            print("完成2")
//        }
    }
    ///首选焦点视图的Cell的IndexPath。
    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath?{
        return nil
    }
    
    //MARK: - Instance Methods
    /*
    /// 在交互开始时调用。
    /// - Parameters:
    ///   - tableView: 此UITableView。
    ///   - indexPath: 正在请求配置的行的IndexPath。
    ///   - point: 交互在表格视图的坐标空间中的位置
    /// - Returns: UIContextMenuConfiguration，它描述要显示的菜单。 返回nil以防止开始交互。 返回空配置会导致交互开始，然后失败，并产生取消效果。 您可以使用它来向用户指示可以从此元素显示菜单，但是在此特定时间没有要显示的操作。
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?{
        print("contextMenuConfigurationForRowAt -- 1  indexPath:\(indexPath)  point:\(point)")
        let id = NSString(string: "UIContextMenuConfiguration_Id")
        let contextMenuConfiguration = UIContextMenuConfiguration(identifier: id, previewProvider: { () -> UIViewController? in
            TempController()
        }) { (menuElement) -> UIMenu? in
            for item in menuElement {
                debugPrint("menu_title  \(item.title)")
            }
            return UIMenu(title: "menu_title", image: nil, identifier: .about, options: .destructive, children: menuElement)
        }
        return contextMenuConfiguration
    }
    
    
    /// 在交互开始时调用。 返回一个UITargetedPreview，以覆盖由表视图创建的默认预览。
    /// - Parameters:
    ///   - tableView: 此UITableView。
    ///   - configuration: 此交互即将显示的菜单配置。
    /// - Returns: <#description#>
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?{
        print("previewForHighlightingContextMenuWithConfiguration -- 2")
        let v = UIView()
        v.backgroundColor = .red
        
        let parameters = UIPreviewParameters(textLineRects: [NSValue(cgRect: CGRect(x: 0, y: 0, width: 150, height: 150))])
        parameters.backgroundColor = .cyan
        
        let target = UIPreviewTarget(container: self.view, center: self.view.center, transform: .identity)
        
        let targetedPreview = UITargetedPreview(view: v, parameters: parameters, target: target)
        v.frame = CGRect(origin: .zero, size: targetedPreview.size)
        return targetedPreview
    }

    
    /// 在互动即将结束时调用。 返回描述所需解雇目标的UITargetedPreview。
    /// 交互会将所显示的菜单动画化为目标。 使用此自定义解雇动画
    /// - Parameters:
    ///   - tableView: 此UITableView。
    ///   - configuration: 此交互显示的菜单的配置。
    /// - Returns: <#description#>
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?{
        print("previewForDismissingContextMenuWithConfiguration -- 3")
        let v = UIView()
        v.backgroundColor = .red
        
        let target = UIPreviewTarget(container: self.view, center: self.view.center, transform: .identity)
        
        let parameters = UIPreviewParameters(textLineRects: [NSValue(cgRect: CGRect(x: 0, y: 0, width: 150, height: 150))])
        parameters.backgroundColor = .yellow
        
        return UITargetedPreview(view: v, parameters: parameters, target: target)
    }
    
    /// 当交互即将“提交”以响应用户点击预览时调用。
    /// - Parameters:
    ///   - tableView: 此UITableView。
    ///   - configuration: 配置当前显示菜单的配置。
    ///   - animator: 动画 将动画添加到此对象，以在提交转换旁边运行它们
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating){
        print("willPerformPreviewActionForMenuWith -- 4")
        if animator.preferredCommitStyle == .dismiss {
            animator.addAnimations {
                UIView.animate(withDuration: 0.5, animations: {
                    tableView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }) { (_) in
                    tableView.transform = .identity
                }
            }
        }else if animator.preferredCommitStyle == .pop {
            animator.addAnimations {
                UIView.animate(withDuration: 0.5, animations: {
                    tableView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }) { (_) in
                    tableView.transform = .identity
                }
            }
        }
        
    }
 */
}

@available(iOS 13.0, *)
extension ViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration?{
        let id = NSString(string: "id")
        let contextMenuConfiguration = UIContextMenuConfiguration(identifier: id, previewProvider: { () -> UIViewController? in
            TempController()
        }) { (menuElement) -> UIMenu? in
            for item in menuElement {
                print("menu_title  \(item.title)")
            }
            
//            UIAction(title: <#T##String#>, image: <#T##UIImage?#>, identifier: <#T##UIAction.Identifier?#>, discoverabilityTitle: <#T##String?#>, attributes: <#T##UIMenuElement.Attributes#>, state: <#T##UIMenuElement.State#>, handler: <#T##UIActionHandler##UIActionHandler##(UIAction) -> Void#>)
            return UIMenu(title: "menu_title", image: nil, identifier: .file, options: .destructive, children: menuElement)
        }
        return contextMenuConfiguration
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?{
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        v.backgroundColor = .red
        
        let parameters = UIPreviewParameters(textLineRects: [NSValue(cgRect: CGRect(x: 40, y: 100, width: 100, height: 100))])
        parameters.backgroundColor = .cyan
        let target = UIPreviewTarget(container: self.view, center: self.view.center, transform: CGAffineTransform(translationX: 90, y: -90))
        
        let targetedPreview = UITargetedPreview(view: v, parameters: parameters, target: target)
        return targetedPreview
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForDismissingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?{
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        v.backgroundColor = .purple
        
        let parameters = UIPreviewParameters(textLineRects: [NSValue(cgRect: CGRect(x: 40, y: 100, width: 100, height: 100))])
        parameters.backgroundColor = .yellow
        let target = UIPreviewTarget(container: self.view, center: self.view.center, transform: CGAffineTransform(translationX: 90, y: -90))
        
        let targetedPreview = UITargetedPreview(view: v, parameters: parameters, target: target)
        return targetedPreview
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating){
        if animator.preferredCommitStyle == .dismiss {
            animator.addAnimations {
                UIView.animate(withDuration: 0.5, animations: {
                    self.tableView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }) { (_) in
                    self.tableView.transform = .identity
                }
            }
        }else if animator.preferredCommitStyle == .pop {
            animator.addAnimations {
                UIView.animate(withDuration: 0.5, animations: {
                    self.tableView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }) { (_) in
                    self.tableView.transform = .identity
                }
            }
        }
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willDisplayMenuFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?){
        print("willDisplayMenuFor")
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willEndFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?){
        print("willEndFor")
    }
}

extension ViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        datas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datas[section].count
    }
    
    @objc func bbbAction(sender: UIButton){
        print("UIContextMenuInteraction -- add")
        if #available(iOS 13.0, *) {
            let interaction = UIContextMenuInteraction(delegate: self)
            //        let cell = tableView.cellForRow(at: indexPath)
            sender.addInteraction(interaction)
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = datas[indexPath.section][indexPath.row].name
        cell.detailTextLabel?.text = "Cell：Section(\(indexPath.section)) , Row(\(indexPath.row))"
        cell.accessoryType = .detailButton
        if indexPath.row == 2 && indexPath.section == 0 {
            cell.accessoryView = {
                let b = UIButton(type: .custom)
                b.frame = CGRect(x: 0, y: 0, width: 90, height: 40)
                b.backgroundColor = randomColor()
                b.setTitle("MenuInteraction", for: .normal)
                b.addTarget(self, action: #selector(bbbAction(sender:)), for: .touchUpInside)
                
                return b
            }()
        }
        return cell
        
    }
//    MARK: Section HeaderView && FooterView 显示 textLabel 文字
    ///设置Section HeaderView 显示 textLabel 文字， 自定义的HeaderView  不要实现   会覆盖在上面
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
//        return "？？？"
//    }
    ///设置Section FooterView 显示 textLabel 文字， 自定义的HeaderView  不要实现   会覆盖在上面
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?{
//        return "???"
//    }
//
//
//    MARK: - Cell是否可以进入编辑状态
    ///Cell是否可以进入编辑状态
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }

//    MARK: - Cell是否可以进入 移动/排序 状态
    ///Cell是否可以移动
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool{
        return true
    }

//    MARK: - SectionView  Title
    func sectionIndexTitles(for tableView: UITableView) -> [String]?{ // return list of section titles to display in section index view (e.g. "ABCD...Z#")
        return ["s_0","s_1","s_2","s_3","s_4","s_5","s_6","s_7","s_8","s_ 9","s_10"]
    }
    ///告诉Table哪个 section 与 title/index 相对应（例如“ B”，1））
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        print("title/index 相对应：\(title)  -  \(index)")
        //超出部分 按 自己想要返回对应的Section
        if title == "section_8" {
            return 2
        }
        return index
    }
    
//    MARK: -  删除/添加  &&  移动/排序
    ///删除/添加
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        print("删除/添加  完成")
        
        if editingStyle == .insert {
            //添加的位置
            let i = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            let p = Person(name: "新增对象：name: \(i.section) - \(i.row)")
            //修改数据源
            var subSection = datas[indexPath.section]
            subSection.insert(p, at: i.row)
            datas[indexPath.section] = subSection
            
            tableView.beginUpdates()
            tableView.insertRows(at: [i], with: .fade)
            tableView.endUpdates()
        }else if editingStyle == .delete {
            
            var subSection = datas[indexPath.section]
            subSection.remove(at: indexPath.row)
            datas[indexPath.section] = subSection
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }else{
            
            print("多选操作")
        }
    }

    ///移动/排序  完成
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        print("移动/排序  完成\n  修改数据源对应的位置")
        
    }
}

//MARK: - UITableViewDataSourcePrefetching  预加载数据
extension ViewController: UITableViewDataSourcePrefetching {
    
    ///预取数据源对象 开始为提供的 indexPaths 的 Cell 准备数据。
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]){
        
        print("预读Cell  \(indexPaths)")
    }

    
    ///先前触发的数据预取请求  取消
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]){
        print("先前触发的数据预取请求  取消  \(indexPaths)")
    }
    
}
//MARK: - UIDataSourceTranslating 用于管理数据源对象的高级界面
//extension ViewController: UIDataSourceTranslating{
//    //MARK: - 物品positions
//    func presentationSectionIndex(forDataSourceSectionIndex dataSourceSectionIndex: Int) -> Int {
//
//        return dataSourceSectionIndex
//    }
//
//    func dataSourceSectionIndex(forPresentationSectionIndex presentationSectionIndex: Int) -> Int {
//        return presentationSectionIndex
//    }
//
//    func presentationIndexPath(forDataSourceIndexPath dataSourceIndexPath: IndexPath?) -> IndexPath? {
//        dataSourceIndexPath
//    }
//
//    func dataSourceIndexPath(forPresentationIndexPath presentationIndexPath: IndexPath?) -> IndexPath? {
//        presentationIndexPath
//    }
//
//    func performUsingPresentationValues(_ actionsToTranslate: () -> Void) {
//
//    }
//
//
//
//}


struct Keys {
    static var name = "name"
}
//MARK: - UITableViewDiffableDataSource
//UITableViewDiffableDataSource 出现的原因，主要是列表数据在刷新时。若使用reloadData方法，会进行所有数据的刷新（明显比较耗资源）；若要进行局部刷新，reloadRows或者reloadSection等，这部分的数据刷新需要程序员自己进行比对（过程比较复杂，且容易出错）
@available(iOS 13.0, *)
extension ViewController{
    
    var dataSource: UITableViewDiffableDataSource<Int, Person> {
        set{
            objc_setAssociatedObject(self, Keys.name, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, Keys.name) as! UITableViewDiffableDataSource<Int, Person>
        }
    }
    func initDiffableDataSourcePerfence() {
        
        self.dataSource = getDataSource()!
    }
    
    func getDataSource() -> UITableViewDiffableDataSource<Int, Person>? {
        //可变类型
//        let tableViewDiffableDataSourceReference = UITableViewDiffableDataSourceReference(tableView: self.tableView) { (tableView, indexPath, Person) -> UITableViewCell? in
//            let cell = tableView.cellForRow(at: indexPath)
//            cell?.textLabel?.text = person.name
//            return cell
//        }
        let dataSource = UITableViewDiffableDataSource<Int, Person>(tableView: self.tableView) { (tableView, indexPath, person) -> UITableViewCell? in
            let cell = tableView.cellForRow(at: indexPath)
            cell?.textLabel?.text = person.name
            return cell
        }
        dataSource.defaultRowAnimation = .automatic
        return dataSource
    }
    
    func updateData(_ noteList: [Person]) {
        //可变类型
//        let diffableDataSourceSnapshotReference = NSDiffableDataSourceSnapshotReference(dataSource: noteList)
        var snapshot = NSDiffableDataSourceSnapshot<Int, Person>()
        snapshot.appendSections([1, 2, 3])     // 对应的section
        snapshot.appendItems(noteList)            // 对应的item
        self.dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
        //使用snapshot对dataSource进行差异化比对，进行动态更新。避免了之前的复杂的维护过程
    }
    
}

//MARK: - UILocalizedIndexedCollation 一个对象的组织，排序和本地化有section index的TableView的数据。
extension ViewController{
    
    
    func initUILocalizedIndexedCollation() {
        
        let localizedIndexedCollation = UILocalizedIndexedCollation.current()
        
//        let sectionNumb = localizedIndexedCollation.sectionIndexTitles.count
//        var sectionArray = []()
    }
}

//MARK: - UITableViewDragDelegate
//extension ViewController: UITableViewDragDelegate {
//    //MARK: - 拖动的目标
//    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let itemProvider = NSItemProvider(contentsOf: URL(string: "https://www.jianshu.com/p/6b252f52b51d"))
////        NSItemProvider(object: itemProvider)
//        let dragItem1 = UIDragItem(itemProvider: itemProvider!)
//        return [dragItem1]
//    }
//    func tableView(_ tableView: UITableView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
//
//    }
//
//
//    func tableView(_ tableView: UITableView, dragSessionWillBegin session: UIDragSession) {
//        print("dragSessionWillBegin")
//    }
//
//
//}
