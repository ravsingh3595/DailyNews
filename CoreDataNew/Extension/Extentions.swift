//
//  Extentions.swift
//  CoreDataNew
//
//  Created by Sonia Rani on 2018-11-16.
//  Copyright © 2018 RavSingh. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    func roundImage() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
}


extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
