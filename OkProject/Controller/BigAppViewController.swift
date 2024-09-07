//
//  BigAppViewController.swift
//  OkProject
//
//  Created by Vadim on 07.09.2024.
//

import UIKit

class BigAppViewController: UIViewController {

    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var appDataLabel: UILabel!
    
    var sender: String = ""
    var dataText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = sender
        appDataLabel.text = dataText
        if sender == "weather"{
            appIcon.image = UIImage(named: "weatherIcon.png")
        } else if sender == "location"{
            appIcon.image = UIImage(named: "locationIcon.png")
        }
    }

}
