//
//  SentResumesProjectsViewController.swift
//  NasiShadchanHelper
//
//  Created by username on 12/17/20.
//  Copyright © 2020 user. All rights reserved.
//


import UIKit
import Firebase

class SentResumesProjectsViewController: UITableViewController {
    
    
    
    var sentResRef = Database.database().reference(withPath: "AllNasiShidduchProjects")
    
    var arrayOfNasiProjects: [NasiMatch] = [NasiMatch]()
    var arrayOfNasiGirls: [NasiGirl] = [NasiGirl]()
    var reversedArrayOfNasiGirls: [NasiGirl] = [NasiGirl]()
    //var sentGirlsAutoIDs: [String] = [String]()
    
    var selectedGirlID = ""
    var projectResult = "Needs Follow Up"
    var nasiGirl: NasiGirl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        self.arrayOfNasiProjects.removeAll()
        tableView.allowsMultipleSelectionDuringEditing = true
        
       // get the current user's id
       guard let currentUserId = UserInfo.curentUser?.id else {return}
        
     // for each child in the list we extract the key value pairs
       sentResRef.observe(.childAdded, with: { (snapshot) in
        
        // get the key value pairs as a dictionary
        let value = snapshot.value as? [String: AnyObject]
            
        let shadchanID = value!["shadchanID"] as! String
        
        if shadchanID == currentUserId {
            
        // init a nasi match from the snapshot object
        // add the object to the array and load the tableView
        let newNasiMatch = NasiMatch(snapshot: snapshot)
        self.arrayOfNasiProjects.append(newNasiMatch)
        self.arrayOfNasiProjects.reverse()
        }
        
        DispatchQueue.main.async(execute: {
         self.tableView.reloadData()
        })
        }, withCancel: nil)
            
      
    }
    
   
        
    
   
    
    
  
 
    
    /*
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
      
      let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
      controller.delegate = self
      
      let checklist = dataModel.lists[indexPath.row]
      controller.checklistToEdit = checklist
      
      navigationController?.pushViewController(controller, animated: true)
    }
 */
    
   
   
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    
      // 1. segue id
           if segue.identifier == "ShowProjectDetails" {
         
           // 2. segue destination as
           let controller = segue.destination as! ProjectDetailsViewController
            
            
            // 3. get index path
            if let indexPath = tableView.indexPath(for: sender
                                      as! UITableViewCell) {
            //4. index into array to get current girl
                let currentNasiProject = arrayOfNasiProjects[indexPath.row]
                controller.selectedProject = currentNasiProject
            }
        }
    }
    
    // MARK: UITableView Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfNasiProjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       let cellID = "NasiProjectCell"
       let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NasiProjectCell
         
        let nasiProject = arrayOfNasiProjects[indexPath.row]
        
        
        let urlString = nasiProject.boyProfileImageURLPath
        let url = URL(fileURLWithPath: urlString)
        
        cell.boysImageView.loadImageFromUrl(strUrl: urlString, imgPlaceHolder: "")
        
        
        let urlStringGirl = nasiProject.girlProfileImageURLPath
        let urlForGirl = URL(fileURLWithPath: urlStringGirl)
        
        cell.girlsImageView.loadImageFromUrl(strUrl: urlStringGirl, imgPlaceHolder: "")
        
        
        cell.configureCellForProject(currentProject: nasiProject)
       
        return cell
     }
    
      
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       return true
     }
    
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
            
            let currentProject = arrayOfNasiProjects[indexPath.row]
            let currentProjectRef = currentProject.ref
            guard let myId = UserInfo.curentUser?.id else {return}
            
            currentProjectRef!.removeValue {
                (error, dbRef) in
               
                if error != nil {
                print(error!.localizedDescription)
                
                } else {
                    
                self.arrayOfNasiGirls.remove(at: indexPath.row)
                let indexPathsToDelete = [indexPath]
                self.tableView.deleteRows(at: indexPathsToDelete, with: .left)
                //self.tableView.reloadData()
                
            }
           }
          }
        }
}

extension SentResumesProjectsViewController {
   
  
    
    func resultPicker(_ picker: FinalResultPickerViewController, didPick result: String, forProjectAt index: Int){
        let passedBackIndex = index
        let currentProject = arrayOfNasiProjects[index]
        
        
        //self.sentResRef.child(myId).child(currentGirlKey).removeValue {
          //            (error, dbRef) in
        
        
        
        
        // get the property .projectResult and writeover then new value
        // now the new value needs to be pushed to firebase
        // and pulleld down to the list of sent resumes
        currentProject.projectResult = result
        
        //let fbUpdateDict = [projectResult: result]
        
        // this shouold work by writing over all properties
        let dictionaryForFB = currentProject.toAnyObject()
        
        // get the fb database and update child value
        // sentResRef.updateChildValues(dictionaryForFB as! [AnyHashable : Any])
        
        sentResRef.setValue(dictionaryForFB)
        
        
        DispatchQueue.main.async(execute: {
            
           
            
            self.tableView.reloadData()
        })
        
        
    }
  
    
    
   
func finalResultViewController(_ controller: FinalResultPickerViewController, didFinishEditing match: NasiMatch) {
    
       if let index = arrayOfNasiProjects.firstIndex(of: match) {
         
       let indexPath = IndexPath(row: index, section: 0)
         if let cell = tableView.cellForRow(at: indexPath) {
            
            let currentProject = arrayOfNasiProjects[indexPath.row]
            //cell.configureCellForProject(currentProject: currentProject)
           //configureText(for: cell, with: match)
         }
       }
       navigationController?.popViewController(animated:true)
     }
}

