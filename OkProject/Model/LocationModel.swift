//
//  LocationModel.swift
//  OkProject
//
//  Created by Vadim on 07.09.2024.
//

import Foundation
import CoreLocation

struct LocationModel{
    
    var main: MainDataLocation?
    
    init(main: MainDataLocation?) {
        self.main = main
    }
}

struct MainDataLocation{
    var lat: Double
    var lon: Double
    var city: String
}
