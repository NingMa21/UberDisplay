//
//  LoginViewController.swift
//  display
//
//  Created by Ning Ma on 9/13/18.
//  Copyright © 2018 Ning Ma. All rights reserved.
//

import UIKit
import Firebase

// HELLO WORLD
// "https://github.com/firebase/quickstart-ios/blob/9de07f9c2ee49e42c712a6553f55ed2cbfa46f42/authentication/AuthenticationExampleSwift/EmailViewController.swift#L113-L125"

class LoginViewController: UIViewController {
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.isEnabled = false
        registerButton.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func enableButtonsGrabInfo() {
        if let email = tfEmail.text, let password = tfPassword.text {
            if email.isEmail() && password.isPasswordValid() {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.user = UberDisplayUser()
                appDelegate.user?.emailAddress = email
                appDelegate.user?.password = password
                
                loginButton.isEnabled = true
                registerButton.isEnabled = true
            }
        } else {
            loginButton.isEnabled = false
            registerButton.isEnabled = false
        }
    }
    
    @IBAction func tfEmailEditingChanged(_ sender: Any) {
        self.enableButtonsGrabInfo()
    }
    
    @IBAction func tfPasswordEditingChanged(_ sender: Any) {
        self.enableButtonsGrabInfo()
    }
    
    @IBAction func registerClick(_ sender: AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.user?.createUserinFirebase({(user) in
            self.performSegue(withIdentifier: "showProfile", sender: self.registerButton)
        }, onError: {(error) in
            // TODO put in a message here
        })
    }
    
    @IBAction func loginClick(_ sender: AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.user?.signUserIntoFirebase({(user) in
            self.performSegue(withIdentifier: "showProfile", sender: self.loginButton)
        }, onError: {(error) in
            // TODO put in a message here
        })
        
    }
}