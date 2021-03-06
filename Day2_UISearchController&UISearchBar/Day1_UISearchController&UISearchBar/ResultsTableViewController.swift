

import UIKit

protocol ResultsTableViewDelegate: class {
    func didSelect(token: UISearchToken)
}

class ResultsTableViewController: UITableViewController {
    
    //UISearchToken 数组
    var searchTokens: [UISearchToken] = []
    //Token 代理  点击事件
    weak var delegate: ResultsTableViewDelegate?
    
    ///当前搜索的结果为空时  显示  UISearchToken
    var isFilteringByCountry: Bool {
        return countries != nil
    }
    
    //搜索结果
    var countries: [Country]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化Token
        makeTokens()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return isFilteringByCountry ? (countries?.count ?? 0) : searchTokens.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isFilteringByCountry, let cell = tableView.dequeueReusableCell(withIdentifier: "results", for: indexPath) as? CountryCell {
            // 1
            cell.country = countries?[indexPath.row]
            return cell
        } else if let cell = tableView.dequeueReusableCell( withIdentifier: "search", for: indexPath) as? SearchTokenCell {
            // 2
            cell.token = searchTokens[indexPath.row]
            return cell
        }
        // 3
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard !isFilteringByCountry else { return }
        delegate?.didSelect(token: searchTokens[indexPath.row])
        
    }
}

extension ResultsTableViewController {
    
    ///创建  UISearchToken
    func makeTokens() {
        // 1
        let continents = Continent.allCases
        searchTokens = continents.map { (continent) -> UISearchToken in
            // 2
            let globeImage = UIImage(systemName: "globe")
            let token = UISearchToken(icon: globeImage, text: continent.description)
            // 3
            token.representedObject = Continent(rawValue: continent.description)
            // 4
            return token
        }
    }
}
