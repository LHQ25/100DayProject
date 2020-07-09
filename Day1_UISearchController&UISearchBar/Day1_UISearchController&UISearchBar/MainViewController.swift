
import UIKit

class MainViewController: UITableViewController {
    var countries = Country.countries()
    var searchController: UISearchController!
    var resultsTableViewController: ResultsTableViewController!
    
    
    var searchContinents: [String] {
      // 1
      let tokens = searchController.searchBar.searchTextField.tokens
      // 2
      return tokens.compactMap {
        ($0.representedObject as? Continent)?.description
      }
    }
    
    //是否通过Token进行搜索
    var isSearchingByTokens: Bool {
      return
        searchController.isActive &&
        searchController.searchBar.searchTextField.tokens.count > 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableViewController = storyboard!.instantiateViewController(withIdentifier: "resultsViewController") as? ResultsTableViewController
        
        searchController = UISearchController(searchResultsController: resultsTableViewController)
        navigationItem.searchController = searchController
        //在搜索过程中是否隐藏了基础内容。  显示下面的试图(当前页面搜索)  true时  表示不在当前页面搜索  隐藏底部试图
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "寻找国家"
        searchController.searchBar.scopeButtonTitles = Year.allCases.map { $0.description }  //范围选择按钮
        searchController.automaticallyShowsScopeBar = false //不自动显示范围选择按钮
        searchController.searchBar.delegate = self
        
        //搜索结果代理
        searchController.searchResultsUpdater = self
        
        resultsTableViewController.delegate = self
        
        //修改文字和背景色
        searchController.searchBar.searchTextField.textColor = .rwGreen()
        //修改Token的背景色
        searchController.searchBar.searchTextField.tokenBackgroundColor = .rwGreen()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Continent.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Continent.allCases[section].description
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let continentForSection = Continent.allCases[section]
        return countries[continentForSection]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "country", for: indexPath) as! CountryCell
        let continentForRow = Continent.allCases[indexPath.section]
        cell.country = countries[continentForRow]?[indexPath.row]
        return cell
    }
}

// MARK: -

extension MainViewController {
    
    func searchFor(_ searchText: String?) {
        // 1
        guard searchController.isActive else { return }
        // 2
        guard let searchText = searchText else {
            resultsTableViewController.countries = nil
            return
        }
        // 3
        let selectedYear = selectedScopeYear()
        let allCountries = countries.values.joined()
        let filteredCountries = allCountries.filter { (country: Country) -> Bool in
            // 4
            let isMatchingYear = selectedYear == Year.all.description ?
                true : (country.year.description == selectedYear)
            // 5
            let isMatchingTokens = searchContinents.count == 0 ?
                true : searchContinents.contains(country.continent.description)
            // 6
            if !searchText.isEmpty {
                return
                    isMatchingYear &&
                        isMatchingTokens &&
                        country.name.lowercased().contains(searchText.lowercased())
                // 7
            } else if isSearchingByTokens {
                return isMatchingYear && isMatchingTokens
            }
            // 8
            return false
        }
        // 9
        resultsTableViewController.countries =
            filteredCountries.count > 0 ? filteredCountries : nil
    }
    
    func selectedScopeYear() -> String {
        guard let scopeButtonTitles = searchController.searchBar.scopeButtonTitles else {
            return Year.all.description
        }
        return scopeButtonTitles[searchController.searchBar.selectedScopeButtonIndex]
    }
    
    //控制ScopeBar的显示和隐藏
    func showScopeBar(_ show: Bool) {
        guard searchController.searchBar.showsScopeBar != show else { return }
        searchController.searchBar.setShowsScope(show, animated: true)
        view.setNeedsLayout()
    }
}

// MARK: -

extension MainViewController: UISearchBarDelegate {
    //范围选择按钮 被点击时代理
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let searchText = searchController.searchBar.text else { return }
        searchFor(searchText)
    }
    //搜索栏文本改变
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchFor(searchText)
        
        //搜索文本不为空时显示范围按钮
        let showScope = !searchText.isEmpty
        showScopeBar(showScope)
    }
    //取消按钮被点击
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultsTableViewController.countries = nil
        showScopeBar(false)
        searchController.searchBar.searchTextField.backgroundColor = nil
    }
}

extension MainViewController: UISearchResultsUpdating {
    
    ///搜索结果更新
    func updateSearchResults(for searchController: UISearchController) {
        
        // 1
        if searchController.searchBar.searchTextField.isFirstResponder {
            //展示搜索结果的控制器
          searchController.showsSearchResultsController = true
          // 2
          searchController.searchBar.searchTextField.backgroundColor = UIColor.rwGreen().withAlphaComponent(0.1)
        } else {
          // 3
          searchController.searchBar.searchTextField.backgroundColor = nil
        }
    }
}

//MARK: - Token 点击事件
extension MainViewController: ResultsTableViewDelegate {
    
    func didSelect(token: UISearchToken) {
        // 1
        let searchTextField = searchController.searchBar.searchTextField
        // 2
        searchTextField.insertToken(token, at: searchTextField.tokens.count)
        // 3
        searchFor(searchController.searchBar.text)
        
        showScopeBar(true)
    }
}
