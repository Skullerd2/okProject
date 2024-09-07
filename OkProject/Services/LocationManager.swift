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
    private var completionHandlerLocation: ((String) -> Void)?
    private var sender: String = ""
    
    private override init() {}
    
    func fetchCurrentLocation(senderVC: String ,completion: @escaping (Double, Double) -> Void){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        sender = senderVC
        self.completionHandler = completion
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
            completionHandler?(lat, lon)
        }
    }
    
    func getCity(lat: Double, lon: Double, completion: @escaping ((String) -> Void)){
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lon)
        var loc = ""
        
        self.completionHandlerLocation = completion
        
        geocoder.reverseGeocodeLocation(location) {[weak self] (placemarks, error) in
            if let firstPlacemark = placemarks?.first {
                loc = firstPlacemark.locality ?? "Error"
                self?.completionHandlerLocation!(loc)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Ошибка определения местоположения: \(error.localizedDescription)")
    }
}
