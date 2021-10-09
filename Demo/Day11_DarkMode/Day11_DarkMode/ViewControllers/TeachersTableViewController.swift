
import UIKit

final class TeachersTableViewController: UITableViewController {
    private lazy var teachers: [Teacher] = {
        guard
            let fileURL = Bundle.main.url(forResource: "teachers", withExtension: "json"),
            let data = try? Data(contentsOf: fileURL)
            else {
                print("Failed to read teachers file")
                return []
        }
        
        return (try? JSONDecoder().decode([Teacher].self, from: data)) ?? []
    }()
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        teachers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "TeacherCell",
            for: indexPath) as? TeacherTableViewCell
            else {
                print("This type of cell is not defined")
                return UITableViewCell()
        }
        
        cell.setTeacher(teachers[indexPath.row])
        
        return cell
    }
    
    // MARK: - Navigation
    
    @IBSegueAction func showDetail(_ coder: NSCoder, sender: Any?) -> UIViewController? {
        guard
            let cell = sender as? TeacherTableViewCell,
            let indexPath = tableView.indexPath(for: cell)
            else {
                return nil
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        return TeacherDetailViewController(coder: coder, teacher: teachers[indexPath.row])
    }
}
