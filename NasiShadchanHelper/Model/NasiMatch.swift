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
    var boyFirstName: String = ""
    var boyLastName: String = ""
    var boyProfileImageURLPath: String = ""
    
    var girlFirstName: String = ""
    var girlLastName: String = ""
    var girlID: String = ""
    var girlProfileImageURLPath = ""
    var girlResumeURLPath = ""

    var shadchanID: String = ""
    var shadchanEmail: String = ""
    var shadchanFirstName: String = ""
    var shadchanLastName: String = ""
    
    var lastActivity: String = ""
    var projectStatus: String = ""
    var nextTask: String = ""
    var projectResult: String = ""
    
    var  decisionMakerFirstName: String = ""
    var  decisionMakerLastName: String = ""
    var  decisionMakerCell: String = ""
    var  decisionMakerEmail: String = ""
    
     var timeStamp: String = "\(Date())"
    
    
    
    // get snapshot from firebase and parse into swift object
    init(snapshot: DataSnapshot) {
           
        // FB snapshot has a ref and key property
        self.ref = snapshot.ref
        self.key = snapshot.key
       
        guard  let value = snapshot.value! as? [String: String] else { return }
        
        let boyID = value["boyID"] ?? "N/A"
        let boyFirstName = value["boyFirstName"] ?? "N/A"
        let boyLastName = value["boyLastName"] ?? "N/A"
        let boyProfileImageURLPath = value["boyProfileImageURLPath"] ?? "N/A"
        
        let girlID = value["girlID"] ?? "N/A"
        let girlFirstName = value["girlFirstName"] ?? "N/A"
        let girlLastName = value["girlLastName"] ?? "N/A"
        let girlProfileImageURLPath = value["girlProfileImageURLPath"] ?? "N/A"
        let girlResumeURLPath = value["girlResumeURLPath"] ?? "N/A"
        
        let shadchanID = value["shadchanID"] ?? "N/A"
        let shadchanFirstName = value["shadchanFirstName"] ?? "N/A"
        let shadchanLastName = value["shadchanLastName"] ?? "N/A"
        
        let  decisionMakerFirstName = value["decisionMakerFirstName"] ?? "N/A"
        let  decisionMakerLastName = value["decisionMakerLastName"] ?? "N/A"
        
        var  decisionMakerCell = value["decisionMakerCell"] ?? "N/A"
        var  decisionMakerEmail = value["decisionMakerEmail"] ?? "N/A"
        
        
         let lastActivity = value["lastActivity"] ?? "N/A"
        let projectStatus = value["projectStatus"] ?? "N/A"
          var nextTask: String = value["nextTask"] ?? "N/A"
        var projectResult: String = value["projectResult"] ?? "N/A"
        
        var timeStamp = value["timeStamp"] ?? "N/A"
        
        
        
        self.boyID = boyID
        self.boyFirstName = boyFirstName
        self.boyLastName = boyLastName
        self.boyProfileImageURLPath = boyProfileImageURLPath
        
        self.girlID = girlID
        self.girlFirstName = girlFirstName
        self.girlLastName = girlLastName
        self.girlProfileImageURLPath = girlProfileImageURLPath
        self.girlResumeURLPath = girlResumeURLPath
        
        self.shadchanID = shadchanID
        self.shadchanFirstName = shadchanFirstName
        self.shadchanLastName = shadchanLastName
        
        self.lastActivity = lastActivity
        self.projectStatus = projectStatus
        self.nextTask = nextTask
        self.projectResult = projectResult
        
        self.decisionMakerFirstName = decisionMakerFirstName
        self.decisionMakerLastName = decisionMakerLastName
        self.decisionMakerCell = decisionMakerCell
        self.decisionMakerEmail = decisionMakerEmail
        self.timeStamp = timeStamp
        
    }
    
    // take data from user interface and init a swift object
    // convert swift object into dictionary to upload to firebase
    init(boyID:String,
         boyFirstName:String,
         boyLastName:String,
         boyProfileImageURLPath: String,
         girlID:String,
         girlFirstName:String,
         girlLastName: String,
         girlProfileImageURLPath: String,
         girlResumeURLPath:String,
         shadchanID:String,
         shadchanFirstName:String,
         shadchanLastName:String,
         lastActivity:String,
         projectStatus: String,
         nextTask: String,
         projectResult: String,
         decisionMakerFirstName:String,
         decisionMakerLastName:String,
          decisionMakerEmail:String,
          decisionMakerCell:String,
          key:String = "") {
        
     self.ref = nil
     self.key = key
      self.boyID = boyID
     self.boyFirstName = boyFirstName
     self.boyLastName = boyLastName
     self.boyProfileImageURLPath = boyProfileImageURLPath
     
     self.girlID = girlID
     self.girlFirstName = girlFirstName
     self.girlLastName = girlLastName
    self.girlProfileImageURLPath = girlProfileImageURLPath
    self.girlResumeURLPath = girlResumeURLPath
     self.shadchanID = shadchanID
     self.shadchanFirstName = shadchanFirstName
     self.shadchanLastName = shadchanLastName
        
    self.lastActivity = lastActivity
    self.projectStatus = projectStatus
    self.nextTask = nextTask
    self.projectResult = projectResult
    self.decisionMakerFirstName = decisionMakerFirstName
    self.decisionMakerLastName = decisionMakerLastName
    self.decisionMakerCell = decisionMakerCell
    self.decisionMakerEmail = decisionMakerEmail
    self.timeStamp = "\(Date())"
    }
    
    func toAnyObject() -> Any {
       return [
         "boyID": boyID,
         "boyFirstName": boyFirstName,
         "boyLastName": boyLastName,
         "boyProfileImageURLPath": boyProfileImageURLPath,
         "girlID": girlID,
         "girlFirstName": girlFirstName,
         "girlLastName": girlLastName,
         "girlProfileImageURLPath": girlProfileImageURLPath,
         "girlResumeURLPath": girlResumeURLPath,
         "shadchanID": shadchanID,
         "shadchanFirstName":shadchanFirstName,
         "shadchanLastName": shadchanLastName,
         "projectStatus":projectStatus,
         "nextTask":nextTask,
         "projectResult":projectResult,
         "decisionMakerFirstName":decisionMakerFirstName,
         "decisionMakerLastName":decisionMakerLastName,
         "decisionMakerCell":decisionMakerCell,
         "decisionMakerEmail":decisionMakerEmail,
        "timeStamp": timeStamp
         ]
     }
}
    
    
  /*
 func saveMatchToAllNasiShidduchProjects() {
        guard let shadchanID = UserInfo.curentUser?.id else { return }
     
        
        //init a swift nasi match object
        let newShidduchProject = NasiMatch(
                           boyID: "dovisherrer",
                           boyFirstName: "Dovi",
                           boyLastName: "Sherrer",
                           boyProfileImageURLPath: "",
                           girlID: "chavagoldstein",
                           girlFirstName: "Chava",
                           girlLastName: "Goldsteing",
                           girlProfileImageURLPath: "",
                           girlResumeURLPath: "",
                           shadchanID: "ABC123",
                           shadchanFirstName: "Sharon",
                           shadchanLastName: "Lieber",
                           lastActivity: "sent resume",
                           projectStatus: "",
                           nextTask: "",
                           projectResult: "1stDated",
                           decisionMakerFirstName: "Sara",
                           decisionMakerLastName: "Goldman",
                           decisionMakerEmail: "rstring@gmail.com",
                           decisionMakerCell: "2223334455")
        
        // convert swift object to dictionary to load into fb
        let newMatchDict = newShidduchProject.toAnyObject()
        
        var boyAndGirlNames = "DoviSherrerChavaGoldstein"
    
        var sentResRef = Database.database().reference(withPath: "AllNasiShidduchProjects")
    
        sentResRef.child(boyAndGirlNames).setValue(newMatchDict){
                    (error, ref) in
                          
                    if error != nil {
                        //print(error?.localizedDescription ?? “”)
                              
                     } else {
                     //hudView.text = "Save Successful!"
                              
                     }
                    }
        }
*/





