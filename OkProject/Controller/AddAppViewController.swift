import UIKit

class AddAppViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var fontSegmentedControl: UISegmentedControl!
    @IBOutlet weak var colorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var appPickerView: UIPickerView!
    
    var appListVC = AppListViewController()
    var newApplication: AppModel?
    
    let appList: [String] = ["weather", "location"]
    let fontList: [String] = ["Helvetica Neue", "Arial", "Verdana"]
    let colorList: [String: UIColor] = ["white": .white, "green": .green, "red": .red]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        appPickerView.delegate = self
        appPickerView.dataSource = self
        
        fontSegmentedControl.removeAllSegments()
        colorSegmentedControl.removeAllSegments()
        
        for (index, color) in colorList.enumerated(){
            let colorName = color.key
            colorSegmentedControl.insertSegment(withTitle: colorName, at: index, animated: true)
        }
        for (index, font) in fontList.enumerated() {
            fontSegmentedControl.insertSegment(withTitle: font, at: index, animated: true)
        }
        
        fontSegmentedControl.selectedSegmentIndex = 0
        colorSegmentedControl.selectedSegmentIndex = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "toFirstScreenSave":
            prepareFirstScreen(segue)
        default:
            break
        }
    }
    
    private func prepareFirstScreen(_ segue: UIStoryboardSegue){
        guard let destinationController = segue.destination as? AppListViewController else{
            return
        }
        
        var row = 0
        let selectedIndex = colorSegmentedControl.selectedSegmentIndex
        
        if let component = appPickerView?.selectedRow(inComponent: 0){
            row = component
        }
        
        newApplication = AppModel(appName: appList[row], appFont: UIFont(name: fontList[fontSegmentedControl.selectedSegmentIndex], size: 17)!, appColor: colorList[colorSegmentedControl.titleForSegment(at: selectedIndex)!]!, data: "")
        destinationController.appList.append(newApplication!)
        destinationController.tableView.reloadData()
  //      appListVC.fetchCurrentWeather()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        appList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return appList[row]
    }
}
