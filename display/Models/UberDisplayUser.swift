//
//  UberDisplayUser.swift
//  display
//
//  Created by Ben Hanrahan on Monday 2/11/19.
//  Copyright © 2019 Ning Ma. All rights reserved.
//

import Foundation
import Firebase

class UberDisplayUser {
    var uid: String?
    var emailAddress: String?
    var password: String?
    var phoneNumber: String?
    
    var fireBaseUser: User?
    
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
}
