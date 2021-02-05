//
//  MainResumeVC.swift
//  NasiShadchanHelper
//
//  Created by apple on 16/11/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import PDFKit
import Firebase
import MessageUI

class ResumeViewController: UITableViewController {
    
   
    var selectedNasiGirl: NasiGirl!
    var selectedNasiBoy: NasiBoy!
    
    // Section 1
    @IBOutlet weak var imgVwUserDP: UIImageView!
    @IBOutlet weak var btnShareResumeOnly: UIButton!
    @IBOutlet weak var btnShareResumeAndPhoto: UIButton!
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var lblNoResume: UILabel!
    
    
    @IBOutlet weak var waitingForDataLabel: UILabel!
    
    // set up url session for download
    // so we get delegate call backs
    lazy var downloadsSession: URLSession = {
      let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration,
                             delegate: self,
                             delegateQueue: nil)
      }()
    
    
    var localURL: URL!
    var localImageURL: URL!

    var ref: DatabaseReference!
    
    let matchesRef = Database.database().reference(withPath: "nasiMatches")
    
    var sentSegmentChildArr = [[String : String]]()
    
    // function get sent resume list
    // sets this flag
    var isAlreadyInSent:Bool = false
    var isAddedInResearch:Bool = false
    
    var childAutoIDKeyInResearchList : String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        print("the selectedNasi boy is \(selectedNasiBoy.boyLastName)")
        
        
        
        print("the selectedGirl is\(selectedNasiGirl.firstNameOfGirl)")
        
        
        
        
        
        
        checkSentList()
        downloadDocument()
        downloadProfileImage()
        
        btnShareResumeOnly.addRoundedViewCorners(width: 4, colorBorder: Constant.AppColor.colorAppTheme)
    
        
        btnShareResumeAndPhoto.addRoundedViewCorners(width: 4, colorBorder: Constant.AppColor.colorAppTheme)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavBarWithUser()
    }
    
    
    @IBAction func saveToReddsList(_ sender: Any) {
        
        print("save to redds list invoked")
        saveToShadchanMatchIdeasAndUpdateHud()
    
    }
    
    func saveToShadchanMatchIdeasAndUpdateHud() {
           ref = Database.database().reference()
              guard let shadchanID = UserInfo.curentUser?.id else {
                  return
              }
            
              
              
           let newMatch = NasiMatch(boyID: selectedNasiBoy.key, boyName: selectedNasiBoy.boyFirstName + selectedNasiBoy.boyLastName, girlID: selectedNasiGirl.key, girlName: selectedNasiGirl.nameSheIsCalledOrKnownBy + selectedNasiGirl.lastNameOfGirl, shadchanID: shadchanID, shadchanName: "")
              
              let newMatchDict = newMatch.toAnyObject()
              
              
              //let imageName = UUID().uuidString
              //let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
              //let usersRef = Database.database().reference(withPath: "online")
             // let matchesRef = Database.database().reference(withPath: "nasiMatches")
              //UUID().uuidString
              let boyAndGirlNames = selectedNasiBoy.boyFirstName + selectedNasiBoy.boyLastName + selectedNasiGirl.nameSheIsCalledOrKnownBy + selectedNasiGirl.lastNameOfGirl
              
              ref.child("nasiShidduchRedds").child(boyAndGirlNames).setValue(newMatchDict){
                  (error, ref) in
                        
                  if error != nil {
                      //print(error?.localizedDescription ?? “”)
                            
                   } else {
                   //hudView.text = "Save Successful!"
                            
                   }
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
               nameLabel.text =  "Moshe Pogrow"   //user.name
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
    
    
  
    
  
    
    // check the sent list for this user and if there set the flat
    // alreadyInSent to true
    func checkSentList() {
           guard let myId = UserInfo.curentUser?.id else {
                return
            }
           
            // go to the current user's node in
            // sent list
           let  sentRef = Database.database().reference(withPath: "sentsegment")
            let userResearchRef = sentRef.child(myId)
           
            // observe all the children for this user
            userResearchRef.observe(.value, with: { snapshot in
               
              // iterate using the .children property
              for child in snapshot.children {
                                  
                let snapshot = child as? DataSnapshot
                let value = snapshot?.value as? [String: AnyObject]
                let girlID = value!["userId"] as! String
               
               // get the currentSingleID instance var and cast to string
               let currentGirlID = "\(self.selectedNasiGirl.key)"
               
               // check if there is a match
               if girlID == currentGirlID {
                   
                   // set the flag on current profile to true
                   self.isAlreadyInSent = true
                   
                   // invoke the function that takes the bool value
                   // and tells the user what list current girl is in
                  // self.setStatusLabelAndSaveToResearchButton()
                   }
                }
            })
         }
    
    // invoked by completion handler when send is success
    //
    func checkStatusBeforeSavingToSent() {
        
        let hudView = HudView.hud(inView: self.navigationController!.view, animated: true)
        //hudView.text = "Checking Profile Status"

         afterDelay(1.9) {
         hudView.hide()
         
         self.navigationController?.popToRootViewController(animated: true)
            
         }
        
        
       // if isAddedInResearch == false  && isAlreadyInSent == true {
            
       //      hudView.text = "Already In Sent List"
            
      //  } else if isAddedInResearch == false && isAlreadyInSent == false {
           
       //     hudView.text = "Adding To Sent List"
           // saveToSentShadchanMatchesAndUpdateHud(hudView: hudView)
            
       // } else if isAddedInResearch == true && isAlreadyInSent == false {
       //     print("we need  to delete from research list and add to sent list")
            
            
       //     hudView.text = "Moving From Research List To Sent List"
            
      //    checkResearchListAndStoreAutoIDKey()
            //removeFromResearchList()
            
            saveToSentShadchanMatchesAndUpdateHud(hudView: hudView)
        }
   // }
    
    
    private func setUpProfilePhoto() {
         //imgVwUserDP.loadImageUsingCacheWithUrlString(selectedNasiGirl.imageDownloadURLString)
        imgVwUserDP.loadImageFromUrl(strUrl: selectedNasiGirl.imageDownloadURLString, imgPlaceHolder: "")
        
       
    }
    
    func shareResumeAndPhoto() {
            
        if localURL != nil && localImageURL != nil {
        btnShareResumeOnly.isEnabled = true
        btnShareResumeAndPhoto.isEnabled = true
        
          
           // 3 sharing items
           // 1 Resume pdf as UIImage
           let documentAsImage = drawPDFfromURL(url: localURL)
        _ = documentAsImage?.jpegData(compressionQuality: 0.50)
           
           // 2 profile image
           let shareImageURL = localImageURL!
           let imageData = try! Data(contentsOf: shareImageURL)
           let imageToShare = UIImage(data: imageData)
           
           // 3 text string
        var textMessageString: String = ""
        
             textMessageString = "This is the resume of " +
                "\(selectedNasiGirl.nameSheIsCalledOrKnownBy) " +
            "\(selectedNasiGirl.lastNameOfGirl)"
        
        let activityVC =  UIActivityViewController(activityItems: [documentAsImage!,imageToShare!,textMessageString], applicationActivities: [])
            
            
            
                 
        if UIDevice.current.userInterfaceIdiom == .pad {
                                               
        activityVC.modalPresentationStyle = .popover
                                              
           // activityVC.popoverPresentationController?.barButtonItem = rightBarButton
        activityVC.popoverPresentationController?.sourceView = btnShareResumeAndPhoto
                                              
                         }
            
           
           activityVC.excludedActivityTypes = [
               UIActivity.ActivityType.postToWeibo,
               UIActivity.ActivityType.print,
               UIActivity.ActivityType.copyToPasteboard,
               UIActivity.ActivityType.assignToContact,
               UIActivity.ActivityType.saveToCameraRoll,
               UIActivity.ActivityType.addToReadingList,
               UIActivity.ActivityType.postToFlickr,
               UIActivity.ActivityType.postToVimeo,
               UIActivity.ActivityType.postToTencentWeibo,
               UIActivity.ActivityType.airDrop,
               UIActivity.ActivityType.openInIBooks,
               UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
               UIActivity.ActivityType(rawValue: "com.apple.reminders.sharingextension")
           ]
           
           //Completion handler
           activityVC.completionWithItemsHandler = {
               (activityType: UIActivity.ActivityType?, completed:
                      Bool, arrayReturnedItems: [Any]?, error: Error?) in
               print("********completion invoked handler***")
               print("the activity type was\(activityType.debugDescription)completed is \(completed) array returned items is \(arrayReturnedItems.debugDescription) and error is \(error.debugDescription)")
               
               if completed {
                   print("*****User completed activity****")
                
                self.checkStatusBeforeSavingToSent()
                //self.saveToShadchanMatchIdeasAndUpdateHud()
                
                   } else {
                   print("user cancelled the activityController")
                   }
                   if let shareError = error {
                       print("error while sharing: \(shareError.localizedDescription)")
                          }
                      }
             present(activityVC, animated: true, completion: nil)
        }
       }
    
    func shareResumeOnly() {
        
        //1. check that we have valid pdf url and image url
        if localURL != nil && localImageURL != nil {
            
        //2. enable both buttons that were disable during donwload
        btnShareResumeOnly.isEnabled = true
        btnShareResumeAndPhoto.isEnabled = true
    
       // 3. convert pdf at localURL to an image
       let documentAsImage = drawPDFfromURL(url: localURL)
        
        // 4. set up the message string
        let textMessageString = "This is the resume of " +
                    "\(selectedNasiGirl.nameSheIsCalledOrKnownBy) " +
                "\(selectedNasiGirl.lastNameOfGirl)"
            
        
        // 5. pass the two objects to the activity controller
        let activityVC = UIActivityViewController(activityItems: [textMessageString, documentAsImage!], applicationActivities: [])
            
            
        // if we are in iPad we need to adapt and present the
        // activity vc as a popover
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityVC.modalPresentationStyle = .popover
            activityVC.popoverPresentationController?.sourceView = btnShareResumeOnly
        }
        
        activityVC.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.copyToPasteboard,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.openInIBooks,
            UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
            UIActivity.ActivityType(rawValue: "com.apple.reminders.sharingextension")
        ]
        
        //Completion handler
        activityVC.completionWithItemsHandler = {
            (activityType: UIActivity.ActivityType?, completed:
                   Bool, arrayReturnedItems: [Any]?, error: Error?) in
            print("***completion invoked handler***")
            if completed {
                print("*****User completed activity")
                    
                self.checkStatusBeforeSavingToSent()
                //self.saveToShadchanMatchIdeasAndUpdateHud()
                
                } else {
                print("user cancelled the activityController")
                }
                if let shareError = error {
                    print("error while sharing: \(shareError.localizedDescription)")
                       }
                   }
        
        present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    /*
    func shareInPopover()
           {
               NSString *forwardedString = [[NSString alloc] initWithFormat:@"Check out this leaflet\n\n %@ \n\nself.theURLToShare];
                   
               UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:forwardedString, nil] applicationActivities:nil];

               if (IDIOM == IPAD)
               {
                   NSLog(@"iPad");
                   activityViewController.popoverPresentationController.sourceView = self.view;
           //        activityViewController.popoverPresentationController.sourceRect = self.frame;

                  _popover = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
                  _popover.delegate = self;
                  [_popover presentPopoverFromBarButtonItem:_shareBarButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
               }
               else
               {
                   NSLog(@"iPhone");
                   [self presentViewController:activityViewController
                                     animated:YES
                                   completion:nil];
               }
 */
    
    func drawPDFfromURL(url: URL) -> UIImage? {
           guard let document = CGPDFDocument(url as CFURL) else { return nil }
           guard let page = document.page(at: 1) else { return nil }

           let pageRect = page.getBoxRect(.mediaBox)
           let renderer = UIGraphicsImageRenderer(size: pageRect.size)
           let img = renderer.image { ctx in
               UIColor.white.set()
               ctx.fill(pageRect)

               ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
               ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

               ctx.cgContext.drawPDFPage(page)
           }

           return img
       }
   
    /// Get local file path: download task stores tune here; AV player plays it.
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

}
extension ResumeViewController: URLSessionDownloadDelegate {
  
    func downloadDocument() {
        view.showLoadingIndicator()
     
        let documentURL = URL(string: selectedNasiGirl.documentDownloadURLString )
        
      let downloadTask = downloadsSession.downloadTask(with: documentURL!)
        
      downloadTask.resume()
    
    }
    
    func downloadProfileImage() {

        let profileImageURL = URL(string: selectedNasiGirl.imageDownloadURLString )
        
        
      let downloadTask = downloadsSession.downloadTask(with: profileImageURL!)
     
      downloadTask.resume()
     
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                  didFinishDownloadingTo location: URL) {
      
      let originalURL = downloadTask.originalRequest!.url!
      let downloadType = downloadTask.originalRequest!.url!.pathExtension
    
      print("the download type is \(downloadType)")
      
        if downloadType == "pdf" {
         localURL = copyFromTempURLToLocalURL(remoteURL: originalURL, location: location)
          
      } else {
        localImageURL = copyFromTempURLToLocalURL(remoteURL: originalURL, location: location)
    }
    
     
        if localURL != nil && localImageURL != nil {
    DispatchQueue.main.async {
        self.waitingForDataLabel.isHidden = true
        self.setUpPDFView()
        self.setupProfileImageFromLocalURL()
            }
     }
    
   }
    
    func setUpPDFView() {
           
           var document: PDFDocument!
           
           if  let pathURL = localURL {
           document = PDFDocument(url: pathURL)
           }
           
           if let document = document {
               pdfView.displayMode = .singlePageContinuous
               pdfView.autoScales = true
               pdfView.displayDirection = .vertical
               pdfView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
               pdfView.document = document
           }
          self.view.hideLoadingIndicator()
       }
    
    func setupProfileImageFromLocalURL() {
         
           if localImageURL != nil {
           
           //let localImageURL = URL(string: localURLAsString)
           let imageData = try! Data(contentsOf: localImageURL!)
           
           let imageFromURl = UIImage(data: imageData)
           imgVwUserDP.image = imageFromURl
           }
       }
    
    
    func copyFromTempURLToLocalURL(remoteURL: URL, location: URL) -> URL {
      
        // 1 get the original url we used to download
        // the document from fire base storage
       //let sourceURL = URL(string: selectedSingle.documentDownloadURLString ?? "")!
        
        let sourceURL = remoteURL
       // 2 create a file path pointing to the local
       // document directory
       let destinationURL = localFilePath(for: sourceURL)
       print(destinationURL)
       
       // 3 get the default file manager
       let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)

       do {
         try fileManager.copyItem(at: location, to: destinationURL)
         //download?.track.downloaded = true
       } catch let error {
         print("Could not copy file to disk: \(error.localizedDescription)")
       }

        return destinationURL
        
    }
    
    func localFilePath(for url: URL) -> URL {
         return documentsPath.appendingPathComponent(url.lastPathComponent)
       }


}



