//
//  GTableViewController.swift
//  chefApp
//
//  Created by Ananya on 4/10/18.
//  Copyright © 2018 cs329e. All rights reserved.
//

import UIKit
import Firebase

var groceryList: [String] = []
var inventory: [String]! = [String]()

class AddCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet public weak var textField: UITextField!
    @IBAction func addItem(_ sender: Any) {
        if textField.text != "" {
            groceryList.append(textField.text!)
        }
    }
    
    override func didMoveToWindow() {
        textField.delegate = self
    }
    
    func saveData () {
        let user = Auth.auth().currentUser
        let databaseRef = Database.database().reference().child("user").child((user?.uid)!).child("groceryList")
        var list = databaseRef.childByAutoId()
        list.setValue(textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("reached")
        saveData()
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
    
    public func formatField() {
        //textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 2
        let borderColor: UIColor = UIColor.gray
        textField.layer.borderColor = borderColor.cgColor
        textField.font = UIFont(name:"Helvetica Neue", size:20)
        
    }
    
}

class GTableViewController: UITableViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    var groceryList = [String: String]()
    var inventory: [String]! = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        let databaseRef = Database.database().reference().child("user").child((user?.uid)!).child("groceryList")
        databaseRef.observe(.value, with: {snapshot in
            var newItems = [String: String]()
            let groceries = snapshot.value as? [String : AnyObject] ?? [:]
            for i in groceries {
                newItems[i.key] =  i.value as? String
            }
            
            self.groceryList = newItems
            self.tableView.reloadData()
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let user = Auth.auth().currentUser
            Database.database().reference().child("user").child((user?.uid)!).child("groceryList").child().removeValue()
            inventory.append(groceryList[indexPath.row-1])
            groceryList.remove(at: indexPath.row-1)
            tableView.reloadData()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryList.count+1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //add cell
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addItem", for: indexPath) as! AddCell
            cell.formatField()
            cell.layer.cornerRadius = 8
            return cell as UITableViewCell
        }
        
        //grocery cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "groceryItem", for: indexPath)
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.white
            cell.layer.masksToBounds = true
            cell.layer.borderColor = UIColor(red: 196/255, green: 217/255, blue:215/255, alpha: 1.0 ).cgColor
        }
        else {
            cell.backgroundColor = UIColor(red: 196/255, green: 217/255, blue:215/255, alpha: 1.0 )
        }
        cell.textLabel?.font = UIFont(name:"Helvetica Neue", size:20)
        var item = ""
        item = groceryList[indexPath.row-1]
        cell.textLabel?.text = item
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 2
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        }
        return 50
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

