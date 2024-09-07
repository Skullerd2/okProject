import UIKit
import Alamofire

final class AppListViewController: UITableViewController {
    
    private let networkManager = NetworkManager.shared
    let locationManager = LocationManager.shared
    
    private var weather = WeatherModel(main: nil)
    private var location = LocationModel(main: nil)
    
    
    var appList = [AppModel]()
    
    var tableViewStyle: TableViewStyle = .smallCells
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        switch (appList[indexPath.row].appName){
        case "weather":
            fetchCurrentWeather(forCellAt: indexPath)
        case "location":
            print("location")
        default:
            break
        }
        cell.configure(with: appList[indexPath.row])
        return cell
    }
}

extension AppListViewController{
    
    func fetchCurrentWeather(forCellAt indexPath: IndexPath){
        locationManager.fetchCurrentLocation { [weak self] lat, lon in
            self?.networkManager.fetchCurrentWeather(lat: lat, lon: lon) { [weak self] result in
                switch result{
                case .success(let weather):
                   
                    DispatchQueue.main.async {
                        self?.weather = weather
                        self?.appList[indexPath.row].data = String(round(weather.main!.temp))
                        self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                case .failure(let error):
                    print(error)
                    self?.appList[indexPath.row].data = "Error"
                }
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

