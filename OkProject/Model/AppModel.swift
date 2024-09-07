import Foundation
import UIKit

struct AppModel{
    var appName: String
    var appFont: UIFont
    var appColor: UIColor
    var data: String
    
    init(appName: String, appFont: UIFont, appColor: UIColor, data: String) {
        self.appName = appName
        self.appFont = appFont
        self.appColor = appColor
        self.data = data
    }
    
}
