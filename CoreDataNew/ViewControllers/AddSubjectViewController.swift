//
//  AddSubjectViewController.swift
//  CoreDataNew
//
//  Created by Sonia Rani on 2018-11-18.
//  Copyright © 2018 RavSingh. All rights reserved.
//

import UIKit

protocol SendSavedSubjectProtocol {
    func saveSubject(title: String, viewController: UIViewController, isEdit: Bool, index: Int)
}

class AddSubjectViewController: UIViewController {

    @IBOutlet weak var txtSubjectTitle: UITextField!

    var delegate: SendSavedSubjectProtocol?
    var subject: Subject?
    var isEdit: Bool!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if isEdit {
            txtSubjectTitle.text = subject?.subjectTitle
        }
    }
    
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        print(txtSubjectTitle.text ?? "")
        if txtSubjectTitle.text == "" {
            CommonFunctions.showAlert(title: "Warning", message: "Please enter title", myViewController: self)
        }else{
            self.delegate?.saveSubject(title: txtSubjectTitle.text ?? "", viewController: self, isEdit: self.isEdit, index: self.index)
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
