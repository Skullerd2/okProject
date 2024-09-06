import UIKit

class AppTableViewCell: UITableViewCell {

    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appData: UILabel!
    
    func configure(with appModel: AppModel){
        appName.text = appModel.appName
        appName.font = appModel.appFont
        self.backgroundColor = appModel.appColor
        appData.text = appModel.data
    }
}
