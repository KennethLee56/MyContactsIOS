//
//  MyContactsTableViewController.swift
//  MyContacts
//
//  Created by Lee, Kenneth Van on 11/22/19.
//  Copyright © 2019 Lee, Kenneth Van. All rights reserved.
//

import UIKit
import CoreData

class MyContactsTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as!
        AppDelegate).persistentContainer.viewContext
    
    var students = [Student]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStudents()
        
        self.tableView.rowHeight = 84.0
    }
    
    func loadStudents() {
        
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        
        do {
            students = try context.fetch(request)
        } catch {
            print("Error fetching Students from Core Data!")
        }
        
        tableView.reloadData()
    }
    
    func saveStudents() {
        do {
            try context.save()
        } catch {
            print("Error saving Students to Core Data!")
        }
        
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // declare Text Fields variables for the input of the name. store. and data
        var fnameTextField = UITextField()
        var lnameTextField = UITextField()
        var emailTextField = UITextField()
        
        // create an Alert Controller
        let alert = UIAlertController(title: "My Contacts", message: "", preferredStyle: .alert)
        
        // define an action that will occur when the Add List button is pushed
        let action = UIAlertAction(title: "Create", style: .default, handler: { (action) in
            
            // create an instance of a ShoppingList entity
            let newStudent = Student(context: self.context)
            
            //get name, store, and date input by user and store them in ShoppingList entity
            newStudent.fname = fnameTextField.text!
            newStudent.lname = lnameTextField.text!
            newStudent.email = emailTextField.text!
            
            // add ShoppingList entity into array
            self.students.append(newStudent)
            
            // save ShoppingLists into Core Data
            self.saveStudents()
        })
        
        // disable the action that will occure when the Add List button is pushed
        action.isEnabled = false
        
        // define an action that will occure when the Cancel is pushed
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (cancelAction) in
            
        })
        
        // add actions into Alert Controller
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        // add the Text Fields into the Alert Controller
        alert.addTextField(configurationHandler: { (field) in
            fnameTextField = field
            fnameTextField.placeholder = "First Name"
            fnameTextField.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
        })
        alert.addTextField(configurationHandler: { (field) in
            lnameTextField = field
            lnameTextField.placeholder = "Last Name"
            lnameTextField.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
        })
        alert.addTextField(configurationHandler: { (field) in
            emailTextField = field
            emailTextField.placeholder = "Email Address"
            emailTextField.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
        })
        
        // display the Alert Controller
        present(alert, animated: true, completion: nil)
    }
    @objc func alertTextFieldDidChange (){
        
        // get a reference to the Alert Controller
        let alertController = self.presentedViewController as!
        UIAlertController
        
        // get a reference to the action that allows the user to add a ShoppingList
        let action = alertController.actions[0]
        
        //get references to the text in the Text Fields
        if let fname = alertController.textFields![0].text, let
            lname = alertController.textFields![1].text, let
            email = alertController.textFields![2].text {
            
            // trim whitespace from the text
            let trimmedFName = fname.trimmingCharacters(in: .whitespaces)
            let trimmedLName = lname.trimmingCharacters(in: .whitespaces)
            let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
            
            // check if the trimmed text isn't empty and if it isn't enable the action that allows the user to add a ShoppingList
            if(!trimmedFName.isEmpty && !trimmedLName.isEmpty && !trimmedEmail.isEmpty){
                action.isEnabled = true;
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return students.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyContactsCell", for: indexPath)

        // Configure the cell...
        let student = students[indexPath.row]
        cell.textLabel?.text = student.fname! + " " + student.lname!
        cell.detailTextLabel!.numberOfLines = 0
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        
        cell.detailTextLabel?.text =  "Email: " + student.email! + "\nCreated: " + formattedDate

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
