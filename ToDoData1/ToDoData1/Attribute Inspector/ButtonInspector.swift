//
//  Inspector.swift
//  ToDoData1
//
//  Created by Droadmin on 12/12/23.
//

import Foundation
import UIKit

@IBDesignable extension UIButton {
    @IBInspectable var corneRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    @IBInspectable var shadawColor: UIColor? {
           get {
               return UIColor(cgColor: layer.shadowColor ?? UIColor.clear.cgColor)
           }
           set {
               layer.shadowColor = newValue?.cgColor
           }
       }
       
    @IBInspectable var shadawOpacity: Float {
           get {
               return layer.shadowOpacity
           }
           set {
               layer.shadowOpacity = newValue
           }
       }
       
    @IBInspectable var shadawOffset: CGSize {
           get {
               return layer.shadowOffset
           }
           set {
               layer.shadowOffset = newValue
           }
       }
       
    @IBInspectable  var shadawRadius: CGFloat {
           get {
               return layer.shadowRadius
           }
           set {
               layer.shadowRadius = newValue
           }
       }
}
