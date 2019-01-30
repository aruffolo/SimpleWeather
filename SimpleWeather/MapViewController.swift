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
  @IBOutlet weak var forecastView: UIView!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var forecastLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var minTemperatureLabel: UILabel!
  @IBOutlet weak var maxTemperatureLabel: UILabel!
  
  private let searchButtonSide: CGFloat = 30
  private let searchButtonWidthMargin: CGFloat = 18
  private var compactMultiplier: CGFloat = 0.0
  private var expandedMultiplier: CGFloat = 0.0

  private var searchFieldIsExpanded: Bool = false

  public var viewModel: MapViewModel!

  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    searchViewTextField.delegate = self
    setViewStyle()
    setInitialValues()
  }

  private func setViewStyle()
  {
    searchView.layer.cornerRadius = searchView.frame.height / 2
    searchView.layer.shadowOffset = .zero
    searchView.layer.shadowOpacity = 0.4
    searchView.layer.shadowRadius = 10
    searchView.layer.shadowColor = UIColor.black.cgColor
  }

  private func setInitialValues()
  {
    forecastView.isHidden = true
    let minus = "-"
    cityLabel.text = minus
    forecastLabel.text = minus
    temperatureLabel.text = minus
    minTemperatureLabel.text = minus
    maxTemperatureLabel.text = minus
    humidityLabel.text = minus
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
      if let content = searchViewTextField.text, !content.isEmpty
      {
        viewModel.searcLocationRequested(input: content)
      }
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
    if let content = textField.text, !content.isEmpty
    {
      viewModel.searcLocationRequested(input: content)
      textField.text = ""
    }
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
  
  func fillForecastData(data: ForecastViewData)
  {
    fillLabels(data: data)
    animateForcastViewFadeIn()
  }

  private func fillLabels(data: ForecastViewData)
  {
    let centrigades = "o"
    cityLabel.text = data.city
    forecastLabel.text = data.forecastDescription

    let temperature = createSuperScriptString(font: temperatureLabel.font,
                                              content: data.temperature + centrigades,
                                              subscriptChar: centrigades,
                                              baselineOffset: 50,
                                              subscriptSize: 20)
    temperatureLabel.attributedText = temperature


    let minTemperature = createSuperScriptString(font: minTemperatureLabel.font,
                                                 content: data.minTemperature + centrigades,
                                                 subscriptChar: centrigades,
                                                 baselineOffset: 10,
                                                 subscriptSize: 10)
    minTemperatureLabel.attributedText = minTemperature

    let maxTemperature = createSuperScriptString(font: maxTemperatureLabel.font,
                                                 content: data.maxTemperature + centrigades,
                                                 subscriptChar: centrigades,
                                                 baselineOffset: 10,
                                                 subscriptSize: 10)
    maxTemperatureLabel.attributedText = maxTemperature
    humidityLabel.text = data.humidity + " %"
  }

  private func animateForcastViewFadeIn()
  {
    UIView.animate(withDuration: 0.4, animations: {
      self.forecastView.isHidden = false
    })
  }

  private func createSuperScriptString(font: UIFont,
                                       content: String,
                                       subscriptChar: String,
                                       baselineOffset: CGFloat,
                                       subscriptSize: CGFloat) -> NSAttributedString
  {
    let fontSuper = font.withSize(subscriptSize)
    let attrString: NSMutableAttributedString = NSMutableAttributedString(string: content, attributes: [.font: font])
    if let range = content.range(of: subscriptChar)
    {
      let nsRange = NSRange(range, in: content)
      attrString.setAttributes([.font: fontSuper, .baselineOffset: baselineOffset], range: nsRange)
    }

    return attrString
  }

  func hideForecastView()
  {
    forecastView.isHidden = true
  }
}
