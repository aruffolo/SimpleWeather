//
//  APIConstants.swift
//  SimpleWeather
//
//  Created by Ruffolo Antonio on 30/01/2019.
//  Copyright © 2019 Antonio Ruffolo. All rights reserved.
//

import Foundation

struct APIParameterKey
{
  static let lat = "lat"
  static let lng = "lon"
  
  static let q = "q"
  
  static let appId = "appid"
  
  static let measureUnit = "units"
}

enum HTTPHeaderField: String
{
  case authentication = "Authorization"
  case contentType = "Content-Type"
  case acceptType = "Accept"
  case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String
{
  case json = "application/json"
}
