//
//  signinViewController.swift
//  CS329Group5
//
//  Created by Krishna  Madireddy on 4/3/18.
//  Copyright © 2018 Sai Kasam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class signinViewController: UIViewController  { 

    
    @IBOutlet weak var signInEmail: UITextField!
    @IBOutlet weak var signInPassword: UITextField!
    @IBOutlet weak var signin: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        signin.layer.cornerRadius = 20
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signinFire(_ sender: Any) {
        Auth.auth().signIn(withEmail: signInEmail.text!, password: signInPassword.text!) { (user, error) in
            if user?.uid != nil {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "groceries") as! GTableViewController
                self.present(newViewController, animated: true)
                print(user?.uid)
            }
            else{
                self.errorLabel.text = "email or password incorrect"
            }
        }
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
