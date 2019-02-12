//
//  UberDisplayUser.swift
//  display
//
//  Created by Ben Hanrahan on Monday 2/11/19.
//  Copyright © 2019 Ning Ma. All rights reserved.
//

import Foundation
import Firebase
import Firestore

class UberDisplayUser {
    var emailAddress: String?
    var password: String?
    var drivingArea: String?
    var displayName: String?
    var phoneNumber: String?
    
    var fireBaseUser: User?

    /**
     Saves the current user values in email and pass (plaintext!!) into the plist, this fails silently if the write fails
     */
    func saveUsertoPlist() {
        if let plist = Plist(name: "data") {
            let dict = plist.getMutablePlistFile()!
            dict["user_email"] = self.emailAddress!
            dict["user_pass"] = self.password!
            
            do {
                try plist.addValuesToPlistFile(dict)
            } catch {
                // this should fail silently, it doesn't really matter
                print("couldn't save the plist")
            }
        }
    }
    
    /**
     Loads a user from the plist, if no user it does nothing
     
     - Returns: whether or not something was loaded that made sense, runs check of email and pass
     */
    func loadUserfromPlist() -> Bool{
        var loaded = false
        
        if let plist = Plist(name: "data") {
            let dict = plist.getMutablePlistFile()!
            if let user_email = dict["user_email"] as? String, let user_pass = dict["user_pass"] as? String {
                self.emailAddress = user_email
                self.password = user_pass
                loaded = true
            }
        }
        
        if loaded {
            loaded = (self.emailAddress?.isEmail() ?? false && self.password?.isPasswordValid() ?? false)
        }
        
        return loaded
    }
    
    /**
     This is used to create a user in Firebase.
     
     - Parameter onsuccess: Void - callback function when successful
     - Parameter onError: Void - callback when there is an error
    */
    func createUserinFirebase(_ onSuccess: @escaping (_ user: UberDisplayUser) -> Void, onError: @escaping (_ error: NSError) -> Void) {
    
        // TODO this should be a better check
        if self.emailAddress != nil && self.password != nil {
            Auth.auth().createUser(withEmail: self.emailAddress!, password: self.password!, completion: {(user: User?, error ) in
                
                // TODO this should be a better message
                if error != nil{
                    onError((error as? NSError)!)
                } else {
                    self.fireBaseUser = user
                    
                    onSuccess(self)
                }
            })
        } else {
            // TODO this should be a better message
            onError(NSError(domain: "UberDisplay", code: 123, userInfo: ["Problem with email or password": NSObject()]))
        }
    }
    
    /**
     This is used to sign a user into Firebase.
     
     - Parameter onsuccess: Void - callback function when successful
     - Parameter onError: Void - callback when there is an error
     */
    func signUserIntoFirebase(_ onSuccess: @escaping (_ user: UberDisplayUser) -> Void, onError: @escaping (_ error: NSError) -> Void) {
        
        // TODO this should be a better check
        if self.emailAddress != nil && self.password != nil {
            Auth.auth().signIn(withEmail: self.emailAddress!, password: self.password!, completion: {(user: User?, error ) in
                // TODO this should be a better message
                if error != nil{
                    onError((error as? NSError)!)
                } else {
                    self.fireBaseUser = user
                    onSuccess(self)
                }
            })
        } else {
            // TODO this should be a better message
            onError(NSError(domain: "UberDisplay", code: 123, userInfo: ["Problem with email or password": NSObject()]))
        }
    }
    
    /**
     This is used to delete a user in Firebase.
     
     - Parameter onsuccess: Void - callback function when successful
     - Parameter onError: Void - callback when there is an error
     */
    func deleteUserinFirebase(_ onSuccess: @escaping (_ user: UberDisplayUser) -> Void, onError: @escaping (_ error: NSError) -> Void) {
        
        Auth.auth().currentUser?.delete(completion: {error in
            // TODO this should be a better message
            if let error = error {
                onError((error as? NSError)!)
            } else {
                self.fireBaseUser = nil
                onSuccess(self)
            }
        })
    }
    
    /**
     Saves the extra data to the users collection in firebase store
     
     - Parameter onsuccess: Void - callback function when successful
     - Parameter onError: Void - callback when there is an error
     */
    func saveUserDatatoFirebase(_ onSuccess: @escaping (_ user: UberDisplayUser) -> Void, onError: @escaping (_ error: NSError) -> Void) {
        if let fbUser = self.fireBaseUser {
            let collection = Firestore.firestore().collection("users")
            
            collection.document(fbUser.uid).setData(["name": self.displayName!, "drivingarea": self.drivingArea!, "phonenumber": self.phoneNumber!], completion: { error in
                if let error = error {
                    onError((error as? NSError)!)
                } else {
                    onSuccess(self)
                }
            })
        }
        
        //TODO need an else with an error
    }
    
    /**
     Retrieves data for this firebase uid and loads it in object
     
     - Parameter onsuccess: Void - callback function when successful
     - Parameter onError: Void - callback when there is an error
     */
    func loadUserDatafromFirebase(_ onSuccess: @escaping (_ user: UberDisplayUser) -> Void, onError: @escaping (_ error: NSError) -> Void) {
        if let fbUser = self.fireBaseUser {
            let docRef = Firestore.firestore().collection("users").document(fbUser.uid)
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    
                    self.displayName = data["name"] as? String
                    self.drivingArea = data["drivingarea"] as? String
                    self.phoneNumber = data["phonenumber"] as? String
                    
                    onSuccess(self)
                } else {
                    onError((error as? NSError)!)
                }
            }
        }
        //TODO need an else with an error
    }
    
    /**
     Deletes data from the firebase for this uid
     
     - Parameter onsuccess: Void - callback function when successful
     - Parameter onError: Void - callback when there is an error
     */
    func deleteUserDatafromFirebase(_ onSuccess: @escaping (_ user: UberDisplayUser) -> Void, onError: @escaping (_ error: NSError) -> Void) {
        if let fbUser = self.fireBaseUser {
            Firestore.firestore().collection("users").document(fbUser.uid).delete() { error in
                if let error = error {
                    onError((error as? NSError)!)
                } else {
                    onSuccess(self)
                }
            }
        }
        //TODO need an else with an error
    }
}
