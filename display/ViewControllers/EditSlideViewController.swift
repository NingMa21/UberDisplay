//
//  ContentViewController.swift
//  display
//
//  Created by Ning Ma on 9/11/18.
//  Copyright © 2018 Ning Ma. All rights reserved.
//

import UIKit
import Firestore
import FirebaseStorage
import NVActivityIndicatorView

class EditSlideViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NVActivityIndicatorViewable {
   
    var slide: Slide?
    @IBOutlet weak var imageDescription: UITextView!
    @IBOutlet weak var imageName: UITextField!
    @IBOutlet weak var displayImage: UIImageView!

    // MARK: - ViewController methods
    override func viewDidLoad() {
        self.imageName.text = self.slide?.title
        self.imageDescription.text = self.slide?.description
        self.displayImage.image = self.slide?.slideImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    @IBAction func addImage(_ sender: Any) {
        let aImage = UIImagePickerController()
        aImage.delegate = self
        aImage.allowsEditing = true
        
        // buttom pop up asking image from camera or photo library
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            aImage.sourceType = .camera
            self.present(aImage, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
            aImage.sourceType = .photoLibrary
            self.present(aImage, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(aImage, animated: true)
        
    }
    
    @IBAction func saveContent(_ sender: Any) {
        self.slide?.title = self.imageName.text
        self.slide?.description = self.imageDescription.text
        self.slide?.slideImage = self.displayImage.image
        
        self.startAnimating()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // check if the slide is already in the deck of slides, via the order number
        if let idx = appDelegate.user.slides.firstIndex(where: { $0.position == self.slide?.position }) {
            appDelegate.user.slides[idx] = self.slide!
        } else { // append it if not
            appDelegate.user.slides.append(self.slide!)
        }
        
        appDelegate.user.saveSlidesFirebase( {(user) in
            self.stopAnimating()
            self.performSegue(withIdentifier: "unwindToHome", sender: self)
        }, onError: {(error) in
            self.stopAnimating()
            // TODO handle this better with a message or something
        })
    }
    
    // MARK: - ImagePicker methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            displayImage.image = selectedImage
        }
        else{
            //error message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //begin dismiss keyboard when touching
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
}
