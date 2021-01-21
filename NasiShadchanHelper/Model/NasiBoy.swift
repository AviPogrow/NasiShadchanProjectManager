//
//  NasiBoy.swift
//  NasiShadchanHelper
//
//  Created by username on 1/19/21.
//  Copyright © 2021 user. All rights reserved.
//
import Foundation
import Firebase

class NasiBoy: NSObject {
    
    var  ref: DatabaseReference?
    var  key: String = ""
    var  boyFirstName: String = ""
    var  boyLastName: String = ""
    var  decisionMakerLastName: String = ""
    var  decisionMakerFirstName: String = ""
    var  decisionMakerCell: String = ""
    var  decisionMakerEmail: String = ""
    
     init(snapshot: DataSnapshot) {
        
        // FB snapshot has a ref and key property
        self.ref = snapshot.ref
        self.key = snapshot.key
    
        guard  let value = snapshot.value! as? [String: String] else { return }
         
        
         let decisionMakerLastName = value["decisionMakerLastName"] ?? "N/A"
         let decisionMakerFirstName = value["decisionMakerFirstName"] ?? "N/A"
        
        let decisionMakerCell = value["decisionMakerCell"] ?? "N/A"
        let decisionMakerEmail = value["decisionMakerEmail"] ?? "N/A"
        
        let boyLastName = value["boyLastName"] ?? "N/A"
        let boyFirstName = value["boyFirstName"] ?? "N/A"
        
        self.decisionMakerLastName = decisionMakerLastName
        self.decisionMakerFirstName = decisionMakerFirstName
        
        self.decisionMakerCell = decisionMakerCell
        self.decisionMakerEmail = decisionMakerEmail
        self.boyLastName = boyLastName
        self.boyFirstName = boyFirstName
        
    
    }
    
    init(decisionMakerLastName: String, decisionMakerFirstName: String, decisionMakerCell: String, decisionMakerEmail:String, boyLastName:String, boyFirstName: String, key: String = "") {
        
      self.ref = nil
      self.key = key
      self.decisionMakerLastName = decisionMakerLastName
      self.decisionMakerFirstName = decisionMakerFirstName
      self.decisionMakerCell = decisionMakerCell
      self.decisionMakerEmail = decisionMakerEmail
      self.boyLastName = boyLastName
      self.boyFirstName = boyFirstName
    
    }
    
    
    func toAnyObject() -> Any {
       return [
         "decisionMakerLastName": decisionMakerLastName,
         "decisionMakerFirstName": decisionMakerFirstName,
         "decisionMakerCell": decisionMakerCell,
         "decisionMakerEmail": decisionMakerEmail,
         "boyLastName": boyLastName,
         "boyFirstName":boyFirstName
         
         
       ]
     }
    
    

}
