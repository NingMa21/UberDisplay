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
    var profileImage: UIImage?
    var slides = [Slide]()
    
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
    func createUserinFirebase(_ onSuccess: @escaping (_ user: UberDisplayUser) -> Void, onError: @escaping (_ error: Error) -> Void) {
    
        // TODO this should be a better check
        if self.emailAddress != nil && self.password != nil {
            Auth.auth().createUser(withEmail: self.emailAddress!, password: self.password!, completion: {(user: User?, error ) in
                
                // TODO this should be a better message
                if error != nil{
                    onError(error!)
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
    func signUserIntoFirebase(_ onSuccess: @escaping (_ user: UberDisplayUser) -> Void, onError: @escaping (_ error: Error) -> Void) {
        
        // TODO this should be a better check
        if self.emailAddress != nil && self.password != nil {
            Auth.auth().signIn(withEmail: self.emailAddress!, password: self.password!, completion: {(user: User?, error ) in
                // TODO this should be a better message
                if error != nil{
                    onError(error!)
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
    func deleteUserinFirebase(_ onSuccess: @escaping (_ user: UberDisplayUser) -> Void, onError: @escaping (_ error: Error) -> Void) {
        
        Auth.auth().currentUser?.delete(completion: {error in
            // TODO this should be a better message
            if let error = error {
                onError(error)
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
    func saveUserDatatoFirebase(_ onSuccess: @escaping (_ user: UberDisplayUser) -> Void, onError: @escaping (_ error: Error) -> Void) {
        if let fbUser = self.fireBaseUser {
            // dispatch group is for waiting on two async operations
            let saveDispatchGroup = DispatchGroup()
            var success = true
            let collection = Firestore.firestore().collection("users")
            
            // an enter waits until the leave for the group
            saveDispatchGroup.enter()
            collection.document(fbUser.uid).setData(["name": self.displayName!, "drivingarea": self.drivingArea!, "phonenumber": self.phoneNumber!], completion: { error in
                if let error = error {
                    success = false
                    
                    onError(error)
                }
                // leave dispatch
                saveDispatchGroup.leave()
            })
            
            // increment semaphore
            let storage = Storage.storage()
            if self.profileImage != nil {
                saveDispatchGroup.enter()
                var data = Data()
                data = UIImageJPEGRepresentation(self.profileImage!, 0.8)!
                let filePath = "\(self.fireBaseUser!.uid)/profile-pic.jpg"
                let storageRef = storage.reference().child(filePath)
                _ = storageRef.putData(data, metadata: nil) { metadata, error in
                    // I don't really care if this fails
                    saveDispatchGroup.leave()
                }
            }
            
            saveDispatchGroup.notify(queue: .main) {
                if success {
                    onSuccess(self)
                }
            }
        } else {
            onError(NSError())
        }//TODO need an else with an error
    }
    
    /**
     Retrieves data for this firebase uid and loads it in object
     
     - Parameter onsuccess: Void - callback function when successful
     - Parameter onError: Void - callback when there is an error
     */
    func loadUserDatafromFirebase(_ onSuccess: @escaping (_ user: UberDisplayUser) -> Void, onError: @escaping (_ error: Error) -> Void) {
        if let fbUser = self.fireBaseUser {
            // dispatch group is for waiting on two async operations
            let loadDispatchGroup = DispatchGroup()
            let docRef = Firestore.firestore().collection("users").document(fbUser.uid)
            
            // an enter waits until the leave
            loadDispatchGroup.enter()
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    
                    self.displayName = data["name"] as? String
                    self.drivingArea = data["drivingarea"] as? String
                    self.phoneNumber = data["phonenumber"] as? String
                }
                // here is the leave for the dispatch
                loadDispatchGroup.leave()
            }
            let storage = Storage.storage()
            let filePath = "\(self.fireBaseUser!.uid)/profile-pic.jpg"
            let storageRef = storage.reference().child(filePath)
            // increment the enter dispatch group thing
            loadDispatchGroup.enter()
            storageRef.getData(maxSize: 10*1024*1024, completion: { (data, error) in
                // assign it if it exists
                if data != nil {
                    self.profileImage = UIImage(data: data!)
                }
                
                // decrement it
                loadDispatchGroup.leave()
            })
            
            // wait for both operations to complete and call finished
            loadDispatchGroup.notify(queue: .main) {
                onSuccess(self)
            }
            
        }
        //TODO need an else with an error
    }
    
    /**
     Deletes data from the firebase for this uid...mostly used in testing
     
     - Parameter onsuccess: Void - callback function when successful
     - Parameter onError: Void - callback when there is an error
     */
    func deleteUserDatafromFirebase(_ onSuccess: @escaping (_ user: UberDisplayUser) -> Void, onError: @escaping (_ error: Error) -> Void) {
        if let fbUser = self.fireBaseUser {
            let docRef = Firestore.firestore().collection("users").document(fbUser.uid)
            
            docRef.collection("slides").getDocuments(completion: { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let slideRef = docRef.collection("slides").document(document.documentID)
                        slideRef.delete()
                    }
                }
            })
            
            // TODO delete the slide images

            docRef.delete() { error in
                if let error = error {
                    onError(error)
                } else {
                    onSuccess(self)
                }
            }
            // TODO delete profile image
        }
        //TODO need an else with an error
    }
    
    func saveSlidesFirebase(_ onSuccess: @escaping (_ user: UberDisplayUser) -> Void, onError: @escaping (_ error: Error) -> Void) {
        // TODO this might need to be a transaction if it is too slow
        if let fbUser = self.fireBaseUser {
            // dispatch group is for waiting on two async operations
            let saveDispatchGroup = DispatchGroup()
            var success = true
            let collection = Firestore.firestore().collection("users")
            
            // an enter waits until the leave for the group
            for slide in self.slides {
                saveDispatchGroup.enter()
                var slideRef: DocumentReference
                
                // existing slide
                if slide.firebaseID != nil {
                    slideRef = collection.document(fbUser.uid).collection("slides").document(slide.firebaseID!)
                } else { // new slide
                    slideRef = collection.document(fbUser.uid).collection("slides").document()
                }
                slideRef.setData(["position": slide.position!, "title": slide.title!, "description": slide.description!], completion: { error in
                    if let error = error {
                        success = false
                        
                        onError(error)
                    }
                    // leave dispatch
                    saveDispatchGroup.leave()
                })
                
            }
            
            let storage = Storage.storage()
            for slide in self.slides {
                if slide.slideImage != nil {
                    // increment semaphore
                    saveDispatchGroup.enter()
                    var data = Data()
                    data = UIImageJPEGRepresentation(slide.slideImage!, 0.8)!
                    let filePath = "\(self.fireBaseUser!.uid)/slides/slide-\(slide.position!).jpg"
                    let storageRef = storage.reference().child(filePath)
                    _ = storageRef.putData(data, metadata: nil) { metadata, error in
                        // I don't really care if this fails
                        saveDispatchGroup.leave()
                    }

                }
            }
            
            saveDispatchGroup.notify(queue: .main) {
                if success {
                    onSuccess(self)
                }
            }
        } //TODO need an else with an error
    }
    
    /**
     Retrieves slide data for this firebase uid and loads it in object
     
     - Parameter onsuccess: Void - callback function when successful
     - Parameter onError: Void - callback when there is an error
     */
    func loadSlidesfromFirebase(_ onSuccess: @escaping (_ user: UberDisplayUser) -> Void, onError: @escaping (_ error: Error) -> Void) {
        if let fbUser = self.fireBaseUser {
            self.slides.removeAll()
            
            // dispatch group is for waiting on two async operations
            let loadDispatchGroup = DispatchGroup()
            let docRef = Firestore.firestore().collection("users").document(fbUser.uid)
            
            // an enter waits until the leave
            loadDispatchGroup.enter()
            docRef.collection("slides").order(by: "position").getDocuments(completion: { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let slide = Slide()
                        slide.description = document.data()["description"] as? String
                        slide.position = document.data()["position"] as? Int
                        slide.title = document.data()["title"] as? String
                        slide.firebaseID = document.documentID
                        
                        let storage = Storage.storage()
                        let filePath = "\(self.fireBaseUser!.uid)/slides/slide-\(slide.position!).jpg"
                        let storageRef = storage.reference().child(filePath)
                        // increment the enter dispatch group thing
                        loadDispatchGroup.enter()
                        storageRef.getData(maxSize: 10*1024*1024, completion: { (data, error) in
                            // assign it if it exists
                            if data != nil {
                                slide.slideImage = UIImage(data: data!)
                            }
                            
                            // decrement it
                            loadDispatchGroup.leave()
                        })

                        self.slides.append(slide)
                    }
                }
                loadDispatchGroup.leave()
            })
            
            // wait for both operations to complette and call finished
            loadDispatchGroup.notify(queue: .main) {
                onSuccess(self)
            }
        }
        //TODO need an else with an error
    }
}
