
import Foundation

struct WeatherModel: Decodable{
    
    var main: MainData?
    
    init(main: MainData?) {
        self.main = main
    }
}

struct MainData: Decodable{
    let temp: Double
}
