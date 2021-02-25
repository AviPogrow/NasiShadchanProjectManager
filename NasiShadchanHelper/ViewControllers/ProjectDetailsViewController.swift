//
//  ProjectDetailsViewController.swift
//  NasiShadchanHelper
//
//  Created by username on 2/15/21.
//  Copyright © 2021 user. All rights reserved.
//

import UIKit
import Firebase

class ProjectDetailsViewController: UITableViewController, FinalResultPickerViewControllerDelegate {
    
    

    var selectedProject: NasiMatch!
    var nasiGirl: NasiGirl!
    var nasiBoy: NasiBoy!
    
    
    @IBOutlet weak var girlProfileImageView: UIImageView!
    
    @IBOutlet weak var girlNameLabel: UILabel!
    @IBOutlet weak var boyProfileImageView: UIImageView!
    @IBOutlet weak var boyNameLabel: UILabel!
    @IBOutlet weak var boyProfileDetailsLabel: UILabel!
    @IBOutlet weak var girlsProfileDetailsLabel: UILabel!
    @IBOutlet weak var recentActivityLabel: UILabel!
    @IBOutlet weak var projectResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let boyProfileImagePath = selectedProject.boyProfileImageURLPath
        let boyProfileImageURL = URL(fileURLWithPath: boyProfileImagePath)
       // let boyProfileImage = UIImage(contentsOfFile: <#T##String#>)
        //boyProfileImageView.image = boyProfileImage
        let urlString = selectedProject.boyProfileImageURLPath
               let url = URL(fileURLWithPath: urlString)
               
        boyProfileImageView.loadImageFromUrl(strUrl: urlString, imgPlaceHolder: "")
        
        
        
        let girlurlString = selectedProject.girlProfileImageURLPath
        //let girlProfileImageURL = URL(fileURLWithPath: girlProfileImagePath)
        girlProfileImageView.loadImageFromUrl(strUrl: girlurlString, imgPlaceHolder: "")
        
        
        
        boyNameLabel.text =  selectedProject.boyFirstName + " " + selectedProject.boyLastName
        girlNameLabel.text = selectedProject.girlFirstName + " " + selectedProject.girlLastName
    boyProfileDetailsLabel.text =  selectedProject.boyFirstName + " " + selectedProject.boyLastName + " Profile Details"
        
    girlsProfileDetailsLabel.text = selectedProject.girlFirstName + " " + selectedProject.girlLastName + " Profile Details"
        
    recentActivityLabel.text = "Emailed resume 4 days ago"
    projectResultLabel.text = "Not saying no not saying yes"

    }
    
    
    
    // MARK:- Navigation
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
              
          if segue.identifier == "ShowProjectStatuses" {
           let controller = segue.destination as! FinalResultPickerViewController
            
    
        if let indexPath = tableView.indexPath(for: sender
                                                as! UITableViewCell) {
            controller.delegate = self
            controller.selectedIndexPath = indexPath
            
        
       }
       }
    }
    
    // for the segue to the boys detail scene
    func getCurrentFBBoyAndPassInSegue(indexer: Int) {
        self.view.showLoadingIndicator()
                
        // get the current user's id
        guard let currentUserId = UserInfo.curentUser?.id else {return}
        // get the boys id from the project
        let boyID = selectedProject.boyID
        
        // use girls id to build child path under NasiGirlsList
        let allNasiGirlsRef = Database.database().reference().child("NasiBoysList")
        
        let selectedBoysRef = allNasiGirlsRef.child(boyID)
        
        selectedBoysRef.observe(.value, with: { (snapshot) in
            self.nasiBoy = NasiBoy(snapshot: snapshot)
            
        DispatchQueue.main.async(execute: {
                   
        self.view.hideLoadingIndicator()
                    
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddEditBoyViewController") as! AddEditBoyViewController
        controller.selectedNasiBoy = self.nasiBoy
        
        self.navigationController?.pushViewController(controller, animated: true)
                    
        })
                  
        }, withCancel: nil)
     }
    
     // for segue to girls detail scene
     func getCurrentGirlFBObjectAndPassInSegue(indexer: Int) {
         self.view.showLoadingIndicator()
         
         // get the current user's id
         guard let currentUserId = UserInfo.curentUser?.id else {return}
          
         
         // get the girls id from the project
         let girlID = selectedProject.girlID
        
        // use girls id to build child path under NasiGirlsList
         let allNasiGirlsRef = Database.database().reference().child("NasiGirlsList")
         
         let selectedGirlsRef = allNasiGirlsRef.child(girlID)
         selectedGirlsRef.observe(.value, with: { (snapshot) in
         
         let nasiGirlFromSnapshot = NasiGirl(snapshot: snapshot)
         
         self.nasiGirl = nasiGirlFromSnapshot
             DispatchQueue.main.async(execute: {
            
             self.view.hideLoadingIndicator()
             
             let controller = self.storyboard!.instantiateViewController(withIdentifier: "ShadchanListDetailViewController") as! ShadchanListDetailViewController
                
             controller.selectedNasiGirl = self.nasiGirl
            controller.seletedShidduchProject = self.selectedProject
                
             controller.isInstantiatedFromProjectDetails = true
             self.navigationController?.pushViewController(controller, animated: true)
             
         })
                  
         }, withCancel: nil)
       }

    
    // MARK: - Table view data source
    // going from project details data to specific girl data
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // go to firebase and get the selected girl and pull
        // it down and init a swift nasi girl object
        // that girl gets pased to the girl's profile detailsVC
        if indexPath.section == 0 && indexPath.row == 2 {
        getCurrentGirlFBObjectAndPassInSegue(indexer: indexPath.row)
        }
        if indexPath.section == 0 && indexPath.row == 1 {
            getCurrentFBBoyAndPassInSegue(indexer: indexPath.row)
        }
    }
    
    func resultPicker(_ picker: FinalResultPickerViewController, didPick result: String) {
         let projectStatus = result
         projectResultLabel.text = projectStatus
        updateProjectStatusInFirebase(newStatus: projectStatus)
        view.hideLoadingIndicator()
          
      }
    
    func updateProjectStatusInFirebase(newStatus: String) {
        view.showLoadingIndicator()
        
        var allShidduchProjectsRef = Database.database().reference(withPath: "AllNasiShidduchProjects")
        
        var selectedProjectRef = allShidduchProjectsRef.child(selectedProject.key)
        
        let projectID = selectedProject.key
        
        let values = ["projectResult": newStatus]
        selectedProjectRef.updateChildValues(values)
        
        view.hideLoadingIndicator()
        
    }
    
   

}
