//
//  HomeViewController.swift
//  chefApp
//
//  Created by Ananya on 4/30/18.
//  Copyright © 2018 cs329e. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var groceryBtn: UIButton!
    @IBOutlet weak var fridgeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groceryBtn.layer.masksToBounds = true
        groceryBtn.layer.cornerRadius = 2
        fridgeBtn.layer.masksToBounds = true
        fridgeBtn.layer.cornerRadius = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToGrocery" {
            if let destinationVC = segue.destination as? GTableViewController {
                //destinationVC.message = "This is a message for controller 2"
            }
        } else if segue.identifier == "homeToFridge" {
            if let destinationVC = segue.destination as? FridgeTableViewController {
                //destinationVC.message = "This is a message for controller 3"
            }
        }
        
    }
    

}
