//
//  MapViewModel.swift
//  SimpleWeather
//
//  Created by Antonio Ruffolo on 29/01/2019.
//  Copyright © 2019 Antonio Ruffolo. All rights reserved.
//

import Foundation
import MapKit

class MapViewModel
{
  private let coordinateSeparator: String = ";"
  
  let geocoder: Geocoder
  weak var view: MapViewProtocol?

  init(view: MapViewProtocol)
  {
    self.view = view
    geocoder = Geocoder()
  }

  public func searcLocationRequested(input: String)
  {
    if isCoordinates(input: input)
    {
      let coor = createCoordinatesFromInput(input)
      print(coor)
      
      let coordinate = CLLocationCoordinate2D(latitude: coor.lat, longitude: coor.lng)
      
      tryToUseApi(coordinate: coordinate)

      view?.zoomToLocation(coordinate: coordinate)
      // not uses, I leave just in case I would need location information based on the coordinate provided
      //geocoder.reverseGeocode(lat: coor.lat, lng: coor.lng, completitionHandler: coordinateLookup)
    }
    else // must be name of location
    {
      geocoder.getCoordinate(addressString: input, completitionHandler: placemarkLookUp)
    }
  }

  // Here I suppose that coordinate input is valid only if corrdinate numbers have '.' as decimal separator and
  // ';' as lat and lng separator
  private func isCoordinates(input: String) -> Bool
  {
    let splitted = input.replacingOccurrences(of: " ", with: "").split(separator: Character(coordinateSeparator))
    return splitted.count == 2 && Double(splitted[0]) != nil && Double(splitted[1]) != nil
  }

  private func createCoordinatesFromInput(_ input: String) -> (lat: Double, lng: Double)
  {
    let splitted = input.replacingOccurrences(of: " ", with: "").split(separator: Character(coordinateSeparator))
    guard splitted.count == 2, let lat = Double(splitted[0]), let lng = Double(splitted[1])
    else
    {
      fatalError("this should be called only with valid input")
    }

    return (lat: lat, lng: lng)
  }
  
  private lazy var coordinateLookup: (CLPlacemark?) -> Void = { placemark in
    // TODO: here I should do something
  }
  
  private lazy var placemarkLookUp: (CLLocationCoordinate2D, NSError?) -> Void = { (coordinate, error) in
    self.view?.zoomToLocation(coordinate: coordinate)
  }

  private func tryToUseApi(coordinate: CLLocationCoordinate2D)
  {
    ApiClient
      .currentWeather(lat: String(coordinate.latitude),
                      lng: String(coordinate.longitude),
                      completion: { result in

                        if result.isSuccess, let weather = result.value
                        {
                          print(weather)
                        }
      })
//    ApiClient
//      .currentWeather(location: "London,uk",
//                      completion: { result in
//
//                        if result.isSuccess, let weather = result.value
//                        {
//                          print(weather)
//                        }
//      })
  }
}
