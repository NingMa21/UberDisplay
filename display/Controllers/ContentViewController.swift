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

class ContentViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    @IBOutlet weak var imageDescription: UITextView!
    var text:String = ""
    weak var masterView: HomeViewController!
    @IBOutlet weak var imageName: UITextField!
    
    
    @IBOutlet weak var displayImage: UIImageView!
//    var displayImage: UIImageView {
//        let displayImageView = UIImageView()
//        displayImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleselectDisplayImage)))
//        return displayImageView
//    }
    @IBAction func addImage(_ sender: Any) {
        let aImage = UIImagePickerController()
        aImage.delegate = self
        aImage.allowsEditing = true
        // round the corners
        
        
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
    override func viewDidLoad() {
        imageName.delegate = self
        imageDescription.text = "the first image description"
        self.navigationItem.largeTitleDisplayMode = .never
    }
    //begin dismiss keyboard when touching
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)

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
       //trying to add image to FireStorage, it's not letting me for some reason.
        //let storage = Storage.storage()
}
    //this should for text fields
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageDescription.becomeFirstResponder()
    }
    
    func setText(t: String) {
        text = t
        if isViewLoaded {
        imageDescription.text = t
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        masterView.newRowText = imageDescription.text
        imageDescription.resignFirstResponder()
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
