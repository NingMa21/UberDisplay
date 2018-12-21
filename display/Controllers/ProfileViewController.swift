//
//  ProfileViewController.swift
//  display
//
//  Created by Ning Ma on 8/8/18.
//  Copyright © 2018 Ning Ma. All rights reserved.
//

import UIKit
import Firestore

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var DrivingArea: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var PhoneNumber: UITextField!

    @IBAction func SaveProfile(_ sender: UIButton) {
        let collection = Firestore.firestore().collection("uberdisplay")
        
        collection.addDocument(data: ["name": Name.text as Any, "drivingarea": DrivingArea.text as Any, "email": Email.text as Any, "phonenumber": PhoneNumber.text as Any]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }
    
    @IBOutlet weak var userImage: UIImageView!
 
    @IBAction func addPhoto(_ sender: Any) {
        let pPhoto = UIImagePickerController()
        pPhoto.delegate = self
        pPhoto.allowsEditing = true
        // round the corners
        

// buttom pop up asking image from camera or photo library
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            pPhoto.sourceType = .camera
            self.present(pPhoto, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
            pPhoto.sourceType = .photoLibrary
            self.present(pPhoto, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(pPhoto, animated: true)
 
    }
 
        

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage
            {
                userImage.image = chosenImage
            }
            else{
                //error message
            }
            self.dismiss(animated: true, completion: nil)
        }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        
        }
        
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destinationViewController.
            // Pass the selected object to the new view controller.
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

