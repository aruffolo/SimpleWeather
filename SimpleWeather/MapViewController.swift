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
  private let searchButtonLeading: CGFloat = 18
  private var compactMultiplier: CGFloat = 0.0
  private var expandedMultiplier: CGFloat = 0.0

  private var searchFieldIsExpanded: Bool = false

  override func viewDidLoad()
  {
    super.viewDidLoad()
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
    compactMultiplier =  (searchButtonSide + searchButtonLeading) / width
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

