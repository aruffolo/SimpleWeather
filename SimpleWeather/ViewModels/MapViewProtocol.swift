//
//  MapViewProtocol.swift
//  SimpleWeather
//
//  Created by Ruffolo Antonio on 29/01/2019.
//  Copyright © 2019 Antonio Ruffolo. All rights reserved.
//

import Foundation
import MapKit

protocol MapViewProtocol: class
{
  func zoomToLocation(coordinate: CLLocationCoordinate2D)
}
