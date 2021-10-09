
import UIKit

class MasterViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchFooter: SearchFooter!
    @IBOutlet var searchFooterBottomConstraint: NSLayoutConstraint!
    
    let searchController = UISearchController(searchResultsController: nil)
    //数据源
    var candies: [Candy] = []
    //搜索结果
    var filteredCandies: [Candy] = []
    //搜索内容是否为空
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    //是否正在搜索
    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //数据源
        candies = Candy.candies()
        
        //配置
        // 1  搜索结果代理
        searchController.searchResultsUpdater = self
        // 2  是否在当前页面搜索  默认false
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search Candies"
        // 4
        navigationItem.searchController = searchController
        // 5 当视图控制器或其后代之一提供视图控制器时是否覆盖该视图控制器的视图。 确保在UISearchController处于活动状态时用户导航到另一个视图控制器时，搜索栏不会保留在屏幕上。
        definesPresentationContext = true
        
        //添加范围选择
        searchController.searchBar.scopeButtonTitles = Candy.Category.allCases.map { $0.rawValue }
        searchController.searchBar.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification)
        }
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification)
        }
    }
    
    //键盘监听  修改searchFooter的位置
    func handleKeyboard(notification: Notification) {
        // 1
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            searchFooterBottomConstraint.constant = 0
            view.layoutIfNeeded()
            return
        }
        
        guard let info = notification.userInfo, let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }
        
        // 2
        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.searchFooterBottomConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
        })
    }
    
    //搜索结果
    func filterContentForSearchText(_ searchText: String, category: Candy.Category? = nil) {
        filteredCandies = candies.filter { (candy: Candy) -> Bool in
            let doesCategoryMatch = category == .all || candy.category == category
            
            if isSearchBarEmpty {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && candy.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //取消已经选择的cell
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowDetailSegue", let indexPath = tableView.indexPathForSelectedRow, let detailViewController = segue.destination as? DetailViewController else {
                return
        }
        //传递数据
        let candy: Candy
        if isFiltering {
          candy = filteredCandies[indexPath.row]
        } else {
          candy = candies[indexPath.row]
        }
        detailViewController.candy = candy
    }
}

extension MasterViewController: UISearchBarDelegate {
    //范围选择
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let category = Candy.Category(rawValue: searchBar.scopeButtonTitles![selectedScope])
        
        filterContentForSearchText(searchBar.text!, category: category)
    }
}

extension MasterViewController: UISearchResultsUpdating {
    ///搜索结果
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let category = Candy.Category(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        filterContentForSearchText(searchBar.text!, category: category)
    }
}


extension MasterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredCandies.count, of: candies.count)
            return filteredCandies.count
        }
        
        searchFooter.setNotFiltering()
        return candies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let candy: Candy
        if isFiltering {
          candy = filteredCandies[indexPath.row]
        } else {
          candy = candies[indexPath.row]
        }
        cell.textLabel?.text = candy.name
        cell.detailTextLabel?.text = candy.category.rawValue
        return cell
    }
}
