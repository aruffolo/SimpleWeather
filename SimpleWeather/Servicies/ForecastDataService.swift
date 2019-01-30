//
//  ForecastDataService.swift
//  SimpleWeather
//
//  Created by Ruffolo Antonio on 30/01/2019.
//  Copyright © 2019 Antonio Ruffolo. All rights reserved.
//

import MapKit

protocol ForecastDataServiceProtocol
{
  func fetchForecastUsingLocation(_ location: String,
                                  completition: @escaping (ForecastViewData?) -> Void)
  
  func fetchForecastUsingCoordinate(coordinate: CLLocationCoordinate2D,
                                    completition: @escaping (ForecastViewData?) -> Void)
}

public struct ForecastDataService: ForecastDataServiceProtocol
{
  func fetchForecastUsingLocation(_ location: String,
                                  completition: @escaping (ForecastViewData?) -> Void)
  {
    ApiClient.currentWeather(location: location, completion: { result in
      if result.isSuccess, let weather = result.value
      {
        completition(self.createForecastViewData(weather: weather))
      }
    })
  }
  
  func fetchForecastUsingCoordinate(coordinate: CLLocationCoordinate2D,
                                    completition: @escaping (ForecastViewData?) -> Void)
  {
    ApiClient
      .currentWeather(lat: String(coordinate.latitude),
                      lng: String(coordinate.longitude),
                      completion: { result in
                        
                        if result.isSuccess, let weather = result.value
                        {
                          completition(self.createForecastViewData(weather: weather))
                        }
      })
  }
  
  private func createForecastViewData(weather: CurrentWeather) -> ForecastViewData?
  {
    guard let descr = weather.weather.first?.description else { return nil }
    return  ForecastViewData(city: weather.name,
                             forecastDescription: descr,
                             temperature: String(weather.main.temp),
                             minTemperature: String(weather.main.tempMin),
                             maxTemperature: String(weather.main.tempMax),
                             humidity: String(weather.main.humidity))
  }
}
