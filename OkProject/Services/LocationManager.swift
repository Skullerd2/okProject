//
//  LocationManager.swift
//  OkProject
//
//  Created by Vadim on 07.09.2024.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate{
    
    static let shared = LocationManager()
    
    let locationManager = CLLocationManager()
    
    var lat: Double = 0
    var lon: Double = 0
    
    private var completionHandler: ((Double, Double) -> Void)?
    
    private override init() {}
    
    func fetchCurrentLocation(completion: @escaping (Double, Double) -> Void){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        self.completionHandler = completion
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
            reverseGeocode(location: location)
            completionHandler?(lat, lon)
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Ошибка определения местоположения: \(error.localizedDescription)")
    }
}
