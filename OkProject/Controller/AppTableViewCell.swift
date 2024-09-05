import UIKit

class AppTableViewCell: UITableViewCell {

    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appData: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
