import Foundation
import Alamofire


final class NetworkManager{
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchCurrentWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherModel, AFError>) -> Void){
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let headers: HTTPHeaders = [
            "x-rapidapi-key": "27500767bcmshb28e0005a978693p18fc05jsne3f789cbe92b",
            "x-rapidapi-host": "open-weather13.p.rapidapi.com"
        ]
        
        AF.request("https://open-weather13.p.rapidapi.com/city/latlon/\(lat)/\(lon)&units=metric", headers: headers)
            .validate()
            .responseDecodable(of: WeatherModel.self, decoder: decoder) { dataResponse in
                switch dataResponse.result{
                case .success(let weather):
                    completion(.success(weather))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

