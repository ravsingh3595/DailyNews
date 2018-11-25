//
//  FilterNoteViewController.swift
//  CoreDataNew
//
//  Created by Sonia Rani on 2018-11-22.
//  Copyright © 2018 RavSingh. All rights reserved.
//

import UIKit

enum SortEnum: String {
    case Title = "title"
    case Date = "date"
}

protocol SelectSortOptionProtocol {
    func sortNote(sortOption: String, viewController: UIViewController)
}

class FilterNoteViewController: UIViewController {
    
    var delegate: SelectSortOptionProtocol?
    @IBOutlet weak var filterTableView: UITableView!
    
    var filterArray = ["Title", "Date"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       
      
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getSortValue() -> String {
        var name = ""
        if (UserDefaults.standard.string(forKey: "sort_option") != nil){
            name = UserDefaults.standard.string(forKey: "sort_option") ?? ""
            print(name)
        }
        return name
    }
    
}

extension FilterNoteViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filterArray[indexPath.row]
        if filterArray[indexPath.row] == getSortValue() {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }else{
             cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(filterArray[indexPath.row], forKey: "sort_option")
        self.delegate?.sortNote(sortOption: filterArray[indexPath.row], viewController: self)
    }
    
    
}

