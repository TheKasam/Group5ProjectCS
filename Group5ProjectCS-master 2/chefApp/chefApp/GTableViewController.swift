//
//  GTableViewController.swift
//  chefApp
//
//  Created by Ananya on 4/10/18.
//  Copyright © 2018 cs329e. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

protocol MyCellDelegate: AnyObject {
    func buttonClicked(cell: GroceryItem)
}

var references = [String]()
var groceryList: [String] = []
var inventory: [String]! = [String]()

class GroceryItem: UITableViewCell {
    weak var delegate: MyCellDelegate?
    @IBOutlet weak var buttonCheckMark: UIButton!
    @IBAction func buttonClicked(_ sender: Any) {
        delegate?.buttonClicked(cell: self)
    }
    
    @IBOutlet weak var lbl: UILabel!
    
}

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
        let uid = Auth.auth().currentUser?.uid
        let databaseRef = Database.database().reference().child("users").child(uid!).child("groceryList")
        let item  = databaseRef.childByAutoId()
        let key = item.key
        let grocery = textField.text
        references.append(key)
        item.setValue(grocery)
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

class GTableViewController: UITableViewController, MyCellDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    
    var groceryList: [String] = []
    var references: [String] = []
    var inventory: [String]! = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loads data
        self.tableView.contentInset = UIEdgeInsets(top: -22, left: 0, bottom: 0, right: 0)

        
        let uid = Auth.auth().currentUser?.uid
        let databaseRef = Database.database().reference().child("users").child(uid!).child("groceryList")
        databaseRef.observe(.value, with: {snapshot in
            var newItems:[String] = []
            var newRefs:[String] = []
            let groceries = snapshot.value as? [String : AnyObject] ?? [:]
            for i in groceries {
                newRefs.append(i.key)
                newItems.append(i.value as! String)
            }
            self.groceryList = newItems
            self.references = newRefs
            self.tableView.reloadData()
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //deletes a grocery list item
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let uid = Auth.auth().currentUser?.uid
            let databaseRef = Database.database().reference()
            let item = groceryList[indexPath.row-1]
            print(item)
            let refValue = references[indexPath.row-1]
            print(refValue)
            let refDelete =  databaseRef.child("users").child(uid!).child("groceryList").child(refValue)
            refDelete.removeValue()
            references.remove(at: indexPath.row-1)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "groceryItem", for: indexPath) as! GroceryItem
        cell.delegate = self
        cell.selectionStyle = .none
        cell.buttonCheckMark.addTarget(self, action: #selector(checkMarkBtnClicked(sender:)), for: .touchUpInside)
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.white
            cell.layer.masksToBounds = true
            cell.layer.borderColor = UIColor(red: 196/255, green: 217/255, blue:215/255, alpha: 1.0 ).cgColor
        }
        else {
            cell.backgroundColor = UIColor(red: 196/255, green: 217/255, blue:215/255, alpha: 1.0 )
        }
        cell.textLabel?.font = UIFont(name:"Helvetica Neue", size:20)
        let item = groceryList[indexPath.row-1]
        cell.lbl?.text = item
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 2
        cell.indentationLevel = 1
        cell.indentationWidth = 30
        return cell as UITableViewCell
    }
    
    func buttonClicked(cell: GroceryItem) {
        //Get the indexpath of cell where button was tapped
        let indexPath = self.tableView.indexPath(for: cell)
        print("reached here")
        print(indexPath!.row)
        
        //saves data to fridge list
        let uid = Auth.auth().currentUser?.uid
        var databaseRef = Database.database().reference().child("users").child(uid!).child("fridge")
        let item = groceryList[(indexPath?.row)!-1]
        let refValue = references[(indexPath?.row)!-1]
        let ref = databaseRef.childByAutoId()
        ref.setValue(item)
        
        //deletes item from grocery list
        print(item)
        print(refValue)
        databaseRef = Database.database().reference()
        let refDelete =  databaseRef.child("users").child(uid!).child("groceryList").child(refValue)
        refDelete.removeValue()
        references.remove(at: (indexPath?.row)!-1)
        groceryList.remove(at: (indexPath?.row)!-1)
    }
    
    @objc func checkMarkBtnClicked(sender: UIButton) {
        print("button pressed")
        sender.isSelected = false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        }
        return 50
    }


}
