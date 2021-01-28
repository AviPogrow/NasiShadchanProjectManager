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
            
            selectedNasiBoy.boyLastName =  boysLastNameTextField.text!
            selectedNasiBoy.boyFirstName = boysFirstNameTextField.text!
            selectedNasiBoy.decisionMakerLastName = contactsLastNameTextField.text!
            
            selectedNasiBoy.decisionMakerFirstName = contactsFirstNameTextField.text!
            selectedNasiBoy.decisionMakerCell = contactsCellTextField.text!
            selectedNasiBoy.decisionMakerEmail = contactsEmailTextField.text!
            
            let dictionaryForFB = selectedNasiBoy.toAnyObject()
            
    guard let myId = UserInfo.curentUser?.id else {return}
          
            let ref = selectedNasiBoy.ref
            let key = selectedNasiBoy.key
            
            // get the current reference to current boy
            let firstName = selectedNasiBoy.boyFirstName
            let lastName = selectedNasiBoy.boyLastName
            let boysName = firstName + lastName
            let currentBoysRef = allNasiBoysRef.child(boysName)
            let usersCurrentBoyRef = allNasiBoysRef.child(myId).child(key)
            
            
            usersCurrentBoyRef.updateChildValues(dictionaryForFB as! [AnyHashable : Any])
            
            
            
         } else {
            addNasiBoyToShadchansBoyList()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func addNasiBoyToShadchansBoyList() {
        
        let newNasiBoy =
                NasiBoy(decisionMakerLastName: contactsLastNameTextField.text ?? "N/A", decisionMakerFirstName: contactsFirstNameTextField.text ?? "N/A", decisionMakerCell: contactsCellTextField.text ?? "N/A", decisionMakerEmail: contactsEmailTextField.text ?? "N/A", boyLastName: boysLastNameTextField.text ?? "N/A", boyFirstName: boysFirstNameTextField.text ?? "N/A")
        
        guard let myId = UserInfo.curentUser?.id else {
                 return
        }
        
        let dict = newNasiBoy.toAnyObject()
               
        allNasiBoysRef.child(myId).childByAutoId().setValue(dict)
        
        }
    
    
}
