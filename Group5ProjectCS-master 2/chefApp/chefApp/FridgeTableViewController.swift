//
//  FridgeTableViewController.swift
//  chefApp
//
//  Created by Ananya on 4/29/18.
//  Copyright © 2018 cs329e. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FridgeTableViewController: UITableViewController {
    
    var fridge: [String] = []
    var references: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: -22, left: 0, bottom: 0, right: 0)

        
        let uid = Auth.auth().currentUser?.uid
        let databaseRef = Database.database().reference().child("users").child(uid!).child("fridge")
        databaseRef.observe(.value, with: {snapshot in
            var newItems:[String] = []
            var newRefs:[String] = []
            let groceries = snapshot.value as? [String : AnyObject] ?? [:]
            for i in groceries {
                newRefs.append(i.key)
                newItems.append(i.value as! String)
            }
            self.fridge = newItems
            self.references = newRefs
            self.tableView.reloadData()
        })
    }

    //deletes a grocery list item
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let uid = Auth.auth().currentUser?.uid
            let databaseRef = Database.database().reference()
            let item = fridge[indexPath.row]
            print(item)
            let refValue = references[indexPath.row]
            print(refValue)
            let refDelete =  databaseRef.child("users").child(uid!).child("fridge").child(refValue)
            refDelete.removeValue()
            references.remove(at: indexPath.row)
            fridge.remove(at: indexPath.row)
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
        return fridge.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //grocery cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "fridgeItem", for: indexPath)
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.white
            cell.layer.masksToBounds = true
            cell.layer.borderColor = UIColor(red: 196/255, green: 217/255, blue:215/255, alpha: 1.0 ).cgColor
        }
        else {
            cell.backgroundColor = UIColor(red: 196/255, green: 217/255, blue:215/255, alpha: 1.0 )
        }
        cell.textLabel?.font = UIFont(name:"Helvetica Neue", size:20)
        let item = fridge[indexPath.row]
        cell.textLabel?.text = item
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 2
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
