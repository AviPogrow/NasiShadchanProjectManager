//
//  AllNasiGirlsViewController.swift
//  NasiShadchanHelper
//
//  Created by username on 1/12/21.
//  Copyright © 2021 user. All rights reserved.
//

import UIKit

class AllNasiGirlsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var selectedNasiBoy: NasiBoy!
    
    var allNasiGirlsList: [NasiGirl] = []
     @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        setupNavBarWithUser()
        


    allNasiGirlsList = self.allNasiGirlsList.sorted(by: { ($0.lastNameOfGirl ) < ($1.lastNameOfGirl ) })
        
    self.allNasiGirlsList = self.allNasiGirlsList.filter { (singleGirl) -> Bool in
        return singleGirl.category != Constant.CategoryTypeName.CategoryEngaged1
    }
    }
    
    func setupNavBarWithUser() {
        //func setupNavBarWithUser(_ user: User) {
               //messages.removeAll()
               //messagesDictionary.removeAll()
               //tableView.reloadData()
               
               //observeUserMessages()
               
               let titleView = UIView()
               titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
               titleView.backgroundColor = UIColor.red
               
               let containerView = UIView()
               containerView.translatesAutoresizingMaskIntoConstraints = false
               titleView.addSubview(containerView)
               
               let profileImageView = UIImageView()
               profileImageView.translatesAutoresizingMaskIntoConstraints = false
               profileImageView.contentMode = .scaleAspectFill
               profileImageView.layer.cornerRadius = 20
               profileImageView.clipsToBounds = true
               profileImageView.backgroundColor = UIColor.gray
               profileImageView.image = UIImage(named: "face04")
               //if let profileImageUrl = user.profileImageUrl {
              //     profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
              // }
               
               containerView.addSubview(profileImageView)
               
               //ios 9 constraint anchors
               //need x,y,width,height anchors
               profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
               profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
               profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
               profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
               
               let nameLabel = UILabel()
               nameLabel.backgroundColor = UIColor.white
               
               containerView.addSubview(nameLabel)
        nameLabel.text = selectedNasiBoy.boyFirstName + " " + selectedNasiBoy.boyLastName   //user.name
               nameLabel.translatesAutoresizingMaskIntoConstraints = false
               //need x,y,width,height anchors
               nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
               nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
               nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
               nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
               
               containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
               containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
               
               self.navigationItem.titleView = titleView
               
       //        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
           }
    
    
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("the array is \(allNasiGirlsList.debugDescription)")
        
        
        print("the number of girls is \(allNasiGirlsList.count)")
        
    return allNasiGirlsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllNasiListCell", for: indexPath) as! AllGirlsTableViewCell
        
        let currentGirl = allNasiGirlsList[indexPath.row]
        
        let imageURLString = currentGirl.imageDownloadURLString
        
        cell.backgroundColor = UIColor.white
        
        cell.nameTextLabel.backgroundColor = UIColor.white 
        cell.nameTextLabel.textColor = UIColor.link
        cell.nameTextLabel!.text = "\(currentGirl.nameSheIsCalledOrKnownBy)" + " " + "\(currentGirl.lastNameOfGirl)"
        
        cell.profileImageView.loadImageFromUrl(strUrl: currentGirl.imageDownloadURLString, imgPlaceHolder: "")
    
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // MARK:- Navigation
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "ShowProfileDetails" {
               
               let controller = segue.destination as! ShadchanListDetailViewController
               
               if let indexPath = tableView.indexPath(for: sender
                   as! UITableViewCell) {
                   
                  
                   let currentGirl = allNasiGirlsList[indexPath.row]
                   
                   controller.selectedNasiGirl = currentGirl
                controller.selectedNasiBoy = selectedNasiBoy
            }
        }
    }
    
    
    
    
    
}
