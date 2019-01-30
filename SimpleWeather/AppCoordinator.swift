//
//  AppCoordinator.swift
//  SimpleWeather
//
//  Created by Ruffolo Antonio on 30/01/2019.
//  Copyright © 2019 Antonio Ruffolo. All rights reserved.
//

import Foundation

class AppCordinator
{
  weak var mapController: MapViewController!
  
  init(mapController: MapViewController)
  {
    self.mapController = mapController
  }
  
  func configureMapController()
  {
    let service: ForecastDataService = ForecastDataService()
    mapController.viewModel = MapViewModel(view: mapController, forecastDataService: service)
  }
}
