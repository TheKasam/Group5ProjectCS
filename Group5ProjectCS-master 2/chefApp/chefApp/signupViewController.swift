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
import GoogleSignIn

class signupViewController: UIViewController, GIDSignInUIDelegate, UITextFieldDelegate {

   
    @IBOutlet weak var signupName: UITextField!
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var signupEmail: UITextField!
    @IBOutlet weak var signupPassword: UITextField!
    @IBAction func gSingUp(_ sender: Any) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        if Auth.auth().currentUser != nil {
            // User is signed in.
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "homeTab")
            self.present(newViewController, animated: true)
            print("signed in")
        }
    }
    
    @IBOutlet weak var errorLabel: UILabel!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.signupEmail.delegate = self
        self.signupPassword.delegate = self
        
        ref = Database.database().reference()
        signup.layer.cornerRadius = 15
    }
    
    // hide keyboard when user taps outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // hide keyboard when user taps return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signupEmail.resignFirstResponder()
        signupPassword.resignFirstResponder()
        return(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signupFire(_ sender: Any) {
        Auth.auth().createUser(withEmail: signupEmail.text!, password: signupPassword.text!) { (user, error) in
            if user?.uid != nil {
                self.ref.child("users").child((user?.uid)!).setValue(["name": self.signupName.text])
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "homeTab") 
                self.present(newViewController, animated: true)
                print(user?.uid)
            }
            else {
                self.errorLabel.text = "Done Goofed"
            }
        }
    }
}
