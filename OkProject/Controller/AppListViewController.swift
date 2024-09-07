import UIKit
import Alamofire

final class AppListViewController: UITableViewController {
    
    private let networkManager = NetworkManager.shared
    let locationManager = LocationManager.shared
    
    private var weather = WeatherModel(main: nil)
    private var location = LocationModel(main: nil)
    
    private var weatherData = ""
    private var locationData = ""
    
    var currentCellHeight: CGFloat = UIScreen.main.bounds.height / 8.0
    
    var appList: [AppModel] = [
        AppModel(appName: "weather", appFont: UIFont(name: "Arial", size: 17)!, appColor: .white, data: ""),
        AppModel(appName: "weather", appFont: UIFont(name: "Arial", size: 17)!, appColor: .white, data: ""),
        AppModel(appName: "location", appFont: UIFont(name: "Arial", size: 17)!, appColor: .white, data: ""),
        AppModel(appName: "location", appFont: UIFont(name: "Arial", size: 17)!, appColor: .white, data: ""),
        AppModel(appName: "weather", appFont: UIFont(name: "Arial", size: 17)!, appColor: .white, data: ""),
        AppModel(appName: "weather", appFont: UIFont(name: "Arial", size: 17)!, appColor: .white, data: ""),
        AppModel(appName: "location", appFont: UIFont(name: "Arial", size: 17)!, appColor: .white, data: ""),
        AppModel(appName: "location", appFont: UIFont(name: "Arial", size: 17)!, appColor: .white, data: ""),
        AppModel(appName: "location", appFont: UIFont(name: "Arial", size: 17)!, appColor: .white, data: ""),
        AppModel(appName: "weather", appFont: UIFont(name: "Arial", size: 17)!, appColor: .white, data: "")
    ]
    
    var tableViewStyle: TableViewStyle = .smallCells
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        switch(tableViewStyle){
        case .smallCells:
            tableView.isUserInteractionEnabled = false
        case .normalCells:
            tableView.isUserInteractionEnabled = true
        }
        
        DispatchQueue.main.async {
            if self.appList.contains(where: { $0.appName == "location" }){
                self.fetchCurrentLocation()
            }
        }
        if self.appList.contains(where: { $0.appName == "weather" }){
            self.fetchCurrentWeather()
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
        tableView.beginUpdates()
        tableView.endUpdates()
        let alertController = UIAlertController(title: "Style was changed", message: "New style is \(tableViewStyle)", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
    @IBAction func unwindToFirstScreen(_ segue: UIStoryboardSegue){
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return currentCellHeight
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
        
        switch (appList[indexPath.row].appName){
        case "weather":
            if weatherData == ""{
                fetchCurrentWeather()
                weatherData = appList[indexPath.row].data
            } else{
                appList[indexPath.row].data = weatherData
            }
        case "location":
            if locationData == ""{
                fetchCurrentLocation()
                locationData = appList[indexPath.row].data
            } else{
                appList[indexPath.row].data = locationData
            }
        default:
            break
        }
        cell.configure(with: appList[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBigVC"{
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as? BigAppViewController
                destinationVC!.sender = appList[indexPath.row].appName
                destinationVC?.dataText = appList[indexPath.row].data
            }
        }
    }
}

extension AppListViewController{
    
    func fetchCurrentLocation(){
        locationManager.fetchCurrentLocation(senderVC: "location") { [weak self] lat, lon in
            self?.locationManager.getCity(lat: lat, lon: lon, completion: {[weak self] result in
                self?.locationData = result
                self?.updateAppListData(forAppName: "location", newData: result)
                self?.tableView.reloadData()
            })
        }
    }
    
    func fetchCurrentWeather(){
        locationManager.fetchCurrentLocation(senderVC: "weather") { [weak self] lat, lon in
            self?.networkManager.fetchCurrentWeather(lat: lat, lon: lon) { [weak self] result in
                switch result{
                case .success(let weather):
                    self?.weather = weather
                    self!.weatherData = "temp: \(String(Int(round(weather.main!.temp))))"
                    self?.updateAppListData(forAppName: "weather", newData: "temp: \(self!.weatherData)")
                case .failure(let error):
                    print(error)
                    self?.weatherData = "temp: Error"
                    self?.updateAppListData(forAppName: "weather", newData: "temp: Error")
                }
                self?.tableView.reloadData()
            }
        }
    }
    
    private func updateAppListData(forAppName appName: String, newData: String) {
        for (index, app) in appList.enumerated() where app.appName == appName {
            appList[index].data = newData
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
            currentCellHeight = UIScreen.main.bounds.height / 2.0
            tableView.isUserInteractionEnabled = true
        case .normalCells:
            tableViewStyle = .smallCells
            currentCellHeight = UIScreen.main.bounds.height / 8.0
            tableView.isUserInteractionEnabled = false
        }
    }
}

