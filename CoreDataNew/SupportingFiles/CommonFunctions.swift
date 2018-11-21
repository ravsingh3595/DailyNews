//
//  CommonFunctions.swift
//  CoreDataNew
//
//  Created by Sonia Rani on 2018-11-17.
//  Copyright © 2018 RavSingh. All rights reserved.
//

import UIKit

class CommonFunctions {
    
    static func deleteAlertView(title: String, message: String) {
        let respose = Bool()
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
//            self.deleteRecord()
            
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
//        self.present(dialogMessage, animated: true, completion: nil)
     
    }
    
    static func showAlert(title: String, message: String, myViewController: UIViewController) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertViewController.addAction(alertOk)
        myViewController.present(alertViewController, animated: true, completion: nil)
    }

}
