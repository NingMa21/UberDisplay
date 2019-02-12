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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.Email.text = appDelegate.user.emailAddress

        appDelegate.user.loadUserDatafromFirebase( {(user) in
            self.Name.text = user.displayName
            self.DrivingArea.text = user.drivingArea
            self.PhoneNumber.text = user.phoneNumber
        }, onError: {(error) in
            // no big deal if it fails, it probably hasn't been created
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func SaveProfile(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.user.displayName = self.Name.text
        appDelegate.user.drivingArea = self.DrivingArea.text
        appDelegate.user.phoneNumber = self.PhoneNumber.text
        // don't save email, it is part of sign in info
        
        appDelegate.user.saveUserDatatoFirebase( {(user) in
            // go back to home screen
            self.performSegue(withIdentifier: "unwindToHome", sender: self)
        }, onError: {(error) in
            // TODO handle this better
        })
    }
    
    
    //-------------------------
    
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

