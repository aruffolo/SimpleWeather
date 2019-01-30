//
//  ForecastViewData.swift
//  SimpleWeather
//
//  Created by Ruffolo Antonio on 30/01/2019.
//  Copyright © 2019 Antonio Ruffolo. All rights reserved.
//

public struct ForecastViewData
{
  let city: String
  let forecastDescription: String
  let temperature: String
  let minTemperature: String
  let maxTemperature: String
  let humidity: String

  init(city: String,
       forecastDescription: String,
       temperature: Double,
       minTemperature: Double,
       maxTemperature: Double,
       humidity: Int)
  {
    self.city = city
    self.forecastDescription = forecastDescription
    self.temperature = String(Int(temperature.rounded()))
    self.minTemperature = String(Int(minTemperature.rounded()))
    self.maxTemperature = String(Int(maxTemperature.rounded()))
    self.humidity = String(humidity)
  }
}
