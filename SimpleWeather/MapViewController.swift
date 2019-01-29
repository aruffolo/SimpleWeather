//
//  ViewController.swift
//  SimpleWeather
//
//  Created by Antonio Ruffolo on 28/01/2019.
//  Copyright © 2019 Antonio Ruffolo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController
{
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var searchView: UIView!
  @IBOutlet weak var searchViewTextField: UITextField!
  @IBOutlet weak var searchViewWidthConstraint: NSLayoutConstraint!

  private let searchButtonSide: CGFloat = 30
  private let searchButtonWidthMargin: CGFloat = 18
  private var compactMultiplier: CGFloat = 0.0
  private var expandedMultiplier: CGFloat = 0.0

  private var searchFieldIsExpanded: Bool = false

  private var viewModel: MapViewModel!

  override func viewDidLoad()
  {
    super.viewDidLoad()
    viewModel = MapViewModel(view: self)
    searchViewTextField.delegate = self
    setViewStyle()
  }

  private func setViewStyle()
  {
    searchView.layer.cornerRadius = searchView.frame.height / 2
  }

  override func viewWillAppear(_ animated: Bool)
  {
    super.viewWillAppear(animated)

    initSearchViewLayout()
  }

  private func initSearchViewLayout()
  {
    setMultipliersForSearchViewWidth()
    shrinkSearchView()
    searchViewTextField.isHidden = true
  }

  private func setMultipliersForSearchViewWidth()
  {
    let width = UIScreen.main.bounds.width
    compactMultiplier =  (searchButtonSide + searchButtonWidthMargin) / width
    expandedMultiplier = searchViewWidthConstraint.multiplier
  }

  private func shrinkSearchView()
  {
    searchViewWidthConstraint = searchViewWidthConstraint.changeMultiplier(compactMultiplier)
    view.layoutIfNeeded()
  }

  @IBAction func searchViewButtonAction(_ sender: UIButton)
  {
    if searchFieldIsExpanded
    {
      viewModel.searcLocationRequested(input: searchViewTextField.text ?? "")
      searchViewTextField.resignFirstResponder()
      shrinkSearchViewAnim()
    }
    else
    {
      expandSearchViewAnim()
    }
    searchFieldIsExpanded = !searchFieldIsExpanded
  }

  private func expandSearchViewAnim()
  {
    searchViewWidthConstraint = searchViewWidthConstraint.changeMultiplier(expandedMultiplier)
    UIView.animate(withDuration: 0.3, animations: {
      self.view.layoutIfNeeded()
    }, completion: { _ in
      self.searchViewTextField.isHidden = false
      self.searchViewTextField.becomeFirstResponder()
    })
  }

  private func shrinkSearchViewAnim()
  {
    searchViewTextField.isHidden = true
    searchViewWidthConstraint = searchViewWidthConstraint.changeMultiplier(compactMultiplier)
    UIView.animate(withDuration: 0.3, animations: {
      self.view.layoutIfNeeded()
    }, completion: { _ in
      // nothing to do here for now
    })
  }
}

extension MapViewController: UITextFieldDelegate
{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool
  {
    shrinkSearchViewAnim()
    viewModel.searcLocationRequested(input: textField.text ?? "")
    textField.text = ""
    return textField.resignFirstResponder()
  }
}

extension MapViewController: MapViewProtocol
{
  func zoomToLocation(coordinate: CLLocationCoordinate2D)
  {
      centerMapOnLocation(coordinate: coordinate)
  }
  
  func centerMapOnLocation(coordinate: CLLocationCoordinate2D)
  {
    guard CLLocationCoordinate2DIsValid(coordinate) else { return }
    let regionRadius: CLLocationDistance = 1000
    let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                              latitudinalMeters: regionRadius,
                                              longitudinalMeters: regionRadius)
    mapView.setRegion(coordinateRegion, animated: true)
  }
}
