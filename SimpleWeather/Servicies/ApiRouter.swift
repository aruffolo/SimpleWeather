//
//  ApiRouter.swift
//  SimpleWeather
//
//  Created by Antonio Ruffolo on 30/01/2019.
//  Copyright © 2019 Antonio Ruffolo. All rights reserved.
//

import Foundation
import Alamofire

enum Constants
{
  static let baseURLPath = "https://api.openweathermap.org/data/2.5"
  static let apiKey = "b15366113cdfdf40d6e24896299fe64a"
  static let measureUnitValue = "metric"
}

enum ApiRouter: URLRequestConvertible
{
  case weatherCoordinate(coordinateRequest: CoordinateRequest)
  case weatherName(locationRequest: LocationRequest)
  
  var method: HTTPMethod
  {
    switch self
    {
    case .weatherCoordinate,
         .weatherName:
      return .get
    }
  }
  
  var path: String
  {
    switch self
    {
    case .weatherCoordinate,
         .weatherName:
      return "/weather"
    }
  }
  
//  var parameters: Parameters?
//  {
//    switch self
//    {
//    case .weatherCoordinate(let lat, let lng):
//      return [APIParameterKey.lat: lat, APIParameterKey.lng: lng, APIParameterKey.appId: Constants.apiKey, "units": "metric"]
//    case .weatherName(let name):
//      return [APIParameterKey.q: name, APIParameterKey.appId: Constants.apiKey, APIParameterKey.measureUnit: Constants.measureUnitValue]
//    }
//  }
  
  var encoding: ParameterEncoding
  {
    switch method
    {
    case .get:
      return URLEncoding.default
    default:
      return JSONEncoding.default
    }
  }
  
  public func asURLRequest() throws -> URLRequest
  {
    let url = try Constants.baseURLPath.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    
    // HTTP Method
    urlRequest.httpMethod = method.rawValue
    
    // Common Headers
    urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
    
    if method == .post
    {
        let codable: Any = getConcreateCodables()
        do
        {
          urlRequest.httpBody = try JSONSerialization.data(withJSONObject: codable, options: .prettyPrinted)
        }
        catch
        {
          throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
      return urlRequest
    }
    else
    {
      switch self {
      case .weatherCoordinate(let coordinateRequest):
         urlRequest = try URLEncodedFormParameterEncoder.default.encode(coordinateRequest, into: urlRequest)
      case .weatherName(let locationRequest):
         urlRequest = try URLEncodedFormParameterEncoder.default.encode(locationRequest, into: urlRequest)
      }
      print("GET request url\n: \(String(describing: urlRequest.url?.absoluteString))")
      return urlRequest
    }
  }

  private func getConcreateCodables() -> Any {
    switch self {
    case .weatherCoordinate(let coordinateReques):
      return coordinateReques
    case .weatherName(let locationRequest):
      return locationRequest
    }
  }
}
