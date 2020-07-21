

import UIKit

final class TeacherTableViewCell: UITableViewCell {
    @IBOutlet private weak var thumbnailBorderView: UIView!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbnailBorderView.layer.cornerRadius = 45
        thumbnailBorderView.layer.masksToBounds = true
        
        thumbnailImageView.layer.cornerRadius = 41
        thumbnailImageView.layer.masksToBounds = true
    }
    
    func setTeacher(_ teacher: Teacher) {
        nameLabel.text = teacher.name
        thumbnailImageView.image = UIImage(named: teacher.imageName)
    }
}
