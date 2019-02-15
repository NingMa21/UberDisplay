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

class EditSlideViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    @IBOutlet weak var imageDescription: UITextView!
    var text:String = ""
    weak var masterView: SlidesViewController!
    @IBOutlet weak var imageName: UITextField!
    @IBOutlet weak var displayImage: UIImageView!

    // MARK: - ViewController methods
    override func viewDidLoad() {
        imageName.delegate = self
        imageDescription.text = "the first image description"
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    //this should for text fields
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageDescription.becomeFirstResponder()
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
        let contents = Firestore.firestore().collection("uberdisplay")
        contents.addDocument(data: ["image name": imageName.text as Any, "image description": imageDescription.text as Any]) { contentError in
            if let contentError = contentError {
                print("Error adding content: \(contentError)")
            } else {
                print("Content added")
            }
        }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)

    }
}
