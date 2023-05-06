//
//  UIView.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/5/5.
//

import Foundation
import UIKit

extension UIView {
    func roundCorners(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}
