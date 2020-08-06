//
//  settingsViewController.swift
//  chefApp
//
//  Created by Krishna  Madireddy on 4/12/18.
//  Copyright © 2018 cs329e. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class settingsViewController: UIViewController {
    @IBOutlet weak var btn: UIButton!
    
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "signup")
            self.present(newViewController, animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        let user = Auth.auth().currentUser
        Auth.auth().sendPasswordReset(withEmail: (user?.email)!) { (error) in
            // ...
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
