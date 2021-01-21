//
//  AddEditBoyViewController.swift
//  NasiShadchanHelper
//
//  Created by username on 1/19/21.
//  Copyright © 2021 user. All rights reserved.
//

import UIKit
//import Firebase

class AddEditBoyViewController: UITableViewController {

//let allNasiBoysRef = Database.database().reference().child("NasiBoysList")
   
    var nasiBoyToEdit: NasiBoy?
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
        }

        
    }
}
