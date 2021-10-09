
import UIKit

class SearchTokenCell: UITableViewCell {
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var continentImageView: UIImageView!
    
    var token: UISearchToken! {
        didSet {
            guard let continent = token?.representedObject as? Continent else {
                return
            }
            tokenLabel.text = "Search by \(continent.description)"
            continentImageView.image = UIImage(systemName: "globe")
            continentImageView.tintColor = .rwGreen()
        }
    }
}
