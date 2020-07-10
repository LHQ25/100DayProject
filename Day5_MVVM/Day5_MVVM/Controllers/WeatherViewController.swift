

import UIKit

class WeatherViewController: UIViewController {
    
    
    
    
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentIcon: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var forecastSummary: UITextView!
    
    private let viewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        
        viewModel.locationName.bind { [weak self] locationName in
          self?.cityLabel.text = locationName
        }
        
        viewModel.icon.bind { [weak self] image in
          self?.currentIcon.image = image
        }
            
        viewModel.summary.bind { [weak self] summary in
          self?.currentSummaryLabel.text = summary
        }
            
        viewModel.forecastSummary.bind { [weak self] forecast in
          self?.forecastSummary.text = forecast
        }
    }
    
    @IBAction func promptForLocation(_ sender: UIButton) {
        //1
        let alert = UIAlertController(title: "Choose location", message: nil, preferredStyle: .alert)
        alert.addTextField()
        //2
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alert, weak self] _ in
            guard let newLocation = alert.textFields?.first?.text else { return }
            self?.viewModel.changeLocation(to: newLocation)
        }
        alert.addAction(submitAction)
        //3
        present(alert, animated: true)
    }
}
