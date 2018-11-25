//
//  CommonFunctions.swift
//  CoreDataNew
//
//  Created by Sonia Rani on 2018-11-17.
//  Copyright © 2018 RavSingh. All rights reserved.
//

import UIKit

class CommonFunctions {
    
    
    static func showAlert(title: String, message: String, myViewController: UIViewController) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertViewController.addAction(alertOk)
        myViewController.present(alertViewController, animated: true, completion: nil)
    }

}