// ----------------------------------
// MARK: - BUTTION ACTION(S) -
//
extension ResumeViewController {
    @IBAction func btnShareResumeTapped(_ sender: Any) {
        self.shareResumeOnly()
        
    }
    
   
    
    @IBAction func btnShareResumePhotoTapped(_ sender: Any) {
        self.shareResumeAndPhoto()
        
    }
    
    
    
    
    
    func saveToSentShadchanMatchesAndUpdateHud(hudView: HudView) {
        
        //if isAlreadyInSent {
       //     return
       // }
        ref = Database.database().reference()
        
        guard let shadchanID = UserInfo.curentUser?.id else {
            return
        }
        let newMatch = NasiMatch(boyID: selectedNasiBoy.key, boyName: selectedNasiBoy.boyFirstName + selectedNasiBoy.boyLastName, girlID: selectedNasiGirl.key, girlName: selectedNasiGirl.nameSheIsCalledOrKnownBy + selectedNasiGirl.lastNameOfGirl, shadchanID: shadchanID, shadchanName: "")
        
        let newMatchDict = newMatch.toAnyObject()
        
        
        //let imageName = UUID().uuidString
        //let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
        //let usersRef = Database.database().reference(withPath: "online")
       // let matchesRef = Database.database().reference(withPath: "nasiMatches")
        //UUID().uuidString
        let boyAndGirlNames = selectedNasiBoy.boyFirstName + selectedNasiBoy.boyLastName + selectedNasiGirl.nameSheIsCalledOrKnownBy + selectedNasiGirl.lastNameOfGirl
        
        
        ref.child("sentNasiMatches").child(shadchanID).child(boyAndGirlNames).setValue(newMatchDict){
            (error, ref) in
                  
            if error != nil {
                //print(error?.localizedDescription ?? “”)
                      
             } else {
             hudView.text = "Save Successful!"
                      
             }
            }
          }


