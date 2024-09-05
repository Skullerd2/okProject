import UIKit
import Alamofire
import CoreLocation

final class AppListViewController: UITableViewController, CLLocationManagerDelegate {
    
    private let networkManager = NetworkManager.shared
    private var weather = WeatherModel(main: nil)
    let locationManager = CLLocationManager()
    
    var lat: Double = 0
    var lon: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
            print(lat, lon)
            reverseGeocode(location: location)
            fetchCurrentWeather()
        }
    }
    
    func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let firstPlacemark = placemarks?.first {
                print(firstPlacemark.locality ?? "Location not found")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Add new application", message: "Choose new application", preferredStyle: .actionSheet)
        alertController.addTextField()
    }
    
}

extension AppListViewController{
    
    func fetchCurrentWeather(){
        networkManager.fetchCurrentWeather(lat: lat, lon: lon) { [weak self] result in
            switch result{
            case .success(let weather):
                self?.weather = weather
                print(Int(round(weather.main!.temp)))
            case .failure(let error):
                print("Error in fetch current weather: \(error.localizedDescription)")
            }
        }
    }
}

extension AppListViewController{
    enum tableViewStyle{
        case smallCells
        case normalCells
        case bigCells
    }
    
    func changeStyle(to: tableViewStyle){
        
    }
}

