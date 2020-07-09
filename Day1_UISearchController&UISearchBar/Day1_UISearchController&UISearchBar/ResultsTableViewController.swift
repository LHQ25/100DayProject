

import UIKit

class ResultsTableViewController: UITableViewController {
    var countries: [Country]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if
            let cell = tableView.dequeueReusableCell(withIdentifier: "results", for: indexPath) as? CountryCell {
            cell.country = countries?[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}