    /*
        ref.child("sentsegment").child(myId).childByAutoId().setValue(dict) {
            (error, ref) in
            
            if error != nil {
                //print(error?.localizedDescription ?? “”)
                
            } else {
                hudView.text = "Save Successful!"
                
            }
        }
    }
    
 */
    
    func checkResearchListAndStoreAutoIDKey() {
        
        guard let myId = UserInfo.curentUser?.id else {
            return
        }
        
        let  researchRef = Database.database().reference(withPath: "research")
        let userResearchRef = researchRef.child(myId)
            userResearchRef.observe(.value, with: { snapshot in
                
             for child in snapshot.children {
                    
                let snapshot = child as? DataSnapshot
                let value = snapshot?.value as? [String: AnyObject]
                
                
                
                // get the id from the current snapshot child
                // using the key userId
                // and get the ID of the current girl in
                // the detail view
                let girlID = value!["userId"] as! String
                let currentGirlID = self.selectedNasiGirl.key
                
                print("the value of currentSingleId is \(currentGirlID) and girlId is \(girlID)")
                
                    if girlID == currentGirlID {
                        
                      // this snapshot has the autoIDKey of the
                      // profile in the research list specificly
                      self.childAutoIDKeyInResearchList = snapshot!.key
                        self.removeFromResearchList()
                        
                        //let refToRemoveFromResearch = snapshot?.ref
                       // refToRemoveFromResearch?.removeValue()
                      //self.setStatusLabelAndSaveToResearchButton()
                }
             }
          })
    }
    
    
    func removeFromResearchList() {
        
      guard let myId = UserInfo.curentUser?.id else {return}
          let researchRef = Database.database().reference(withPath: "research")
        
        let researchAutoIDKey = childAutoIDKeyInResearchList
        
        researchRef.child(myId).child(researchAutoIDKey!).removeValue {
             (error, dbRef) in
            
            if error != nil {
                
                print(error?.localizedDescription ?? "error")
                       
            } else {
                print("the dbRef isi \(dbRef.description())")
                
            }
        }
    }
}

