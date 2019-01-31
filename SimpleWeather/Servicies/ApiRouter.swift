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

public enum ApiRouter: URLRequestConvertible
{
  case weatherCoordinate(lat: String, lng: String)
  case weatherName(name: String)
  
  var method: HTTPMethod
  {
    switch self
    {
    case .weatherCoordinate( _, _),
         .weatherName(_):
      return .get
    }
  }
  
  var path: String
  {
    switch self
    {
    case .weatherCoordinate(_,_),
         .weatherName(_):
      return "/weather"
    }
  }
  
  var parameters: Parameters? 
  {
    switch self
    {
    case .weatherCoordinate(let lat, let lng):
      return [APIParameterKey.lat: lat, APIParameterKey.lng: lng, APIParameterKey.appId: Constants.apiKey, "units": "metric"]
    case .weatherName(let name):
      return [APIParameterKey.q: name, APIParameterKey.appId: Constants.apiKey, APIParameterKey.measureUnit: Constants.measureUnitValue]
    }
  }
  
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
      if let parameters = parameters
      {
        do
        {
          urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        catch
        {
          throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
      }
      return urlRequest
    }
    else
    {
      let finalRerquest = try encoding.encode(urlRequest, with: parameters)
      print("GET request url\n: \(String(describing: finalRerquest.url?.absoluteString))")
      return finalRerquest
    }
  }
}
