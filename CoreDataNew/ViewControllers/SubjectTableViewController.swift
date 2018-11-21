//
//  SubjectTableViewController.swift
//  CoreDataNew
//
//  Created by Sonia Rani on 2018-11-16.
//  Copyright © 2018 RavSingh. All rights reserved.
//

import UIKit

class SubjectTableViewController: UITableViewController, SendSavedSubjectProtocol {
    
    let cellIdentifier = "SubjectTableViewCell"
    let NoteTableViewControllerIdentifier = "NoteTableViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 70
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
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SubjectTableViewCell

        // Configure the cell...
        cell.setValues(title: "Maths Algebra")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        if let noteTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NoteTableViewControllerIdentifier) as? NoteTableViewController
        {
            self.navigationController?.pushViewController(noteTableViewController, animated: true)
            
        }
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
 
    func saveSubject(title: String, viewController: UIViewController) {
        print("Title: ", title)
        viewController.dismiss(animated: true, completion: nil)
    }


}