extension ResumeViewController: MFMailComposeViewControllerDelegate {
    
     @IBAction func sendEmailWithJustResume(sender: UIButton) {
         if MFMailComposeViewController.canSendMail() {
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.setSubject("Update about ios tutorials")
            mailComposer.setMessageBody("What is the update about ios tutorials on youtube", isHTML: false)
                  
            mailComposer.setToRecipients(["rpogrow@gmail.com"])
            
            // get the resume as the attachment
            guard let filePath = Bundle.main.path(forResource: "SimplePDF", ofType: "pdf") else {return}
            
            let url = URL(fileURLWithPath: filePath)
                       
            do {
            let attachmentData = try Data(contentsOf: url)
            mailComposer.addAttachmentData(attachmentData, mimeType: "application/pdf", fileName: "SimplePDF")
                
                
                
            mailComposer.mailComposeDelegate = self
            self.present(mailComposer, animated: true
                               , completion: nil)
            } catch let error {
            print("We have encountered error \(error.localizedDescription)")
            }
            
        
            } else {
                   print("Email is not configured in settings app or we are not able to send an email")
               }
           }
             
                
    @IBAction func sendEmailWithPhotoAndResume(sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
        let mailComposer = MFMailComposeViewController()
        mailComposer.setSubject("Update about ios tutorials")
        mailComposer.setMessageBody("What is the update about ios tutorials on youtube", isHTML: false)
        mailComposer.setToRecipients(["rpogrow@gmail.com"])
            
        guard let filePath = Bundle.main.path(forResource: "SimplePDF", ofType: "pdf")
        else {
            return
        }
        let url = URL(fileURLWithPath: filePath)
                       
        do {
        let attachmentData = try Data(contentsOf: url)
        mailComposer.addAttachmentData(attachmentData, mimeType: "application/pdf", fileName: "SimplePDF")
        mailComposer.mailComposeDelegate = self
        self.present(mailComposer, animated: true, completion: nil)
            } catch let error {
            print("We have encountered error \(error.localizedDescription)")
        }
        mailComposer.mailComposeDelegate = self
                  
        self.present(mailComposer, animated: true
                           , completion: nil)
          } else {
            print("Email is not configured in settings app or we are not able to send an email")
            }
    }
    
   func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("User cancelled")
            break
            
        case .saved:
            print("Mail is saved by user")
            break
            
        case .sent:
           saveToShadchanMatchIdeasAndUpdateHud()
           print("save to redds list invoked")
            //break
            
        case .failed:
            print("Sending mail is failed")
            break
        default:
            break
        }
        
        controller.dismiss(animated: true)
    }
}

extension ResumeViewController: MFMessageComposeViewControllerDelegate{
    
    func sendTextWithResumeAndPhoto() {
        if !MFMessageComposeViewController.canSendText() {
        print("SMS services are not available")
        }
        
    let composeVC = MFMessageComposeViewController()
    composeVC.messageComposeDelegate = self
     
    // Configure the fields of the interface.
    composeVC.recipients = ["4085551212"]
    composeVC.body = "Hello from California!"
     
    // Present the view controller modally.
    self.present(composeVC, animated: true, completion: nil)
    }
    
    func sendTextWithJustResume() {
        if !MFMessageComposeViewController.canSendText() {
            print("SMS services are not available")
        }
    let composeVC = MFMessageComposeViewController()
    composeVC.messageComposeDelegate = self
     
    // Configure the fields of the interface.
    composeVC.recipients = ["4085551212"]
    composeVC.body = "Hello from California!"
     
    // Present the view controller modally.
    self.present(composeVC, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
        didFinishWith result: MessageComposeResult) {
    
     controller.dismiss(animated: true, completion: nil)}
    }
    

   
   
   
