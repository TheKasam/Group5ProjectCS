//
//  signupViewController.swift
//  CS329Group5
//
//  Created by Krishna  Madireddy on 4/7/18.
//  Copyright © 2018 Sai Kasam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class signupViewController: UIViewController {

   
    @IBOutlet weak var signupName: UITextField!
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var signupEmail: UITextField!
    @IBOutlet weak var signupPassword: UITextField!

    @IBOutlet weak var errorLabel: UILabel!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        signup.layer.cornerRadius = 20
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupFire(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: signupEmail.text!, password: signupPassword.text!) { (user, error) in
            if user?.uid != nil {
                self.ref.child("users").child((user?.uid)!).setValue(["name": self.signupName.text])
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "groceries") as! GTableViewController
                self.present(newViewController, animated: true)
                print(user?.uid)
            }
            else {
                self.errorLabel.text = "Done Goofed"
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
