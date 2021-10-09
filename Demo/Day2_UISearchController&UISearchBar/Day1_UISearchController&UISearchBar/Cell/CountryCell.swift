
import UIKit

class CountryCell: UITableViewCell {
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    
    var country: Country? {
        didSet {
            guard let country = country else { return }
            countryLabel.text = country.name
            yearLabel.text = country.year.description
            populationLabel.text = country.formattedPopulation
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        selectionStyle = .none
    }
}
