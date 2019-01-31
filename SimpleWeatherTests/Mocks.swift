//
//  Mocks.swift
//  SimpleWeatherTests
//
//  Created by Antonio Ruffolo on 30/01/2019.
//  Copyright © 2019 Antonio Ruffolo. All rights reserved.
//

import Foundation
import MapKit

@testable import SimpleWeather

public struct ForeCastDataServiceMock: ForecastDataServiceProtocol
{
  // Those two could be just moved into a JSON file into the resources of the project
  let rendeLocation: String = "{\"coord\":{\"lon\":16.19,\"lat\":39.35},\"weather\":[{\"id\":601,\"main\":\"Snow\",\"description\":\"snow\",\"icon\":\"13n\"},{\"id\":741,\"main\":\"Fog\",\"description\":\"fog\",\"icon\":\"50n\"},{\"id\":501,\"main\":\"Rain\",\"description\":\"moderate rain\",\"icon\":\"10n\"}],\"base\":\"stations\",\"main\":{\"temp\":3.92,\"pressure\":996,\"humidity\":92,\"temp_min\":-1,\"temp_max\":8},\"visibility\":50,\"wind\":{\"speed\":4.1},\"clouds\":{\"all\":90},\"dt\":1548874620,\"sys\":{\"type\":1,\"id\":6692,\"message\":0.0035,\"country\":\"IT\",\"sunrise\":1548828230,\"sunset\":1548864829},\"id\":2523623,\"name\":\"Rende\",\"cod\":200}"

  let sanFrancisco: String = "{\"coord\":{\"lon\":-122.41,\"lat\":37.79},\"weather\":[{\"id\":721,\"main\":\"Haze\",\"description\":\"haze\",\"icon\":\"50d\"},{\"id\":701,\"main\":\"Mist\",\"description\":\"mist\",\"icon\":\"50d\"}],\"base\":\"stations\",\"main\":{\"temp\":14.25,\"pressure\":1014,\"humidity\":82,\"temp_min\":12,\"temp_max\":17},\"visibility\":11265,\"wind\":{\"speed\":3.1,\"deg\":180},\"clouds\":{\"all\":20},\"dt\":1548881580,\"sys\":{\"type\":1,\"id\":4322,\"message\":0.0041,\"country\":\"US\",\"sunrise\":1548861281,\"sunset\":1548898313},\"id\":5391959,\"name\":\"San Francisco\",\"cod\":200}"

  public func fetchForecastUsingLocation(_ location: String,
                                  completition: @escaping (ForecastViewData?) -> Void)
  {
    let decoder = JSONDecoder()
    if let data = sanFrancisco.data(using: .utf8)
    {
      let weather = try? decoder.decode(CurrentWeather.self, from: data)
      completition(createForecastViewData(weather: weather))
    }
    else
    {
      completition(nil)
    }
  }

  public func fetchForecastUsingCoordinate(coordinate: CLLocationCoordinate2D,
                                    completition: @escaping (ForecastViewData?) -> Void)
  {
    let decoder = JSONDecoder()
    if let data = rendeLocation.data(using: .utf8)
    {
      let weather = try? decoder.decode(CurrentWeather.self, from: data)
      completition(createForecastViewData(weather: weather))
    }
    else
    {
      completition(nil)
    }
  }

  private func createForecastViewData(weather: CurrentWeather?) -> ForecastViewData?
  {
    guard let weath = weather, let descr = weather?.weather.first?.description else { return nil }
    return ForecastViewData(city: weath.name,
                            forecastDescription: descr,
                            temperature: weath.main.temp,
                            minTemperature: weath.main.tempMin,
                            maxTemperature: weath.main.tempMax,
                            humidity: weath.main.humidity)
  }
}

public struct ForeCastDataFailServiceMock: ForecastDataServiceProtocol
{
  public func fetchForecastUsingLocation(_ location: String,
                                         completition: @escaping (ForecastViewData?) -> Void)
  {
    completition(nil)
  }

  public func fetchForecastUsingCoordinate(coordinate: CLLocationCoordinate2D,
                                           completition: @escaping (ForecastViewData?) -> Void)
  {
    completition(nil)
  }
}

public class MapControllerMock: MapViewProtocol
{
  var success: ((ForecastViewData) -> Void)?
  var fail: (() -> Void)?
  
  var data: ForecastViewData? = nil

  public func zoomToLocation(coordinate: CLLocationCoordinate2D)
  {
  }

  public func fillForecastData(data: ForecastViewData)
  {
    self.data = data
    success?(data)
  }

  public func hideForecastView()
  {
    fail?()
  }
}
