//
//  NasiMatch.swift
//  NasiShadchanHelper
//
//  Created by username on 1/26/21.
//  Copyright © 2021 user. All rights reserved.
//

import Foundation
import Firebase

class NasiMatch: NSObject {
    
    var  ref: DatabaseReference?
    var  key: String = ""
    var boyID: String = ""
    var boyName: String = ""
    var girlID: String = ""
    var girlName: String = ""
    var shadchanID: String = ""
    var shadchanName: String = ""
    
    init(snapshot: DataSnapshot) {
           
        // FB snapshot has a ref and key property
        self.ref = snapshot.ref
        self.key = snapshot.key
       
        guard  let value = snapshot.value! as? [String: String] else { return }
        
        let boyID = value["boyID"] ?? "N/A"
        let boyName = value["boyName"] ?? "N/A"
        
        let girlID = value["girlID"] ?? "N/A"
        let girlName = value["girlName"] ?? "N/A"
        
        let shadchanID = value["shadchanID"] ?? "N/A"
        let shadchanName = value["shadchanName"] ?? "N/A"
        
        self.boyID = boyID
        self.boyName = boyName
        self.girlID = girlID
        self.girlName = girlName
        self.shadchanID = shadchanID
        self.shadchanName = shadchanName
        
    }
    
    init(boyID:String,boyName:String,girlID:String,girlName:String,shadchanID:String,shadchanName:String,key:String = "") {
        
     self.ref = nil
     self.key = key
        
     self.boyID = boyID
     self.boyName = boyName
     self.girlID = girlID
     self.girlName = girlName
     self.shadchanID = shadchanID
     self.shadchanName = shadchanName
        
    }
    
    func toAnyObject() -> Any {
       return [
         "boyID": boyID,
         "boyName": boyName,
         "girlID": girlID,
         "girlName": girlName,
         "shadchanID": shadchanID,
         "shadchanName":shadchanName
         ]
     }
}
