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
    AF.request(ApiRouter.weatherCoordinate(lat: lat, lng: lng)).responseData(completionHandler: { response in
      printReposne(response: response)
      let decoder = JSONDecoder()
      let currentWeather: Result<CurrentWeather> = decoder.decodeResponse(from: response)
      completion(currentWeather)
    })
  }

  static func currentWeather(location: String, completion: @escaping (Result<CurrentWeather>) -> Void)
  {
    AF.request(ApiRouter.weatherName(name: location)).responseData(completionHandler: { response in
      printReposne(response: response)
      let decoder = JSONDecoder()
      let currentWeather: Result<CurrentWeather> = decoder.decodeResponse(from: response)
      completion(currentWeather)
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
