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
    
    @IBOutlet weak var boysShidduchContactLabel: UILabel!
    
    
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
    
    //pdf
    var localResumeURL: URL!
    
    //jpg
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
        
        boysShidduchContactLabel.text =
        selectedNasiBoy.decisionMakerFirstName + " " +
        selectedNasiBoy.decisionMakerLastName + " - " +
        selectedNasiBoy.decisionMakerEmail + " - " +
        selectedNasiBoy.decisionMakerCell
        
        
        
        checkSentList()
        downloadDocument()
        downloadProfileImage()
        
        //btnShareResumeOnly.addRoundedViewCorners(width: 4, colorBorder: Constant.AppColor.colorAppTheme)
        //btnShareResumeAndPhoto.addRoundedViewCorners(width: 4, colorBorder: Constant.AppColor.colorAppTheme)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavBarWithUser()
    }

    @IBAction func sendTextWithJustResume(_ sender: Any) {
         sendTextJustResume(sender: sender as!  UIButton)
     
    }
    
    @IBAction func sendTextWithBothResumeAndPhoto(_ sender: Any) {
        sendTextBothResumeAndPhoto(sender: sender as! UIButton)
    }
    
    @IBAction func sendEmailWithJustResume(_ sender: Any) {
        
        sendEmailWithJustResume(sender: sender as! UIButton)
    }
    
    @IBAction func sendEmailWithBothResumAndPhoto(_ sender: Any) {
        
    sendEmailWithBothResumeAndProfileImage(sender: sender as! UIButton)
       
    }
    
    
    
    func saveNewProjectToAllNasiShidduchProjects() {
      ref = Database.database().reference()
      guard let shadchanID = UserInfo.curentUser?.id else { return }
            
      let newShidduchProject = NasiMatch(
        boyID: selectedNasiBoy.key,
        boyFirstName: selectedNasiBoy.boyFirstName,
        boyLastName:selectedNasiBoy.boyLastName,
        boyProfileImageURLPath: selectedNasiBoy.boyProfileImageURLString ,
        girlID: selectedNasiGirl.key,
        girlFirstName: selectedNasiGirl.firstNameOfGirl ,
        girlLastName: selectedNasiGirl.lastNameOfGirl,
        girlProfileImageURLPath: selectedNasiGirl.imageDownloadURLString,
        girlResumeURLPath: selectedNasiGirl.documentDownloadURLString,
        
        shadchanID: shadchanID,
        shadchanFirstName:"",
        shadchanLastName:"",
        lastActivity: "",
        projectStatus: "",
        nextTask: "Follow Up To Get First Date",
        projectResult: "Needs Follow Up",
        decisionMakerFirstName: selectedNasiBoy.decisionMakerFirstName,
        decisionMakerLastName:selectedNasiBoy.decisionMakerLastName ,
        decisionMakerEmail: selectedNasiBoy.decisionMakerEmail ,
        decisionMakerCell: selectedNasiBoy.decisionMakerCell)
 
              
      let newMatchDict = newShidduchProject.toAnyObject()
      let boyAndGirlNames = selectedNasiBoy.boyFirstName + selectedNasiBoy.boyLastName + "-" + selectedNasiGirl.nameSheIsCalledOrKnownBy + selectedNasiGirl.lastNameOfGirl
              
      ref.child("AllNasiShidduchProjects").child(boyAndGirlNames).setValue(newMatchDict){
                  (error, ref) in
                        
                  if error != nil {
                      //print(error?.localizedDescription ?? “”)
                            
                   } else {
                   //hudView.text = "Save Successful!"
                            
                   }
                  }
                }
  
    
    func setupNavBarWithUser() {
       
               
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
           
              let urlString = selectedNasiBoy.boyProfileImageURLString
               profileImageView.loadImageFromUrl(strUrl: urlString, imgPlaceHolder: "")
               
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
    
    private func setUpProfilePhoto() {
         //imgVwUserDP.loadImageUsingCacheWithUrlString(selectedNasiGirl.imageDownloadURLString)
        imgVwUserDP.loadImageFromUrl(strUrl: selectedNasiGirl.imageDownloadURLString, imgPlaceHolder: "")
        
       
    }
    
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
    
      print("the originalURL was \(originalURL) download type is \(downloadType)")
        
       
        
        if downloadType == "pdf" {
            
         // copy the pdf file from temp url to local url
         localResumeURL = copyFromTempURLToLocalURL(remoteURL: originalURL, location: location)
          
      } else { //download type is jpg for profile image
            
        // copyt the profile image file from temp to permanent
        localImageURL = copyFromTempURLToLocalURL(remoteURL: originalURL, location: location)
    }
    
        
     //if we have a valid local pdf file and local image file
    if localResumeURL != nil && localImageURL != nil {
            
    DispatchQueue.main.async {
        
        self.waitingForDataLabel.isHidden = true
        
        // takes local pdf file and sets up the pdf view with pdf doc
        self.setUpPDFView()
        
        //
        self.setupProfileImageFromLocalURL()
            }
     }
    
   }
    
    func setUpPDFView() {
      
      var document: PDFDocument!
        
        // use the local resume pdf file to
        // init a pdf document
        if  let localPDFURL = localResumeURL {
          document = PDFDocument(url: localPDFURL)
        }
           
       // if we have a non nil pdf document then
       // use it to set the doc property of pdf view
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
            
           // pass the local photo file to convert to Data
           let imageData = try! Data(contentsOf: localImageURL!)
           
           // use data object to init UIImage
           // use it to set image property
           let imageFromURl = UIImage(data: imageData)
           imgVwUserDP.image = imageFromURl
           }
       }
    
    
    func copyFromTempURLToLocalURL(remoteURL: URL, location: URL) -> URL {
      
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
    
   
    func sendEmailWithBothResumeAndProfileImage(sender: UIButton){
        if MFMailComposeViewController.canSendMail() {
                   
        let mailComposer = MFMailComposeViewController()
        mailComposer.setSubject("Resume of \(selectedNasiGirl.nameSheIsCalledOrKnownBy)" + " " + "\(selectedNasiGirl.lastNameOfGirl)")
                              
        mailComposer.setMessageBody("xxxxxxx", isHTML: false)
                                    
        let decisionMakerEmail = selectedNasiBoy.decisionMakerEmail
        mailComposer.setToRecipients([decisionMakerEmail])
                   
        let attachmentData = try! Data(contentsOf: localResumeURL)
        mailComposer.addAttachmentData(attachmentData, mimeType: "application/pdf", fileName: "girlsResume")
                   
        let attachmentData2 = try! Data(contentsOf: localImageURL)
                   mailComposer.addAttachmentData(attachmentData2, mimeType: "image/jpg", fileName: "girlsProfilePhoto")
                   
                   
                       
        mailComposer.mailComposeDelegate = self
        self.present(mailComposer, animated: true
                                                   , completion: nil)
        }
    }
        
    func sendEmailWithJustResume(sender: UIButton) {
         if MFMailComposeViewController.canSendMail() {
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.setSubject("Resume of \(selectedNasiGirl.nameSheIsCalledOrKnownBy)" + " " + "\(selectedNasiGirl.lastNameOfGirl)")
            
            mailComposer.setMessageBody("xxxxxxx", isHTML: false)
                  
            let decisionMakerEmail = selectedNasiBoy.decisionMakerEmail
            mailComposer.setToRecipients([decisionMakerEmail])
            
            let attachmentData = try! Data(contentsOf: localResumeURL)
            mailComposer.addAttachmentData(attachmentData, mimeType: "application/pdf", fileName: "girlsResume")
            mailComposer.mailComposeDelegate = self
            self.present(mailComposer, animated: true
                                            , completion: nil)
            }
        
    }
            
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("User cancelled")
        case .saved:
            print("Mail is saved by user")
            
        case .sent:
           saveNewProjectToAllNasiShidduchProjects()
            print("***************************mail is sent")
        //break
            
        case .failed:
            print("Sending mail is failed")
      
        default:
            print("going to default")
        }
        
        controller.dismiss(animated: true)
    }
}

