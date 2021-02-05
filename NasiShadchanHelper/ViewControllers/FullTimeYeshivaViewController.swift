//
//  FullTimeYeshivaViewController.swift
//  NasiShadchanHelper
//
//  Created by user on 4/24/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
class FullTimeYeshivaViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    // ----------------------------------
    // MARK: - IB-OUTLET(S)
    //
    @IBOutlet weak var segmentCntrl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    fileprivate let singleCellIdentifier = "SingleCellID"
    
    var selectedNasiBoy: NasiBoy!
    var arrGirlsList = [NasiGirl]()
    
    var arrOneToFiveSingleGirls = [NasiGirl]()
    var arrFiveYearsSingleGirls = [NasiGirl]()
    var arrFiveToSevenSingleGirls = [NasiGirl]()
    var arrFilterList = [NasiGirl]()
    var arrTempFilterList = [NasiGirl]()
    var arrOnetoThreeSingleGirls = [NasiGirl]()
    var arrThreeToFiveSingleGirls = [NasiGirl]()
    
    
    var arrFilterOnetoThreeSingleGirls = [NasiGirl]()
    var arrFilterThreeToFiveSingleGirls = [NasiGirl]()
    var fiveToSevenSingleGirls = [NasiGirl]()
    var sevenPlusSingleGirls = [NasiGirl]()
    var arrSectionSearch = [NasiGirl]()
    
    var aryFirstSegmentFilter = [[NasiGirl]]() //discuss
    var searchActive:Bool = false
    
    
   var arrayForSection = [NasiGirl]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         setupNavBarWithUser()
        
         //controller.navigationItem.leftItemsSupplementBackButton = true
         //hidesbackButton = false
        //leftBarButtonItems
        //func setLeftBarButton(_ item: UIBarButtonItem?, animated: Bool)
     
        self.setUpSegmentControlApperance()
        navigationItem.title = "Full Time Yeshiva"
        
        
        arrGirlsList = self.arrGirlsList.sorted(by: { Int($0.age ) < Int($1.age ) })
        
        arrGirlsList = self.arrGirlsList.filter { (girlList) -> Bool in
            return girlList.category == Constant.CategoryTypeName.kPredicateString1  || girlList.category == Constant.CategoryTypeName.kPredicateString2 || girlList.category == Constant.CategoryTypeName.kPredicateString3
        }
        
        /*Segment Section Filter*/
        arrOnetoThreeSingleGirls = arrGirlsList.filter { singleGirl in
            singleGirl.yearsOfLearning == "1-3" || singleGirl.yearsOfLearning == "1-3:3-5" ||
                singleGirl.yearsOfLearning == "1-3:3-5:5" ||
            singleGirl.yearsOfLearning == "1-3:3-5:5:5-7" ||
            singleGirl.yearsOfLearning == " 1-3:3-5:5:5-7:7+"
        }
    
        arrThreeToFiveSingleGirls = arrGirlsList.filter { singleGirl in
            singleGirl.yearsOfLearning == "3-5" ||
           singleGirl.yearsOfLearning == "1-3:3-5" ||
                singleGirl.yearsOfLearning == "1-3:3-5:5" ||
                singleGirl.yearsOfLearning == "3-5:5" ||
            singleGirl.yearsOfLearning == "1-3:3-5:5:5-7" ||
            singleGirl.yearsOfLearning == "1-3:3-5:5:5-7:7+" ||
                singleGirl.yearsOfLearning == "3-5:5:5-7" ||
            singleGirl.yearsOfLearning == "3-5:5:5-7:7+"
        }
    
        arrFiveYearsSingleGirls = self.arrGirlsList.filter { (singleGirl) -> Bool in
            return singleGirl.yearsOfLearning == "5" ||
                singleGirl.yearsOfLearning == "5:5-7" ||
                singleGirl.yearsOfLearning == "1-3:3-5:5:5-7:7+" ||
                singleGirl.yearsOfLearning == "3-5:5:5-7:7+" ||
                singleGirl.yearsOfLearning == "1-3:3-5:5:5-7" ||
                singleGirl.yearsOfLearning == "1-3:3-5:5" ||
                singleGirl.yearsOfLearning == "3-5:5" ||
                singleGirl.yearsOfLearning == "3-5:5:5-7" ||
                singleGirl.yearsOfLearning == "5:5-7:7+"
        }
        
        fiveToSevenSingleGirls = self.arrGirlsList.filter { singleGirl in
            singleGirl.yearsOfLearning == "5-7" ||
            singleGirl.yearsOfLearning == "3-5:5:5-7:7" ||
            singleGirl.yearsOfLearning == "1-3:3-5:5:5-7" ||
            singleGirl.yearsOfLearning == "3-5:5:5-7" ||
            singleGirl.yearsOfLearning == "3-5:5:5-7:7+" ||
            singleGirl.yearsOfLearning == "5:5-7" ||
            singleGirl.yearsOfLearning == "5-7:7" ||
            singleGirl.yearsOfLearning == "5-7:7+"
        }
        
        sevenPlusSingleGirls = self.arrGirlsList.filter { singleGirl in
            singleGirl.yearsOfLearning == "7+" ||
            singleGirl.yearsOfLearning == "5:5-7:7+" ||
            singleGirl.yearsOfLearning == "5-7:7+" ||
            singleGirl.yearsOfLearning == "3:3-5:5:5-7:7+" ||
            singleGirl.yearsOfLearning == "3-5:5:5-7:7+"
            
        }
        //      aryFirstSegmentFilter = [fiveToSevenSingleGirls,sevenPlusSingleGirls]
        self.segmentCntrlTapped(segmentCntrl!)
        
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
        nameLabel.text =  selectedNasiBoy.boyFirstName + " " + selectedNasiBoy.boyLastName
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
    
    

    func setUpSegmentControlApperance() {
        segmentCntrl.selectedSegmentTintColor = Constant.AppColor.colorAppTheme
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                           NSAttributedString.Key.font: Constant.AppFontHelper.defaultSemiboldFontWithSize(size: 16)]
        segmentCntrl.setTitleTextAttributes(titleTextAttributesSelected, for:.selected)
        
        let titleTextAttributesDefault = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                          NSAttributedString.Key.font: Constant.AppFontHelper.defaultRegularFontWithSize(size: 16)]
        segmentCntrl.setTitleTextAttributes(titleTextAttributesDefault, for:.normal)
        
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
    }
    
    @IBAction func segmentCntrlTapped(_ sender: UISegmentedControl) {
        //if sender.selectedSegmentIndex == 0 {
            //arrFilterList = arrOneToFiveSingleGirls
          
        //} else if sender.selectedSegmentIndex == 1 {
            //arrFilterList = arrFiveYearsSingleGirls
       // } else {
            //arrFilterList = arrFiveToSevenSingleGirls
       // }
        self.tableView.reloadData()
    //}
    }
    
    
    // MARK: -Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentCntrl.selectedSegmentIndex == 0 || segmentCntrl.selectedSegmentIndex == 2 {
         return 2
        } else  {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segmentCntrl.selectedSegmentIndex == 0 {
            if section == 0 {
                return "1 - 3 Years of Learning"
            } else {
                return "3 - 5 Years of Learning"
            }
        } else if segmentCntrl.selectedSegmentIndex == 1 {
            return "5  Years of Learning" // Not Used
        } else {
            if section == 0 {
                return "5 - 7 Years of Learning"
            } else {
                return "7+ Years Of Learning"
            }
        }
    }
    
    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentCntrl.selectedSegmentIndex == 0 {
         if section == 0 {
            arrayForSection = arrOnetoThreeSingleGirls
             
            } else {
                arrayForSection = arrThreeToFiveSingleGirls
            
            }
        }
        if segmentCntrl.selectedSegmentIndex == 1 {
            arrayForSection = arrFiveYearsSingleGirls
        }
        
        if segmentCntrl.selectedSegmentIndex == 2 {
            if section == 0 {
              arrayForSection =  fiveToSevenSingleGirls
        
            } else {
                arrayForSection = sevenPlusSingleGirls
            }
        }
        return arrayForSection.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: singleCellIdentifier, for: indexPath) as! SingleTableViewCell
        
        if segmentCntrl.selectedSegmentIndex == 0 {
            if indexPath.section == 0 {
                arrFilterList = arrOnetoThreeSingleGirls
            } else {
                arrFilterList = arrThreeToFiveSingleGirls
         }
        }
         
         else if segmentCntrl.selectedSegmentIndex == 1 {
            arrFilterList = arrFiveYearsSingleGirls
                
         }
        
        if segmentCntrl.selectedSegmentIndex == 2 {
        if indexPath.section == 0 {
            arrFilterList = fiveToSevenSingleGirls
        } else {
            arrFilterList = sevenPlusSingleGirls
        }
    }
        
        var model: NasiGirl!
        model = arrFilterList[indexPath.row]
        
        cell.nameLabel?.text =  "\(model.nameSheIsCalledOrKnownBy )" + " "  + "\(model.lastNameOfGirl )" //top 1 name
        
        let heightInFt = model.heightInFeet 
        let heightInInches = model.heightInInches 
        
        let height = "\(heightInFt)\'" + "\(heightInInches)\""
        
        cell.ageHeightLabel.text = "\(model.age)" + "-" + height // 2nd Age - Height
        
        cell.cityLabel.text = "\(model.cityOfResidence )"  // 3rd Label - City
        cell.categoryLabel.textColor = .lightGray
        cell.categoryLabel.text = "\(model.category ) - " + (model.yearsOfLearning ) // 4th Label - Categories
        cell.SeminaryLabel.text = model.seminaryName  //5th Label - Seminary
        cell.parnassahPlanLabel.text = "\(model.plan )"  // 6th Label - Plan
        
        print("the value of last name is \(model.lastNameOfGirl)")
        print("the value of image download string is \(model.imageDownloadURLString)")
        
        
        
        if model.imageDownloadURLString == "N/A"  {
            
        } else {
        cell.profileImageView.loadImageFromUrl(strUrl: model.imageDownloadURLString, imgPlaceHolder:"")
        }
           
        
        
        /*
         if let imgUrl = model.imageDownloadURLString{
         let url = URL(string: imgUrl)
         cell.profileImageView.kf.indicatorType = .activity
         cell.profileImageView.kf.setImage(with: url)
         }
         */
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
   
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
      // 1. segue id
      if segue.identifier == "ShowSingleDetail" {
    
      // 2. segue destination as
      let controller = segue.destination as! ShadchanListDetailViewController
          
      // 3. get index path
      if let indexPath = tableView.indexPath(for: sender
                           as! UITableViewCell) {
      //4. index into array to get current girl
      let currentGirl = arrFilterList[indexPath.row]

      //5. set selectedNasiGirl using current Girl
      controller.selectedNasiGirl = currentGirl
        controller.selectedNasiBoy = selectedNasiBoy
            
      }
        }
    }
}

