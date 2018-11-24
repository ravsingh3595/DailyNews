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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.sortNote(sortOption: filterArray[indexPath.row], viewController: self)
    }
}
