
import UIKit

class MainViewController: UITableViewController {
    var countries = Country.countries()
    var searchController: UISearchController!
    var resultsTableViewController: ResultsTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableViewController = storyboard!.instantiateViewController(withIdentifier: "resultsViewController") as? ResultsTableViewController
        
        searchController = UISearchController(searchResultsController: resultsTableViewController)
        navigationItem.searchController = searchController
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find a country"
        searchController.searchBar.scopeButtonTitles = Year.allCases.map { $0.description }
        searchController.searchBar.delegate = self
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
        guard searchController.isActive else { return }
        guard let searchText = searchText else {
            resultsTableViewController.countries = nil
            return
        }
        let selectedYear = selectedScopeYear()
        let allCountries = countries.values.joined()
        let filteredCountries = allCountries.filter { (country: Country) -> Bool in
            let isMatchingYear = selectedYear == Year.all.description ? true : (country.year.description == selectedYear)
            if searchText != "" {
                return isMatchingYear && country.name.lowercased().contains(searchText.lowercased())
            }
            return false
        }
        resultsTableViewController.countries = filteredCountries
    }
    
    func selectedScopeYear() -> String {
        guard let scopeButtonTitles = searchController.searchBar.scopeButtonTitles else {
            return Year.all.description
        }
        return scopeButtonTitles[searchController.searchBar.selectedScopeButtonIndex]
    }
}

// MARK: -

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let searchText = searchController.searchBar.text else { return }
        searchFor(searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchFor(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultsTableViewController.countries = nil
    }
}
