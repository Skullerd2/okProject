import UIKit
import Alamofire
import CoreLocation

final class AppListViewController: UITableViewController, CLLocationManagerDelegate {
    
    private let networkManager = NetworkManager.shared
    private var weather = WeatherModel(main: nil)
    
    let locationManager = CLLocationManager()
    var appList = [AppModel]()
    
    var tableViewStyle: TableViewStyle = .smallCells
    
    var lat: Double = 0
    var lon: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        switch(tableViewStyle){
        case .smallCells:
            tableView.isUserInteractionEnabled = false
        case .normalCells:
            tableView.isUserInteractionEnabled = true
        }
        
    }
    
    @IBAction func unwindToAppList(segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? AddAppViewController,
           let newApp = sourceVC.newApplication {
            appList.append(newApp)
            tableView.reloadData()
        }
    }
    
    @IBAction func changeStyleButtonTapped(_ sender: Any) {
        
        changeStyle()
        let alertController = UIAlertController(title: "Style was changed", message: "New style is \(tableViewStyle)", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
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
    
    @IBAction func unwindToFirstScreen(_ segue: UIStoryboardSegue){
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appList.count
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.appList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "appCell", for: indexPath) as? AppTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: appList[indexPath.row])
        return cell
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
    enum TableViewStyle{
        case smallCells
        case normalCells
    }
    
    private func changeStyle(){
        switch(tableViewStyle){
        case .smallCells:
            tableViewStyle = .normalCells
            tableView.isUserInteractionEnabled = true
        case .normalCells:
            tableViewStyle = .smallCells
            tableView.isUserInteractionEnabled = false
        }
    }
}

