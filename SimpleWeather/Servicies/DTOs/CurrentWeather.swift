//
//  CurrentWeather.swift
//  SimpleWeather
//
//  Created by Antonio Ruffolo on 30/01/2019.
//  Copyright © 2019 Antonio Ruffolo. All rights reserved.
//

// Note this has been created using 'quicktype' :D

// To parse the JSON, add this file to your project and do:
//
//   let currentWeather = try? newJSONDecoder().decode(CurrentWeather.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseCurrentWeather { response in
//     if let currentWeather = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct CurrentWeather: Codable {
  let coord: Coord?
  let weather: [Weather]
  let base: String
  let main: Main
  let visibility: Int?
  let wind: Wind?
  let rain: Rain?
  let clouds: Clouds?
  let dt: Int?
  let sys: Sys?
  let id: Int?
  let name: String
  let cod: Int?
}

struct Clouds: Codable {
  let all: Int
}

struct Coord: Codable {
  let lon, lat: Double
}

struct Main: Codable {
  let temp: Double
  let pressure: Double?
  let humidity: Int
  let tempMin, tempMax: Double

  enum CodingKeys: String, CodingKey {
    case temp, pressure, humidity
    case tempMin = "temp_min"
    case tempMax = "temp_max"
  }
}

struct Rain: Codable {
  let the3H: Double?
  let the1H: Double?
  enum CodingKeys: String, CodingKey {
    case the3H = "3h"
    case the1H = "1h"
  }
}

struct Sys: Codable {
  let type, id: Int?
  let message: Double?
  let country: String?
  let sunrise, sunset: Int? 
}

struct Weather: Codable {
  let id: Int?
  let main: String?
  let description, icon: String
}

struct Wind: Codable {
  let speed: Double?
  let deg: Double?
}

func newJSONDecoder() -> JSONDecoder {
  let decoder = JSONDecoder()
  if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
    decoder.dateDecodingStrategy = .iso8601
  }
  return decoder
}

func newJSONEncoder() -> JSONEncoder {
  let encoder = JSONEncoder()
  if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
    encoder.dateEncodingStrategy = .iso8601
  }
  return encoder
}
