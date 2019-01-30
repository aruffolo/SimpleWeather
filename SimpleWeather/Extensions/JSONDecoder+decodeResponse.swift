//
//  JSONDecoder+decodeResponse.swift
//  SimpleWeather
//
//  Created by Antonio Ruffolo on 30/01/2019.
//  Copyright © 2019 Antonio Ruffolo. All rights reserved.
//

import Foundation
import Alamofire

extension JSONDecoder
{
  func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T>
  {
    guard response.error == nil else
    {
      print(response.error!)
      return .failure(response.error!)
    }

    guard let responseData = response.data else
    {
      print("didn't get any data from API")
      return .failure(BackendError.parsing(reason:
        "Did not get data in response"))
    }

    do
    {
      let item = try decode(T.self, from: responseData)
      return .success(item)
    }
    catch
    {
      print("error trying to decode response")
      print(error)
      return .failure(error)
    }
  }
}

enum BackendError: Error
{
  case parsing(reason: String)
}
