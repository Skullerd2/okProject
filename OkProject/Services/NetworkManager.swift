import Foundation
import Alamofire


final class NetworkManager{
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchCurrentWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherModel, AFError>) -> Void){
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let headers: HTTPHeaders = [
            "x-rapidapi-key": "a4188e96edmshb23954a4b6eb650p19dc54jsnf5b9a733e953",
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

