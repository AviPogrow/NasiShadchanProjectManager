//
//  AddEditBoyViewController.swift
//  NasiShadchanHelper
//
//  Created by username on 1/19/21.
//  Copyright © 2021 user. All rights reserved.
//

import UIKit
import Firebase

class AddEditBoyViewController: UITableViewController {

let allNasiBoysRef = Database.database().reference().child("NasiBoysList")
   
   
    var selectedNasiBoy: NasiBoy!
    
    @IBOutlet weak var boysLastNameTextField: UITextField!
    @IBOutlet weak var boysFirstNameTextField: UITextField!
    
    
    @IBOutlet weak var contactsLastNameTextField: UITextField!
    @IBOutlet weak var contactsFirstNameTextField: UITextField!
    @IBOutlet weak var contactsCellTextField: UITextField!
    @IBOutlet weak var contactsEmailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedNasiBoy != nil {
            
             guard let myId = UserInfo.curentUser?.id else {return}
            
            boysLastNameTextField.text = selectedNasiBoy.boyLastName
            boysFirstNameTextField.text = selectedNasiBoy.boyFirstName
            
            contactsLastNameTextField.text = selectedNasiBoy.decisionMakerLastName
            contactsFirstNameTextField.text = selectedNasiBoy.decisionMakerFirstName
            
            contactsCellTextField.text = selectedNasiBoy.decisionMakerCell
            contactsEmailTextField.text = selectedNasiBoy.decisionMakerEmail
            
           
            
        } else {
            
        }

    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        
         // if selectedNasiBoy isn't nil then we are
         // editing
         if let selectedNasiBoy = selectedNasiBoy {
            
            guard let myId = UserInfo.curentUser?.id else {return}
            selectedNasiBoy.addedByShadchanUserID = myId
            
            selectedNasiBoy.boyLastName =  boysLastNameTextField.text!
            selectedNasiBoy.boyFirstName = boysFirstNameTextField.text!
            selectedNasiBoy.decisionMakerLastName = contactsLastNameTextField.text!
            
            selectedNasiBoy.decisionMakerFirstName = contactsFirstNameTextField.text!
            selectedNasiBoy.decisionMakerCell = contactsCellTextField.text!
            selectedNasiBoy.decisionMakerEmail = contactsEmailTextField.text!
            
            let dictionaryForFB = selectedNasiBoy.toAnyObject()
            
    
          
            let ref = selectedNasiBoy.ref
            let key = selectedNasiBoy.key
            
            // get the current reference to current boy
            let firstName = selectedNasiBoy.boyFirstName
            let lastName = selectedNasiBoy.boyLastName
            let boysName = firstName + lastName
            let currentBoysRef = allNasiBoysRef.child(boysName)
            //let usersCurrentBoyRef = allNasiBoysRef.child(boysName).child(key)
            
            
            currentBoysRef.updateChildValues(dictionaryForFB as! [AnyHashable : Any])
            
            
            
         } else {
            addNasiBoyToShadchansBoyList()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func addNasiBoyToShadchansBoyList() {
        
        guard let myId = UserInfo.curentUser?.id else {
                        return
               }
        
        let newNasiBoy =
            NasiBoy(addedByShadchanUserID: myId, decisionMakerLastName:  contactsLastNameTextField.text ?? "N/A", decisionMakerFirstName: contactsFirstNameTextField.text ?? "N/A", decisionMakerCell: contactsCellTextField.text ?? "N/A", decisionMakerEmail: contactsEmailTextField.text ?? "N/A", boyLastName: boysLastNameTextField.text ?? "N/A", boyFirstName: boysFirstNameTextField.text ?? "N/A")
        
       
        
        let dict = newNasiBoy.toAnyObject()
        
        let boysName = newNasiBoy.boyFirstName + newNasiBoy.boyLastName
        allNasiBoysRef.child(boysName).setValue(dict)
        
        }
    
    
}
