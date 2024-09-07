import Foundation

struct WeatherModel: Decodable{
    
    var main: MainDataWeather?
    
    init(main: MainDataWeather?) {
        self.main = main
    }
}

struct MainDataWeather: Decodable{
    let temp: Double
}
