//
//  WeatherRequest.swift
//  SimpleWeather
//
//  Created by Antonio Ruffolo on 06/10/2019.
//  Copyright © 2019 Antonio Ruffolo. All rights reserved.
//

import Foundation

struct CoordinateRequest: Codable
{
  let lat: String
  let lng: String
  let appId: String = Constants.apiKey
  let measureUnit: String = "metric"

  enum CodingKeys: String, CodingKey
  {
    case appId = "appid"
    case measureUnit = "units"
    case lat = "lat"
    case lng = "lon"
  }
}

struct LocationRequest: Codable
{
  let name: String
  let appId: String = Constants.apiKey
  let measureUnit: String = "metric"

  enum CodingKeys: String, CodingKey
  {
    case appId = "appid"
    case measureUnit = "units"
    case name = "q"
  }
}
