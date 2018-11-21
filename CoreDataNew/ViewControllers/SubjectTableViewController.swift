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

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 70
        getData()
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

        // Configure the cell...
//        for x in subjectArray{
//            cell.setValues(title: x.subjectTitle ?? "")
//            return cell
//        }
        cell.setValues(title: subjectArray[indexPath.row].subjectTitle ?? "")
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
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let subject = Subject(context: context)
        
        subject.subjectTitle = title
//        subject.name = txtName.text
//        subject.age = Int16(Int(txtAge.text!)! as Int)
//        task.isImp = switchIsImp.isOn
        
        //Save the data to core data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        viewController.dismiss(animated: true, completion: nil)
        getData()
//        navigationController?.popViewController(animated: true)
    }


}
