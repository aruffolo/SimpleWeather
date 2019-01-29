//
//  NSLayoutConstraint+ChangeMultiplier.swift
//  SimpleWeather
//
//  Created by Antonio Ruffolo on 29/01/2019.
//  Copyright © 2019 Antonio Ruffolo. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint
{
  func changeMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint
  {
    let ar = [ self ]
    NSLayoutConstraint.deactivate(ar)

    let newConstraint = NSLayoutConstraint.init(item: firstItem as Any,
                                                attribute: firstAttribute,
                                                relatedBy: relation,
                                                toItem: secondItem,
                                                attribute: secondAttribute,
                                                multiplier: multiplier,
                                                constant: constant)

    newConstraint.priority = priority
    newConstraint.shouldBeArchived = shouldBeArchived
    newConstraint.identifier = identifier

    let ar2 = [ newConstraint ]
    NSLayoutConstraint.activate(ar2)

    return newConstraint
  }
}
