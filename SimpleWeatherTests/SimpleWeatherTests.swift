//
//  SimpleWeatherTests.swift
//  SimpleWeatherTests
//
//  Created by Antonio Ruffolo on 30/01/2019.
//  Copyright © 2019 Antonio Ruffolo. All rights reserved.
//

import XCTest

import Foundation
import MapKit

@testable import SimpleWeather

class SimpleWeatherTests: XCTestCase
{

    override func setUp()
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchLocationWithLocationName()
    {
      let vcMock = MapControllerMock()
      let forecastMock = ForeCastDataServiceMock()
      let vm = MapViewModel(view: vcMock, forecastDataService: forecastMock)

      vm.searcLocationRequested(input: "San Francisco")

      XCTAssert(vcMock.data?.city == "San Francisco")
    }

  func testSearchLocationWithCoordinate()
  {
    let vcMock = MapControllerMock()
    let forecastMock = ForeCastDataServiceMock()
    let vm = MapViewModel(view: vcMock, forecastDataService: forecastMock)

    vm.searcLocationRequested(input: "16.19,39.35")
    XCTAssert(vcMock.data?.city == "Rende")
  }

  func testSearchLocationWithLocationNameFail()
  {
    let vcMock = MapControllerMock()
    let forecastMock = ForeCastDataFailServiceMock()
    let vm = MapViewModel(view: vcMock, forecastDataService: forecastMock)

    vm.searcLocationRequested(input: "San Francisco")

    XCTAssert(vcMock.data == nil)
  }

  func testSearchLocationWithCoordinateFail()
  {
    let vcMock = MapControllerMock()
    let forecastMock = ForeCastDataFailServiceMock()
    let vm = MapViewModel(view: vcMock, forecastDataService: forecastMock)

    vm.searcLocationRequested(input: "16.19,39.35")
    XCTAssert(vcMock.data == nil)
  }

    func testPerformanceExample()
    {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
