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
    
    
//    var authUI: FUIAuth?
//    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
//        if error == nil {
//            btnRegister.setTitle("Logout", for: .normal)
//        }
//    }
    
//
//    @IBAction func doBtnCreateAccount(_ sender: Any) {
//        if let email = tfEmail.text, let password = tfPassword.text {
//            Auth.auth().createUserAndRetrieveData(withEmail: email, password: password, completion: {(FIRUser, error) in
//                print (FIRUser?.user.email ?? "no email")
//                print (Auth.auth().currentUser?.uid ?? "no userid")
//            })
//        }
//    }
    
    @IBAction func register(_ sender: AnyObject) {
        guard let email = self.tfEmail.text, let password = self.tfPassword.text
            else {
                print("format is not valid")
                return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user: User?, error ) in
            
            if error != nil{
            print("email/password not valid")
                return
            }
            
            //otherwise, successfully authenticated user
        })
        

    }
//    @IBAction func doBtnLogin(_ sender: Any) {
//        if Auth.auth().currentUser == nil {
//            if let email = tfEmail.text, let password = tfPassword.text {
//                Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
//                    if error == nil {
//                        self.btnRegister.setTitle("Logout", for: .normal)
//                    }
//                })
//            }
//        }
//        else{
//            do {
//                try Auth.auth().signOut()
//                self.btnRegister.setTitle("Login", for: .normal)
//            }
//            catch {}
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
