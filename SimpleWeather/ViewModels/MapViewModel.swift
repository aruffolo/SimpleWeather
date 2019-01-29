//
//  MapViewModel.swift
//  SimpleWeather
//
//  Created by Antonio Ruffolo on 29/01/2019.
//  Copyright © 2019 Antonio Ruffolo. All rights reserved.
//

import Foundation

class MapViewModel
{
  public func searcLocationRequested(input: String)
  {
    if isCoordinates(input: input)
    {
      print(createCoordinatesFromInput(input))
    }
    else // must be name of location
    {

    }
  }

  // Here I suppose that coordinate input is valid only if corrdinate numbers have '.' as decimal separator and
  // ';' as lat and lng separator
  private func isCoordinates(input: String) -> Bool
  {
    let splitted = input.replacingOccurrences(of: " ", with: "").split(separator: ",")
    return splitted.count == 2 && Double(splitted[0]) != nil && Double(splitted[1]) != nil
  }

  private func createCoordinatesFromInput(_ input: String) -> (lat: Double, lng: Double)
  {
    let splitted = input.replacingOccurrences(of: " ", with: "").split(separator: ";")
    guard splitted.count == 2, let lat = Double(splitted[0]), let lng = Double(splitted[1])
    else
    {
      fatalError("this should be called only with valid input")
    }

    return (lat: lat, lng: lng)
  }
}