// MARK: - SEARCHBAR DELEGATE(S)
extension FullTimeYeshivaViewController:UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
       // self.displayFilteredEmotionsInTable()

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        if searchBar.text?.count == 0 {
            self.displayFilteredEmotionsInTable()

        }

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.displayFilteredEmotionsInTable()

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
        self.displayFilteredEmotionsInTable()
 
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchFinalText = searchText.uppercased()
        
        if segmentCntrl.selectedSegmentIndex == 0 {
            Analytics.logEvent("fullTimeYeshiva_screen_segmentControl_act", parameters: [
                "item_name": "1-5 Years of Learning",
            ])
            arrTempFilterList = arrOnetoThreeSingleGirls
            
            /*
             if searchFinalText.count != 0 {
             let listFirstSection = self.arrOnetoThreeSingleGirls.filter { (girlList) -> Bool in
             return girlList.lastNameOfGirl?.uppercased() == searchFinalText
             }
             
             arrFilterOnetoThreeSingleGirls = listFirstSection
             
             let listSecondSection = self.arrThreeToFiveSingleGirls.filter { (girlList) -> Bool in
             return girlList.lastNameOfGirl?.uppercased() == searchFinalText
             }
             
             arrFilterThreeToFiveSingleGirls = listFirstSection
             
             self.tableView.reloadData()
             }*/
        } else if segmentCntrl.selectedSegmentIndex == 1 {
            Analytics.logEvent("fullTimeYeshiva_screen_segmentControl_act", parameters: [
                "item_name": "5 Years of Learning",
            ])
            arrTempFilterList = arrFiveYearsSingleGirls
        } else {
            
            /*
            Analytics.logEvent("fullTimeYeshiva_screen_segmentControl_act", parameters: [
                "item_name": "5+ Years Of Learning",
            ])
 
            */
 
            arrTempFilterList = arrFiveToSevenSingleGirls
        }
        
        if searchFinalText.count != 0 {
            arrFilterList.removeAll()
            if arrTempFilterList.count != 0 {
                for a in 0...arrTempFilterList.count-1{
                    if ((arrTempFilterList[a].lastNameOfGirl.uppercased()).contains(searchFinalText)){
                        arrFilterList.append(arrTempFilterList[a])
                    }
                }
                self.displayFilteredEmotionsInTable()
            } else {
                arrFilterList.removeAll()
                arrFilterList = arrTempFilterList
                self.displayFilteredEmotionsInTable()
            }
        } else {
            arrFilterList.removeAll()
            arrFilterList = arrTempFilterList
            self.displayFilteredEmotionsInTable()
        }
    }
    
    func displayFilteredEmotionsInTable () {
        if arrFilterList.count > 0 {
        } else {
            print("there is no data")
        }
        self.tableView.reloadData()
        
    }
}
