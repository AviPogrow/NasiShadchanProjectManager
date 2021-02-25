//
//  BoysListForProjects.swift
//  NasiShadchanHelper
//
//  Created by username on 2/19/21.
//  Copyright © 2021 user. All rights reserved.
//

import UIKit
import Firebase

class BoysListForProjects: UITableViewController {

    var allBoysArray = [NasiBoy]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allBoysArray.removeAll()
        tableView.allowsMultipleSelectionDuringEditing = true
       
        let allNasiBoysRef = Database.database().reference().child("NasiBoysList")
        
        guard let myId = UserInfo.curentUser?.id else {return}
    
        allNasiBoysRef.observe(.childAdded, with: { (snapshot) in
            
            let nasiBoy = NasiBoy(snapshot: snapshot)
            
            if nasiBoy.addedByShadchanUserID == myId {
            self.allBoysArray.append(nasiBoy)
            }
            DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
            })
        })
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allBoysArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "BoysForProjectsCellID", for: indexPath) as! BoysForProjectTableViewCell
        
        let currentBoy = allBoysArray[indexPath.row]
        
        cell.firstNameLabel.text = currentBoy.boyFirstName
        cell.secondNameLabel.text = currentBoy.boyLastName
        
        let urlString = currentBoy.boyProfileImageURLString
        let url = URL(fileURLWithPath: urlString)
        
        cell.profileImageView.loadImageFromUrl(strUrl: urlString, imgPlaceHolder: "")
        
       

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       let controller = storyboard!.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
             //controller.delegate = self
        
        let selectedNasiBoy = allBoysArray[indexPath.row]
        controller.selectedNasiBoy = selectedNasiBoy
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
