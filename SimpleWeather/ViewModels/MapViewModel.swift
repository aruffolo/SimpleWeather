//
//  MapViewModel.swift
//  SimpleWeather
//
//  Created by Antonio Ruffolo on 29/01/2019.
//  Copyright © 2019 Antonio Ruffolo. All rights reserved.
//

import Foundation
import MapKit

class MapViewModel: NSObject
{
  private let coordinateSeparator: String = ","
  
  private let geocoder: Geocoder
  let manager = CLLocationManager()
  private weak var view: MapViewProtocol?
  private let forecastDataService: ForecastDataServiceProtocol

  init(view: MapViewProtocol, forecastDataService: ForecastDataServiceProtocol)
  {
    self.view = view
    self.forecastDataService = forecastDataService
    geocoder = Geocoder()
  }

  public func viewIsReady()
  {
    manager.delegate = self
    manager.requestWhenInUseAuthorization()
    manager.requestLocation()
  }

  public func searcLocationRequested(input: String)
  {
    if isCoordinates(input: input)
    {
      let coor = createCoordinatesFromInput(input)
      print(coor)
      
      let coordinate = CLLocationCoordinate2D(latitude: coor.lat, longitude: coor.lng)

      view?.zoomToLocation(coordinate: coordinate)
      fetchForecastUsingCoordinate(coordinate)
      // not uses, I leave just in case I would need location information based on the coordinate provided
      //geocoder.reverseGeocode(lat: coor.lat, lng: coor.lng, completitionHandler: coordinateLookup)
    }
    else // must be name of location
    {
      geocoder.getCoordinate(addressString: input, completitionHandler: placemarkLookUp)
      fetchForecastUsingLocation(input)
    }
  }

  private func fetchForecastUsingCoordinate(_ coordinate: CLLocationCoordinate2D)
  {
    forecastDataService.fetchForecastUsingCoordinate(coordinate: coordinate, completition: { data in
      guard let d = data
        else
      {
        self.view?.hideForecastView()
        return
      }
      print(d)
      self.view?.fillForecastData(data: d)
    })
  }

  private func fetchForecastUsingLocation(_ location: String)
  {
    forecastDataService.fetchForecastUsingLocation(location, completition: { data in
      guard let d = data
        else
      {
        self.view?.hideForecastView()
        return
      }
      print(d)
      self.view?.fillForecastData(data: d)
    })
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
}

extension MapViewModel: CLLocationManagerDelegate
{
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
  {
    if let location = locations.first
    {
      print("Found user's location: \(location)")
      view?.zoomToLocation(coordinate: location.coordinate)
      fetchForecastUsingCoordinate(location.coordinate)
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failed to find user's location: \(error.localizedDescription)")
  }
}
