//
//  FinalResultPickerViewController.swift
//  NasiShadchanHelper
//
//  Created by username on 2/14/21.
//  Copyright © 2021 user. All rights reserved.
//

import UIKit

protocol FinalResultPickerViewControllerDelegate: class {
 
func resultPicker(_ picker: FinalResultPickerViewController, didPick result: String)
}

class FinalResultPickerViewController: UITableViewController {
    
    var selectedIndex: Int!
    var selectedProjectResult = "Resume needs to be sent"
    
   let projectResults = [
        "Resume needs to be sent",
        "Resume Sent Needs Follow Up",
        "1st Date",
        "Not Interested",
        "Not saying no, not ready to say yes"]
    
    var selectedIndexPath = IndexPath()
    
    weak var delegate: FinalResultPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<projectResults.count {
            if projectResults[i] == selectedProjectResult {
                selectedIndexPath = IndexPath(row: i, section: 0)
                break
            }
            
        }
    }
    
     // MARK: -Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK:- Table View Delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectResults.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
     let cell = tableView.dequeueReusableCell(
                withIdentifier: "Cell",
                for: indexPath)
            
            let projectResult = projectResults[indexPath.row]
            cell.textLabel!.text = projectResult
            
            if projectResult == selectedProjectResult { cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
                
            }
            return cell
            
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // get reference to delegate and check for nil
        if let delegate = delegate {
             // get current project result string
             let projectResult = projectResults[indexPath.row]
             // pass it to the delegate
            delegate.resultPicker(self, didPick: projectResult)
           }
        
        
        
        
        if indexPath.row != selectedIndexPath.row {
            if let newCell = tableView.cellForRow(at: indexPath) {
                newCell.accessoryType = .checkmark
                
            }
            if let oldCell = tableView.cellForRow( at: selectedIndexPath) {
                oldCell.accessoryType = .none
                
            }
            
            selectedIndexPath = indexPath
            self.navigationController?.popViewController(animated: true)
        }
    }
}

    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

   

    



