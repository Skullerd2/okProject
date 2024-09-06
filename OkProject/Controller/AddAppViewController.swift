//
//  AddAppViewController.swift
//  OkProject
//
//  Created by Vadim on 06.09.2024.
//

import UIKit

class AddAppViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var fontSegmentedControl: UISegmentedControl!
    @IBOutlet weak var colorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var appPickerView: UIPickerView!
    
    let appList: [String] = ["weather", "location"]
    let fontList: [String] = ["Helvetica Neue", "Arial", "Verdana"]
    let colorList: [String: UIColor] = ["white": .white, "green": .green, "red": .red]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        appList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return appList[row]
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        var row = 0
        
        if let component = appPickerView?.selectedRow(inComponent: 0){
            row = component
        }
        
        let selectedIndex = colorSegmentedControl.selectedSegmentIndex
        
        var newApplication = AppModel(appName: appList[row], appFont: UIFont(name: fontList[fontSegmentedControl.selectedSegmentIndex], size: 17)!, appColor: colorList[colorSegmentedControl.titleForSegment(at: selectedIndex)!]!, data: "")
    }
    
}
