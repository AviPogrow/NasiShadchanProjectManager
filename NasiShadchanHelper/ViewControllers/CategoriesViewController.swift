//
//  CategoriesViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 4/24/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Firebase
import ObjectMapper

class CategoriesViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    var messages = [[String: Any]]()
    
    //var arrGirlsList = [NasiGirlsList]()
    var arrayOfNasiGirls = [NasiGirl]()
    var selectedNasiBoy: NasiBoy!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedNasiBoy == nil {
            
            
        }
        
      fetchAndCreateNasiGirlsArray()
      setupNavBarWithUser()
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
            //if let profileImageUrl = user.profileImageUrl {
           //     profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
           // }
        
            profileImageView.image = UIImage(named: "face04")
            
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
        nameLabel.text =  selectedNasiBoy.boyFirstName + " " + selectedNasiBoy.boyLastName   //user.name
        
        let urlString = selectedNasiBoy.boyProfileImageURLString
        profileImageView.loadImageFromUrl(strUrl: urlString, imgPlaceHolder: "")

        //profileImageView.image = 
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
    
    
    
    
    
    
    func fetchAndCreateNasiGirlsArray() {
      self.view.showLoadingIndicator()
      
      let allNasiGirlsRef = Database.database().reference().child("NasiGirlsList")
        
     allNasiGirlsRef.observe(.value, with: { snapshot in
        
        var nasiGirlsArray: [NasiGirl] = []
    
          for child in snapshot.children {
            let snapshot = child as? DataSnapshot
               let nasiGirl = NasiGirl(snapshot: snapshot!)
            nasiGirlsArray.append(nasiGirl)
        }
        
        self.arrayOfNasiGirls = nasiGirlsArray
        self.view.hideLoadingIndicator()
         self.setBadgeCount()
      })
    }
    
 
    // MARK: -Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    
    func setBadgeCount() {
        if let tabItems = self.tabBarController?.tabBar.items {
            if arrayOfNasiGirls.count > 0 {
                let tabItem = tabItems[0]
                tabItem.badgeValue = "\(arrayOfNasiGirls.count)" // set Badge count you need
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AllNasiGirls" {
            let controller = segue.destination as! AllNasiGirlsViewController
            
            controller.allNasiGirlsList  = arrayOfNasiGirls
            controller.selectedNasiBoy = selectedNasiBoy
            
        }
        
        if segue.identifier == "ShowFullTimeYeshiva" {
            
            /*
            Analytics.logEvent("categories_action", parameters: [
                "item_name": "Full Time Yeshiva",
            ])
            */
            
            let controller = segue.destination as! FullTimeYeshivaViewController
            controller.arrGirlsList = arrayOfNasiGirls
            controller.selectedNasiBoy = selectedNasiBoy
            
        } else if segue.identifier == "ShowFullTimeCollege/Working" {
            
            /*
            Analytics.logEvent("categories_action", parameters: [
                "item_name": "Full Time College/Working",
            ])
             */
            
            let controller = segue.destination as! FullTimeCollegeWorkingViewController
                controller.arrGirlsList = arrayOfNasiGirls
            controller.selectedNasiBoy = selectedNasiBoy
            
            } else if segue.identifier  == "ShowYeshivaAndCollege/Working" {
            
            /*
            Analytics.logEvent("categories_action", parameters: [
                "item_name": "Yeshiva And College/Working",
            ])
 */
            
            let controller = segue.destination as! YeshivaAndCollegeWorkingViewController
            controller.arrGirlsList = arrayOfNasiGirls
            controller.selectedNasiBoy = selectedNasiBoy
        }
    }
}

// MARK:- IBActions
extension CategoriesViewController {
    @IBAction func btnlogoutAction(_ sender: Any) {
        
        let alertControler = UIAlertController.init(title:"Logout", message: Constant.ValidationMessages.msgLogout, preferredStyle:.alert)
        alertControler.addAction(UIAlertAction.init(title:"Yes", style:.default, handler: { (action) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            // removes it from user defaults
            UserInfo.resetCurrentUser()
            
            // make the authVC the rootVC
            AppDelegate.instance().makingRootFlow(Constant.AppRootFlow.kAuthVc)
        }))
        alertControler.addAction(UIAlertAction.init(title:"No", style:.destructive, handler: { (action) in
        }))
        self.present(alertControler,animated:true, completion:nil)
    }
}


