//
//  AddEditBoyViewController.swift
//  NasiShadchanHelper
//
//  Created by username on 1/19/21.
//  Copyright © 2021 user. All rights reserved.
//

import UIKit
import Firebase

class AddEditBoyViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

let allNasiBoysRef = Database.database().reference().child("NasiBoysList")
   
   
    var selectedNasiBoy: NasiBoy!
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    @IBOutlet weak var boysLastNameTextField: UITextField!
    @IBOutlet weak var boysFirstNameTextField: UITextField!
    
    @IBOutlet weak var contactsLastNameTextField: UITextField!
    @IBOutlet weak var contactsFirstNameTextField: UITextField!
    @IBOutlet weak var contactsCellTextField: UITextField!
    @IBOutlet weak var contactsEmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        
        profileImageView.isUserInteractionEnabled = true
        
        // if not nil then populate the text fields with
        // the selectedNasi boys data and the profile imageview
        if selectedNasiBoy != nil {
          populateProfileImgView()
          populateTextFields()
          } else {
            
        }
    }
    
    func populateProfileImgView() {
        let urlString = selectedNasiBoy.boyProfileImageURLString
              let url = URL(fileURLWithPath: urlString)
              
              profileImageView.loadImageFromUrl(strUrl: urlString, imgPlaceHolder: "")
    }
    
    func populateTextFields() {
        guard let myId = UserInfo.curentUser?.id else {return}
                 
        boysLastNameTextField.text = selectedNasiBoy.boyLastName
        boysFirstNameTextField.text = selectedNasiBoy.boyFirstName
        contactsLastNameTextField.text = selectedNasiBoy.decisionMakerLastName
        contactsFirstNameTextField.text = selectedNasiBoy.decisionMakerFirstName
        contactsCellTextField.text = selectedNasiBoy.decisionMakerCell
        contactsEmailTextField.text = selectedNasiBoy.decisionMakerEmail
     }
    
    // when save is tapped we figure if we are editing or adding a new
    // nasi boy
    @IBAction func saveTapped(_ sender: Any) {
        self.view.showLoadingIndicator()
        uploadPhotoGetURLAndLoadDataToFireBase()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        
    }
    
    
        
        
    func createDictionaryAndPostToFirebase(url: URL) {
            guard let myId = UserInfo.curentUser?.id else {return}
            
        if selectedNasiBoy != nil {
            
        selectedNasiBoy.addedByShadchanUserID = myId
        selectedNasiBoy.boyProfileImageURLString = url.absoluteString
        
            // get the current values from text fields and update
            // the properties of selected nai boy
            selectedNasiBoy.boyLastName =  boysLastNameTextField.text!
            selectedNasiBoy.boyFirstName = boysFirstNameTextField.text!
            selectedNasiBoy.decisionMakerLastName = contactsLastNameTextField.text!
            selectedNasiBoy.decisionMakerFirstName = contactsFirstNameTextField.text!
            selectedNasiBoy.decisionMakerCell = contactsCellTextField.text!
            selectedNasiBoy.decisionMakerEmail = contactsEmailTextField.text!
            
            let dictionaryForFB = selectedNasiBoy.toAnyObject()
            
            // because we are editing then we should have
            // valid values for selectedNasi boy
            //let ref = selectedNasiBoy.ref
            //let key = selectedNasiBoy.key
            
            // get the current reference to current boy
            let firstName = selectedNasiBoy.boyFirstName
            let lastName = selectedNasiBoy.boyLastName
        
        
            let boysName = firstName + lastName
            let currentBoysRef = allNasiBoysRef.child(boysName)
            
            currentBoysRef.updateChildValues(dictionaryForFB as! [AnyHashable : Any])
            
        } else {
            var newNasiBoy = NasiBoy(addedByShadchanUserID: myId, decisionMakerLastName: contactsLastNameTextField.text!, decisionMakerFirstName: contactsFirstNameTextField.text!, decisionMakerCell: contactsCellTextField.text!, decisionMakerEmail: contactsEmailTextField.text!, boyLastName: boysLastNameTextField.text!, boyFirstName: boysFirstNameTextField.text!, boyProfileImageURLString: url.absoluteString)
            
             let dictionaryForFB = newNasiBoy.toAnyObject()
            
              let firstName = newNasiBoy.boyFirstName
              let lastName = newNasiBoy.boyLastName
              let boysName = firstName + lastName
            
              let currentBoysRef = allNasiBoysRef.child(boysName)
              currentBoysRef.updateChildValues(dictionaryForFB as! [AnyHashable : Any])
            
        }
        
          self.view.hideLoadingIndicator()
            navigationController?.popViewController(animated: true)
    }
    
    func uploadPhotoGetURLAndLoadDataToFireBase() {
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("boy_profile_images").child("\(imageName).jpg")
           
        if let profileImage = self.profileImageView.image, let uploadData = profileImage.jpegData(compressionQuality: 0.1) {

        storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
        if let error = err {
            print(error)
            return
        }
        storageRef.downloadURL(completion: { (url, err) in
          if let err = err {
           print(err)
            return
        }
        guard let url = url else { return }
        
        // now that we have the url we can push the data to realtime
            self.createDictionaryAndPostToFirebase(url: url)
        })
     })
    }
  }
    
    
    @objc func handleSelectProfileImageView() {
            let picker = UIImagePickerController()
            
            picker.delegate = self
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }
        
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // Local variable inserted by Swift 4.2 migrator.
    let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

            
            var selectedImageFromPicker: UIImage?
            
            if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
                selectedImageFromPicker = editedImage
            } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                
                selectedImageFromPicker = originalImage
            }
            
            if let selectedImage = selectedImageFromPicker {
                profileImageView.image = selectedImage
            }
            
            dismiss(animated: true, completion: nil)
            
        }
    
    
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            print("canceled picker")
            dismiss(animated: true, completion: nil)
        }
        
    }

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    
    
    



