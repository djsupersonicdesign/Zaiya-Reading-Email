//
//  TableController.swift
//  ipad
//
//  Created by Macbook Pro on 03/11/2016.
//  Copyright © 2016 SuperSonicDesign.com. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class ViewThree: UIViewController, AVSpeechSynthesizerDelegate {

    @IBOutlet weak var BodyMsg: UITextView!
    
    @IBOutlet weak var ins: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: characterRange)
        self.BodyMsg.attributedText = mutableAttributedString
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.BodyMsg.attributedText = NSAttributedString(string: utterance.speechString)
    }
    
    @IBAction func lnk(_ sender: Any) {
        open(scheme: "http://www.zaiyany.com/GoogleClientApi/instruction.php")
    }
    
    
    @IBAction func Spk(_ sender: Any) {
        let string = self.BodyMsg.text!
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.delegate = self
        synthesizer.speak(utterance)
    }
    
    // When the view appears, ensure that the Gmail API service is authorized
    // and perform API calls
    /*override func viewDidAppear(_ animated: Bool) {
        if let authorizer = service.authorizer,
            let canAuth = authorizer.canAuthorize , canAuth {
            fetchLabels()
        } else {
            present(
                createAuthController(),
                animated: true,
                completion: nil
            )
        }
    }*/
    
    // Construct a query and get a list of upcoming labels from the gmail API
    /*func fetchLabels() {
        
    
        let query = GTLRGmailQuery_UsersLabelsList.query(withUserId: "me")
        service.executeQuery(query,
                             delegate: self,
                             didFinish: Selector(("displayResultWithTicket:finishedWithObject:error:"))
                             //didFinish: "displayResultWithTicket:finishedWithObject:error:"
        )
    }*/
    
    // Display the labels in the UITextView
    /*func displayResultWithTicket(ticket : GTLRServiceTicket,
                                 finishedWithObject labelsResponse : GTLRGmail_ListLabelsResponse,
                                 error : NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        var labelString = ""
        
        if (labelsResponse.labels?.count)! > 0 {
            labelString += "Labels:\n"
            for label in labelsResponse.labels! {
                labelString += "\(label.name!)\n"
            }
        } else {
            labelString = "No labels found."
        }
        
        
    }
    
    
    // Creates the auth controller for authorizing access to Gmail API
    private func createAuthController() -> GTMOAuth2ViewControllerTouch {
        let scopeString = scopes.joined(separator: " ")
        return GTMOAuth2ViewControllerTouch(
            scope: scopeString,
            clientID: kClientID,
            clientSecret: nil,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: Selector(("viewController:finishedWithAuth:error:"))
            //finishedSelector: "viewController:finishedWithAuth:error:"
        )
    }
    
    // Handle completion of the authorization process, and update the Gmail API
    // with the new credentials.
    func viewController(vc : UIViewController,
                        finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
        
        if let error = error {
            service.authorizer = nil
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            return
        }
        
        service.authorizer = authResult
        dismiss(animated: true, completion: nil)
    }
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
  */
   
}
