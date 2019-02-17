//
//  ApiClient.swift
//  SimpleWeather
//
//  Created by Antonio Ruffolo on 30/01/2019.
//  Copyright © 2019 Antonio Ruffolo. All rights reserved.
//

import Alamofire

class ApiClient
{
  static func currentWeather(lat: String, lng: String, completion: @escaping (Result<CurrentWeather>) -> Void)
  {
    request(ApiRouter.weatherCoordinate(lat: lat, lng: lng), completion: completion)
  }

  static func currentWeather(location: String, completion: @escaping (Result<CurrentWeather>) -> Void)
  {
    request(ApiRouter.weatherName(name: location), completion: completion)
  }

  private static func request<T: Codable> (_ urlConvertible: URLRequestConvertible,
                                           completion: @escaping (Result<T>) -> Void)
  {
    AF.request(urlConvertible).responseData(completionHandler:{ (dataResponse: DataResponse<Data>) in
      printReposne(response: dataResponse)
      let decoder = JSONDecoder()
      let response: Result<T> = decoder.decodeResponse(from: dataResponse)
      completion(response)
    })
  }
  
  private static func printReposne(response: DataResponse<Data>)
  {
    guard let value = response.result.value,
      let string = NSString(data: value, encoding: String.Encoding.utf8.rawValue)
      else { return }
    
    print("response is:\n \(string)")
  }
}
