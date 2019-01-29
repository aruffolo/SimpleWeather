//
//  Geocoder.swift
//  SimpleWeather
//
//  Created by Ruffolo Antonio on 29/01/2019.
//  Copyright © 2019 Antonio Ruffolo. All rights reserved.
//

import Foundation
import MapKit

public struct Geocoder
{
  private let geocoder = CLGeocoder()

  public func reverseGeocode(lat: Double, lng: Double,
                             completitionHandler: @escaping (CLPlacemark?) -> Void)
  {
    let location = CLLocation(latitude: lat, longitude: lng)
    geocoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
      if error == nil
      {
        let firstPlacemark = placemarks?[0]
        completitionHandler(firstPlacemark)
      }
    })
  }
  
  func getCoordinate(addressString : String,
                     completitionHandler: @escaping (CLLocationCoordinate2D, NSError?) -> Void)
  {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(addressString) { (placemarks, error) in
      if error == nil {
        if let placemark = placemarks?[0], let location = placemark.location
        {
          completitionHandler(location.coordinate, nil)
          return
        }
      }
      completitionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
    }
  }
}
