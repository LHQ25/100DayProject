
import UIKit

class FileCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: FileCell.self)
    
    ///缩略图
    @IBOutlet weak var thumbnailImageView: UIImageView!
    ///名称
    @IBOutlet weak var nameLabel: UILabel!
    
    func update(with file: File) {
        nameLabel.text = file.name
        
        file.generateThumbnail { [weak self] image in
            DispatchQueue.main.async {
                self?.thumbnailImageView.image = image
            }
        }
    }
}
