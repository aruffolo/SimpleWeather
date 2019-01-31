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

      vm.searchLocation(input: "San Francisco")

      XCTAssert(vcMock.data?.city == "San Francisco")
    }

  func testSearchLocationWithCoordinate()
  {
    let vcMock = MapControllerMock()
    let forecastMock = ForeCastDataServiceMock()
    let vm = MapViewModel(view: vcMock, forecastDataService: forecastMock)

    vm.searchLocation(input: "16.19,39.35")
    XCTAssert(vcMock.data?.city == "Rende")
  }
  
  func testSuccessAsyncSearchLocationWithLocationName()
  {
    let vcMock = MapControllerMock()
    let forecastMock = ForecastDataService()
    let vm = MapViewModel(view: vcMock, forecastDataService: forecastMock)
    
    vm.searchLocation(input: "San Francisco")
    
    let completedExpectation = expectation(description: "Completed")
    
    vcMock.success = { data in
      completedExpectation.fulfill()
      XCTAssert(vcMock.data?.city == "San Francisco")
    }
    
    vcMock.fail = {
      completedExpectation.fulfill()
      XCTFail("not retrieved data")
    }
    
    waitForExpectations(timeout: 5, handler: { error in
      if (error != nil)
      {
        XCTFail("waitForExpectationsWithTimeout errored: \(String(describing: error))")
      }
    })
  }
  
  func testSuccessAsyncSearchLocationWithCoordinate()
  {
    let vcMock = MapControllerMock()
    let forecastMock = ForecastDataService()
    let vm = MapViewModel(view: vcMock, forecastDataService: forecastMock)
    
    vm.searchLocation(input: "16.19, 39.35")
    let completedExpectation = expectation(description: "Completed")
    
    vcMock.success = { data in
      completedExpectation.fulfill()
      XCTAssert(vcMock.data?.city.contains("Zoba") ?? false)
    }
    
    vcMock.fail = {
      completedExpectation.fulfill()
      XCTFail("not retrieved data")
    }
    
    waitForExpectations(timeout: 5, handler: { error in
      if (error != nil)
      {
        XCTFail("waitForExpectationsWithTimeout errored: \(String(describing: error))")
      }
    })
  }
  
  func testFailAsyncSearchLocationWithCoordinate()
  {
    let vcMock = MapControllerMock()
    let forecastMock = ForecastDataService()
    let vm = MapViewModel(view: vcMock, forecastDataService: forecastMock)
    
    vm.searchLocation(input: "16%19, 39.35")
    let completedExpectation = expectation(description: "Completed")
    
    vcMock.success = { data in
      completedExpectation.fulfill()
      XCTFail("data should have not been retrieved")
    }
    
    vcMock.fail = {
      completedExpectation.fulfill()
      // it's true because in this case the call must fail
      XCTAssert(true)
    }
    
    waitForExpectations(timeout: 5, handler: { error in
      if (error != nil)
      {
        XCTFail("waitForExpectationsWithTimeout errored: \(String(describing: error))")
      }
    })
  }
  
  func testFailAsyncSearchLocationWithLocationName()
  {
    let vcMock = MapControllerMock()
    let forecastMock = ForecastDataService()
    let vm = MapViewModel(view: vcMock, forecastDataService: forecastMock)
    
    vm.searchLocation(input: "anonamethasshouldfaillocationfinding")
    
    let completedExpectation = expectation(description: "Completed")
    
    vcMock.success = { data in
      completedExpectation.fulfill()
      XCTFail("data should have not been retrieved")
    }
    
    vcMock.fail = {
      completedExpectation.fulfill()
      // it's true because in this case the call must fail
      XCTAssert(true)
    }
    
    waitForExpectations(timeout: 5, handler: { error in
      if (error != nil)
      {
        XCTFail("waitForExpectationsWithTimeout errored: \(String(describing: error))")
      }
    })
  }

  func testSearchLocationWithLocationNameFail()
  {
    let vcMock = MapControllerMock()
    let forecastMock = ForeCastDataFailServiceMock()
    let vm = MapViewModel(view: vcMock, forecastDataService: forecastMock)

    vm.searchLocation(input: "San Francisco")

    XCTAssert(vcMock.data == nil)
  }

  func testSearchLocationWithCoordinateFail()
  {
    let vcMock = MapControllerMock()
    let forecastMock = ForeCastDataFailServiceMock()
    let vm = MapViewModel(view: vcMock, forecastDataService: forecastMock)

    vm.searchLocation(input: "16.19,39.35")
    XCTAssert(vcMock.data == nil)
  }
}
