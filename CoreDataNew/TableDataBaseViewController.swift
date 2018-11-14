//
//  TableDataBaseViewController.swift
//  CoreDataNew
//
//  Created by user on 2018-08-12.
//  Copyright © 2018 RavSingh. All rights reserved.
//

import UIKit

class TableDataBaseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var database: UITableView!
    
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        database.dataSource = self
        database.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //get the data from the core data
        getData()
        
        //reload the data in table view
         database.reloadData()             //database is my table view
    }
    
    
    
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let task = self.tasks[indexPath.row]
        
        if task.isImp == true
        {
            cell.textLabel?.text = "IMP:\(task.name!)"
        }
        else
        {
            cell.textLabel?.text = task.name!
        }
        // cell.detailTextLabel?.text = String(format: "%.2f", task.age)
        
        return cell
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete
        {
            let task = tasks[indexPath.row]
            context.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do{
                tasks = try context.fetch(Task.fetchRequest())
            }
            catch
            {
                print("Error")
            }

        }
        //reload the data in table view
        database.reloadData()             //database is my table view
        
    }
    
    
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            tasks = try context.fetch(Task.fetchRequest())
        }
        catch
        {
            print("Error")
        }
    }
    
}
