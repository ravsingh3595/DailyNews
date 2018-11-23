//
//  SubjectTableViewController.swift
//  CoreDataNew
//
//  Created by Sonia Rani on 2018-11-16.
//  Copyright © 2018 RavSingh. All rights reserved.
//

import UIKit

class SubjectTableViewController: UITableViewController, SendSavedSubjectProtocol {
    
    var subjectArray = [Subject]()
    let cellIdentifier = "SubjectTableViewCell"
    let NoteTableViewControllerIdentifier = "NoteTableViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 70
        getData()
    }
    
    @IBAction func addSubjectButtonClicked(_ sender: UIBarButtonItem) {
        self.showModally()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return subjectArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SubjectTableViewCell
        cell.setValues(title: subjectArray[indexPath.row].subjectTitle ?? "")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        if let noteTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NoteTableViewControllerIdentifier) as? NoteTableViewController
        {
            noteTableViewController.subject = subjectArray[indexPath.row]
            self.navigationController?.pushViewController(noteTableViewController, animated: true)
            
        }
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
    
    
    private func showModally(){
        if let presentedViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddSubjectViewController") as? AddSubjectViewController{
            presentedViewController.providesPresentationContextTransitionStyle = true
            presentedViewController.definesPresentationContext = true
            presentedViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
            presentedViewController.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
            presentedViewController.delegate = self
            self.present(presentedViewController, animated: true, completion: nil)
        }
    }
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            self.subjectArray = try context.fetch(Subject.fetchRequest())
        }
        catch
        {
            print("Error")
        }
        tableView.reloadData()
    }
 
    func saveSubject(title: String, viewController: UIViewController) {
        print("Title: ", title)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let subject = Subject(context: context)
        subject.subjectTitle = title
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        viewController.dismiss(animated: true, completion: nil)
        getData()
    }
    
    


}
