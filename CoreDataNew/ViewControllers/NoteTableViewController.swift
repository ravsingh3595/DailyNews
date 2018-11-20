//
//  NoteTableViewController.swift
//  CoreDataNew
//
//  Created by Sonia Rani on 2018-11-16.
//  Copyright © 2018 RavSingh. All rights reserved.
//

import UIKit

class NoteTableViewController: UITableViewController {

    let cellIdentifier = "NoteTableViewCell"
    let AddNoteViewControllerIdentifier = "AddNoteViewController"
    
    var searchActive : Bool = false
    
    var data:[String] = ["Dev","Hiren","Bhagyashree","Himanshu","Manisha","Trupti","Prashant","Kishor","Jignesh","Rushi"]
    
     var filterdata:[String]?
    
    @IBOutlet weak var searchBar: UISearchBar!
    //    lazy var searchBar = UISearchBar(frame:CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 90
        
        searchBar.showsCancelButton = true
        
//        searchBar = UISearchBar()
//        searchBar.sizeToFit()
//        navigationItem.titleView = searchBar
    }

    @IBAction func addNoteBarButtonTapped(_ sender: UIBarButtonItem) {
        if let addNoteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: AddNoteViewControllerIdentifier) as? AddNoteViewController
        {
            let destinationNavigationController = self.storyboard?.instantiateViewController(withIdentifier: "AddNoteNavigationViewController") as! UINavigationController
            destinationNavigationController.pushViewController(addNoteViewController, animated: true)
            self.present(destinationNavigationController, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if filterdata?.count != nil 
        {
            return filterdata?.count ?? 0
        }else{
            return 5
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NoteTableViewCell

        // Configure the cell...
        if filterdata?.count != nil
        {
            cell.setValues(title: filterdata?[indexPath.row] ?? "", noteContent: "Math Algerbra Content Math Algerbra Content Math Algerbra Content Math Algerbra Content", dateTimeString: "21 dec, 2018 4: 13 pm")
        }
        else{
             cell.setValues(title: "Math Algerbra Math Algerbra Math Algerbra Math Algerbra", noteContent: "Math Algerbra Content Math Algerbra Content Math Algerbra Content Math Algerbra Content", dateTimeString: "21 dec, 2018 4: 13 pm")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Update", handler:{action, indexpath in
            print("MORE•ACTION");
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            print("DELETE•ACTION");
            self.deleteAlertView()
            
        });
        
        return [deleteRowAction, moreRowAction];
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func deleteAlertView() {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .destructive, handler: { (action) -> Void in
            print("Ok button tapped")
            
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }

}

extension NoteTableViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // filterdata  = searchText.isEmpty ? data : data.filter {(item : String) -> Bool in
        
        filterdata = searchText.isEmpty ? data : data.filter { $0.contains(searchText) }
        
        //return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        tableView.reloadData()
        // Hide the cancel button
//        searchBar.showsCancelButton = false
        // You could also change the position, frame etc of the searchBar
        view.endEditing(true)
        
    }
    
    
}
