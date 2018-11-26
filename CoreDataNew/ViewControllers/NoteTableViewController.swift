//
//  NoteTableViewController.swift
//  CoreDataNew
//
//  Created by Sonia Rani on 2018-11-16.
//  Copyright © 2018 RavSingh. All rights reserved.
//

import UIKit
import CoreData

class NoteTableViewController: UITableViewController, SelectSortOptionProtocol {
    
    let cellIdentifier = "NoteTableViewCell"
    let AddNoteViewControllerIdentifier = "AddNoteViewController"
    var searchActive : Bool = false
    var subject: Subject?
    var data:[String] = ["Dev","Hiren","Bhagyashree","Himanshu","Manisha","Trupti","Prashant","Kishor","Jignesh","Rushi"]
    var filterdata:[String]?
    var noteArray: [Note]?
    var searchedDataArray: [Note]?
    var sortData: [Note]? = nil
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 90
        
        searchBar.showsCancelButton = true
        
        
        self.title = subject?.subjectTitle
        
            //    lazy var searchBar = UISearchBar(frame:CGRect.zero)
//        searchBar = UISearchBar()
//        searchBar.sizeToFit()
//        navigationItem.titleView = searchBar
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.getDataForSubject(subject: subject!.subjectTitle!)
        tableView.reloadData()
    }

    @IBAction func addNoteBarButtonTapped(_ sender: UIBarButtonItem) {
        if let addNoteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: AddNoteViewControllerIdentifier) as? AddNoteViewController
        {
            addNoteViewController.isEdit = false
            addNoteViewController.subject = subject
            self.navigationController?.pushViewController(addNoteViewController, animated: true)

        }
    }
    
    @IBAction func sortNoteButtonTapped(_ sender: UIBarButtonItem) {
        showModally()
    }
    
    func sortNote(sortOption: String, viewController: UIViewController) {
        print(sortOption)
        if sortOption == "Date" {
            self.sortData = self.noteArray?.sorted(by: { $0.date!.compare($1.date!) == .orderedAscending })
            for obj in self.sortData! {
                print("Sorted Date: \(obj.date) with title: \(obj.title)")
            }
        }else{
            self.sortData = self.noteArray?.sorted(by: { $0.title!.compare($1.title!) == .orderedAscending })
            for obj in self.sortData! {
                print("Sorted Date: \(obj.date) with title: \(obj.title)")
            }
            
        }
        tableView.reloadData()
        viewController.dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchedDataArray?.count != nil
        {
            return searchedDataArray?.count ?? 0
        }else if sortData?.count != nil{
             return sortData?.count ?? 0
        }else{
            return noteArray?.count ?? 0 
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NoteTableViewCell
        cell.onFavButtonTapped = {value in
            print("Value: ", value)
        }
        // Configure the cell...
        if searchedDataArray?.count != nil
        {
            cell.setValues(title: searchedDataArray?[indexPath.row].title ?? "", noteContent: searchedDataArray?[indexPath.row].content ?? "", dateTimeString: searchedDataArray?[indexPath.row].date ?? "")
        }else if sortData?.count != nil
        {
            cell.setValues(title: sortData?[indexPath.row].title ?? "", noteContent: sortData?[indexPath.row].content ?? "", dateTimeString: sortData?[indexPath.row].date ?? "")
        }
        else{
            let formatedDate = noteArray![indexPath.row].date!
//            print("\(noteArray![indexPath.row].date!)")
            cell.setValues(title: noteArray?[indexPath.row].title ?? "", noteContent: noteArray?[indexPath.row].content ?? "", dateTimeString: formatedDate)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Update", handler:{action, indexpath in
//            print("MORE•ACTION");
//        });
//        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
//
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            print("DELETE•ACTION");
            self.deleteAlertView(index: indexPath.row)
            
        });
        
        return [deleteRowAction];
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let addNoteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: AddNoteViewControllerIdentifier) as? AddNoteViewController
        {
            addNoteViewController.isEdit = true
            addNoteViewController.subject = subject
            addNoteViewController.selectedIndex = indexPath.row
            addNoteViewController.note = noteArray?[indexPath.row]
            self.navigationController?.pushViewController(addNoteViewController, animated: true)
        }
    }
    
    func deleteAlertView(index: Int) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .destructive, handler: { (action) -> Void in
            print("Ok button tapped")
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(self.noteArray![index])
            self.noteArray!.remove(at: index)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.getDataForSubject(subject: self.subject?.subjectTitle ?? "")
            self.tableView.reloadData()
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
    
    func getDataForSubject(subject: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let fetchRequest : NSFetchRequest<Note> = Note.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "subjectName == %@", subject)
            let fetchedResults = try context.fetch(fetchRequest)
            noteArray = fetchedResults
//            print(noteArray![0].title)
        }
        catch {
            print ("fetch task failed in email", error)
        }
        
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }
    
    private func showModally(){
        if let presentedViewController = self.storyboard?.instantiateViewController(withIdentifier: "FilterNoteViewController") as? FilterNoteViewController{
            presentedViewController.providesPresentationContextTransitionStyle = true
            presentedViewController.definesPresentationContext = true
            presentedViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
            presentedViewController.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
            presentedViewController.delegate = self
            self.present(presentedViewController, animated: true, completion: nil)
        }
    }
    
    

}

extension NoteTableViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // filterdata  = searchText.isEmpty ? data : data.filter {(item : String) -> Bool in
        
        self.searchedDataArray = searchText.isEmpty ? noteArray :  self.noteArray!.filter { $0.title!.contains(searchText) || $0.content!.contains(searchText) }
      
//        self.getSearchedData(subject: searchText)
        for obj in self.searchedDataArray! {
            print("Sorted Date: \(obj.date) with title: \(obj.title)")
        }
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
    func getSearchedData(subject: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let fetchRequest : NSFetchRequest<Note> = Note.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title == %@", subject)
            let fetchedResults = try context.fetch(fetchRequest)
            searchedDataArray = fetchedResults
        }
        catch {
            print ("fetch task failed in email", error)
        }
        
    }
    
//    @nonobjc public class func searchFetchRequest() -> NSFetchRequest<Note> {
//        return NSFetchRequest<Note>(entityName: "Note")
//    }
    
    
    
}
