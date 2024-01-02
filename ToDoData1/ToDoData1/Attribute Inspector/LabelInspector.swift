//
//  LabelInspector.swift
//  ToDoData1
//
//  Created by Droadmin on 19/12/23.
//

import Foundation
import UIKit
@IBDesignable extension UILabel {
    
    @IBInspectable  var corneraRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
}
