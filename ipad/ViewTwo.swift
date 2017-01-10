//
//  viewtwo.swift
//  ipad
//
//  Created by Macbook Pro on 28/10/2016.
//  Copyright © 2016 SuperSonicDesign.com. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Firebase
import GoogleSignIn

class ViewTwo: UIViewController{
    
    //private let kKeychainItemName = "Gmail API"
    //private let kClientID = "417609359642-9jnhdvsrkg8i78kcjdj9dc6n6osdckq1.apps.googleusercontent.com"
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    
    //private let scopes = [kGTLRAuthScopeGmailMailGoogleCom]
    //private let service = GTLRGmailService()
    
    @IBOutlet weak var logOut: UIButton!
    @IBOutlet weak var yourUsername: UILabel!
    @IBOutlet weak var yourPass: UILabel!
    
    var threads: [AnyObject]!
    
    var zuser: String!
    var accesstok: String!
    var tokid: String!
    var zcid: String!
    var zpic: URL!
    var zemail : String!
    
    // When the view loads, create necessary subviews
    // and initialize the Gmail API service
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*let alert = UIAlertController(title: "Welcome " + zuser , message: "Your are logged in", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)*/
        
    }
    
    
    
   
    
 /*  func userInputs(messages2: [AnyObject]){
         if messages2 != nil {
              print(messages2)
          }
    
    }*/
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeViewSegue" {
         let vc1: ViewController = segue.destination as! ViewController
          vc1.inputs = self
        }
    }*/
        
    
   /* override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        GTMOAuth2ViewControllerTouch.removeAuthFromKeychain(forName: kKeychainItemName)
    }*/

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    
        
    
       
}