extension ResumeViewController: MFMessageComposeViewControllerDelegate{
    
    func sendTextJustResume(sender: UIButton) {
        if !MFMessageComposeViewController.canSendText() {
        print("SMS services are not available")
        }
        
    let composeVC = MFMessageComposeViewController()
        
        
    let documentAsImage = drawPDFfromURL(url: localResumeURL)
    let girlResumeImageAsData = documentAsImage?.jpegData(compressionQuality: 0.3)
    composeVC.addAttachmentData(girlResumeImageAsData!, typeIdentifier: "public.data", filename: "girlsResume.jpeg")
    composeVC.messageComposeDelegate = self
     
    // Configure the fields of the interface.
    let decisionMakerCell = selectedNasiBoy.decisionMakerCell
    composeVC.recipients = [decisionMakerCell]
    composeVC.body = "Resume of \(selectedNasiGirl.firstNameOfGirl)" + " " + "\(selectedNasiGirl.lastNameOfGirl)"
     
    // Present the view controller modally.
    self.present(composeVC, animated: true, completion: nil)
    }
    
    
    func sendTextBothResumeAndPhoto(sender: UIButton) {
        if !MFMessageComposeViewController.canSendText() {
            print("SMS services are not available")
        }
    let composeVC = MFMessageComposeViewController()
        
    let documentAsImage = drawPDFfromURL(url: localResumeURL)
    let girlResumeImageAsData = documentAsImage?.jpegData(compressionQuality: 0.3)
    composeVC.addAttachmentData(girlResumeImageAsData!, typeIdentifier: "public.data", filename: "girlsResume.jpeg")
        
        
    let girlImagePath = localImageURL.path
    let girlImage = UIImage(contentsOfFile: girlImagePath)
    let imageAsData = girlImage?.jpegData(compressionQuality: 0.3)
        
    composeVC.addAttachmentData(imageAsData!, typeIdentifier: "public.data", filename: "girlsProfilePhoto.jpeg")
        
    composeVC.messageComposeDelegate = self
     
   
    // Configure the fields of the interface.
    let decisionMakerEmail = selectedNasiBoy.decisionMakerEmail
    composeVC.recipients = [decisionMakerEmail]
     composeVC.body = "Resume of \(selectedNasiGirl.firstNameOfGirl)" + " " + "\(selectedNasiGirl.lastNameOfGirl)"
        
    // Present the view controller modally.
    self.present(composeVC, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
        didFinishWith result: MessageComposeResult) {
        
        switch result {
               case .cancelled:
                   print("User cancelled")
               
                   
               case .sent:
            saveNewProjectToAllNasiShidduchProjects()
                   print("***************************mail is sent")
               //break
                   
               case .failed:
                   print("Sending mail is failed")
             
               default:
                   print("going to default")
               }
               
               controller.dismiss(animated: true)
           }
}

   
   
   
