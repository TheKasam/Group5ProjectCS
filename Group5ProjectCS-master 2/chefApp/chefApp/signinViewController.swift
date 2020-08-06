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
import GoogleSignIn

class signinViewController: UIViewController, GIDSignInUIDelegate, UITextFieldDelegate  {

    
    @IBOutlet weak var signInEmail: UITextField!
    @IBOutlet weak var signInPassword: UITextField!
    @IBOutlet weak var signin: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBAction func gSingIn(_ sender: Any) {
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
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        ref = Database.database().reference()
        signin.layer.cornerRadius = 15
        
        self.signInEmail.delegate = self
        self.signInPassword.delegate = self
        
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            // User is signed in.
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "homeTab")
            self.present(newViewController, animated: true)
            print("signed in")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // hide keyboard when user taps outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // hide keyboard when user taps return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signInEmail.resignFirstResponder()
        signInPassword.resignFirstResponder()
        return(true)
    }
    
    
    @IBAction func signinFire(_ sender: Any) {
        Auth.auth().signIn(withEmail: signInEmail.text!, password: signInPassword.text!) { (user, error) in
            if user?.uid != nil {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "homeTab") 
                self.present(newViewController, animated: true)
                print(user?.uid)
            }
            else{
                self.errorLabel.text = "email or password incorrect"
            }
        }
    }
} 
