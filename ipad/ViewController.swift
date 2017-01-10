//
//  ViewController.swift
//  ipad
//
//  Created by Macbook Pro on 24/10/2016.
//  Copyright © 2016 SuperSonicDesign.com. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import Firebase
import GoogleSignIn
import GoogleAPIClientForREST
import GTMOAuth2
import Alamofire
import SwiftyJSON
import SwiftyBase64
import CoreData

/*protocol DataSentDelegate {
    func userDidEnterData(data: String)
}*/

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    var databaseRef: FIRDatabaseReference!
    
    //var delegate: DataSentDelegate? = nil
    
    private let kKeychainItemName = "Gmail API"
    private let kClientID = "CLIENT ID"
    private let service = GTLRGmailService()
    private let query = GTLRGmailQuery_UsersMessagesList.query(withUserId: "me")
    
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    
    let output = UITextView()
    
    @IBOutlet weak var ProfilePhoto: UIImageView!
    
    @IBOutlet weak var ProfileName: UILabel!
    
    @IBOutlet weak var Swicth: UISwitch!
    @IBOutlet weak var autoLbl: UILabel!
    @IBOutlet weak var NewButton: UIButton!
    @IBOutlet weak var InboxButton: UIButton!
    @IBOutlet weak var SpamButton: UIButton!
    @IBOutlet weak var StarredButton: UIButton!
    @IBOutlet weak var ImportantButton: UIButton!

    var overlay : UIView! // This should be a class variable
    
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var tableView: UITableView!
    
    var petitions = [[String: String]]()
    var msubject = [[String: String]]()
    var mfrom = [[String: String]]()
    
    var count = 0
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var Loginemail: UITextField!
    @IBOutlet weak var passwordF: UITextField!
    
    var tblReload = Timer()
    
    var jsonAr = [[String: String]]()
    var obj2: [AnyObject]!
   
    var requestToken: String?
    
    let myWebView:UIWebView = UIWebView(frame: CGRect(x:0, y:20, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
    
    var refreshControl: UIRefreshControl!
    
    var counter = 0
    var timer = Timer()
    var timerSpeak = Timer()
    
    var myactivityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    let Loadlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    
    let speaker = Speaker()
    
    let date = NSDate()
    
    @IBOutlet weak var WebView: UIWebView!
    
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnMenuButton.isEnabled = false
        
        let electronicArmoryURL = URL(string: "http://zaiyany.com")
        let electronicArmoryURLRequest = URLRequest(url: electronicArmoryURL!)
        WebView.loadRequest(electronicArmoryURLRequest)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().scopes.append("https://mail.google.com/")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/gmail.modify")
        
        self.SignMeIn()
        
        //refreshControl = UIRefreshControl()
        //refreshControl.backgroundColor = UIColor.redColor
        //refreshControl.tintColor = UIColor.gray
        //self.tableView.addSubview(refreshControl)
       // self.AcIndicator()
       // self.refreshControl.beginRefreshing()
       // let gesture2 = UISwipeGestureRecognizer.init(target: self, action: #selector (self.someAction (_:)))
       // gesture2.direction = UISwipeGestureRecognizerDirection.left
       // self.overlay.removeGestureRecognizer(gesture2)
        //tableView.delegate = self
        //tableView.dataSource = self
        
        //self.profilePicSetting()
        
        //leadingConstraint2.constant = -159
        //tblWidth.constant = self.view.frame.size.width //- 160
        //UIScrollView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded()})
        
        //menuView2.layer.shadowOpacity = 1
        //menuView2.layer.shadowRadius = 6
        
        /*let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.menuView2.addGestureRecognizer(swipeLeft)*/
        
        /*
        output.frame = view.bounds
        output.isEditable = false
        output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        output.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        view.addSubview(output);
        
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychain(
            forName: kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            service.authorizer = auth
        }*/
        
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            btnMenuButton.target = revealViewController()
            btnMenuButton.action = "revealToggle:"
            
            //            revealViewController().rightViewRevealWidth = 150
            //            extraButton.target = revealViewController()
            //            extraButton.action = "rightRevealToggle:"
            
            
            
            
        }
        
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector (self.tapOverlay (_:)))
        //self.overlay.addGestureRecognizer(tapGesture)
        
    }//VIEW DID ENDING
    
    //swipe gesture for profile menu

    
    func SignMeIn(){
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
          GIDSignIn.sharedInstance().signInSilently()
            let user = GIDSignIn.sharedInstance().currentUser
            
        } else {
           GIDSignIn.sharedInstance().signIn()
            let user = GIDSignIn.sharedInstance().currentUser
        }
    }
    
    func profilePicSetting(){
        //ProfilePhoto.layer.borderWidth = 1
        //ProfilePhoto.layer.masksToBounds = false
        //ProfilePhoto.layer.borderColor = UIColor.white.cgColor
        //ProfilePhoto.layer.cornerRadius = ProfilePhoto.frame.height/2
       // ProfilePhoto.clipsToBounds = true
        //ProfilePhoto.layer.shadowOpacity = 1
        //ProfilePhoto.layer.shadowRadius = 6
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var DestViewcontroller : MessageViewController = segue.destination as! MessageViewController
        DestViewcontroller.autoLbl.text = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
        
    }
    
    
    // When the view appears, ensure that the Google Calendar API service is authorized
    // and perform API calls
    override func viewDidAppear(_ animated: Bool) {
        /*if let authorizer = service.authorizer,
            let canAuth = authorizer.canAuthorize , canAuth {
            fetchEvents()
        } else {
            present(
                createAuthController(),
                animated: true,
                completion: nil
            )
        }*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }//DID RECEIVE ENDING
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication]  as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let user = GIDSignIn.sharedInstance().currentUser
        
       // let uname = user.profile.name
        
       // let uphoto = user.profile.imageURL(withDimension: 150)
        
        
        let authentication = user?.authentication
        let utoken = authentication?.accessToken
        
        /*if delegate != nil {
            if utoken != nil {
                delegate?.userDidEnterData(data: utoken!)
            }
        }*/
        
        //self.ProfileName.text = uname!
        //self.ProfilePhoto.setImageFromURl(stringImageUrl: (uphoto?.absoluteString)!)
        
        //let str = "Hi Welcome " + uname! //just some string here, this string exists, and it's in english
        
        //speaker.speak(string: str)
        
        
       // self.refreshControl.beginRefreshing()
        
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
                                                          accessToken: (authentication?.accessToken)!)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            print("User Signed Into Firebase")
            
            self.databaseRef = FIRDatabase.database().reference()
            self.databaseRef.child("user_profiles").child(user!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
                
                let snapshot = snapshot.value as? NSDictionary
                
                if(snapshot == nil)
                {
                    self.databaseRef.child("user_profiles").child(user!.uid).child("name").setValue(user?.displayName)
                    self.databaseRef.child("user_profiles").child(user!.uid).child("email").setValue(user?.email)
                }
                self.btnMenuButton.isEnabled = true
                //self.performSegue(withIdentifier: "HomeViewSegue", sender: self)
               
                //self.loginWithToken(mytoken: utoken!)
            })
        }
    }
    
    /* OLD SPEAK FUNCTOION
    func MakeSpeak(messageToSpeak: String){
        let utterance = AVSpeechUtterance(string: messageToSpeak)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        let lang = "en-US"
        
        utterance.voice = AVSpeechSynthesisVoice(language: lang)
        //synth.stopSpeaking(at: index)
        //synth.speak(utterance)
        
    }*/
    
    
    
    
    
    
    
    /*@IBAction func registerButton(_ sender: AnyObject) {
        FIRAuth.auth()?.createUser(withEmail: Loginemail.text!, password: passwordF.text!, completion: {
            (user, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                
                let alertController = UIAlertController(title: "Invalid Creadentials", message:
                    "username or password", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                self.Loginemail.text = ""
                self.passwordF.text = ""
                
            }else {
                self.Loginemail.text = ""
                self.passwordF.text = ""
                self.performSegue(withIdentifier: "HomeViewSegue", sender: nil)
                
            }
        })
    }*/
    
    
     @IBAction func loginButton(_ sender: AnyObject) {
     FIRAuth.auth()?.signIn(withEmail: Loginemail.text!, password: passwordF.text!, completion: {
     (user, error) in
     
     if error != nil {
     print(error!.localizedDescription)
     
     let alertController = UIAlertController(title: "Invalid Creadentials", message:
     "username or password", preferredStyle: UIAlertControllerStyle.alert)
     alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
     
     self.present(alertController, animated: true, completion: nil)
        
     }else {
        
            self.performSegue(withIdentifier: "HomeViewSegue", sender: nil)
            self.Loginemail.text = ""
            self.passwordF.text = ""
        
        }
     })
    }
    
    class Decoder {
        class func getDecodedString(encodedString: String)->String?{
            var base64EncodedString = Decoder().convertBase64URLtoBase64(encodedString: encodedString)
            if let decodedData = NSData(base64Encoded: base64EncodedString, options:NSData.Base64DecodingOptions(rawValue: 0)){
                return NSString(data: decodedData as Data, encoding: String.Encoding.utf8.rawValue) as? String
            }
            return nil
        }
        
        private func convertBase64URLtoBase64(encodedString: String)->String{
            var tempEncodedString = encodedString.replacingOccurrences(of: "-", with: "+", options: NSString.CompareOptions.literal, range: nil)
            tempEncodedString = tempEncodedString.replacingOccurrences(of: "_", with: "/", options: NSString.CompareOptions.literal, range: nil)
            var equalsToBeAdded = (encodedString as NSString).length % 4
            if(equalsToBeAdded > 0){
                for _ in 0..<equalsToBeAdded {
                    tempEncodedString += "="
                }
            }
            return tempEncodedString
        }
        
    }
    
    


    
    @IBAction func NewMessage(_ sender: Any) {
        //self.DisableButtons()
        self.petitions.removeAll()
        UIApplication.shared.beginIgnoringInteractionEvents()
 
        timer.invalidate()
        timerSpeak.invalidate()
        //self.AcIndicator()
        let mytoken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
        
        let gplus = "https://www.googleapis.com/gmail/v1/users/me/messages?labelIds=UNREAD&access_token=" + mytoken!
        
        let url = NSURL(string: gplus)
        let request = NSMutableURLRequest(url: url as! URL)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, downloadError in
            if let error = downloadError {
                
                print("Login Failed. (Login Step.)")
                
                print("Could not complete the request \(error)")
            } else {
                
                let Qmessages = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                
                let messages = Qmessages["messages"] as? [AnyObject]
                
                //let mid = messages?[0]["id"] as! String
                
                let jm = JSON(Qmessages)
                
                if jm["resultSizeEstimate"] == 0 {
                    self.Loadlabel.text = "Loading..."
                    self.speaker.speak(string: "You got no emails to load")
                    self.overlay!.removeFromSuperview()
                    self.myactivityIndicator.stopAnimating()
                    //self.petitions.removeAll()
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                    //self.EnableButtons()
                }else{
                    for message in messages! {
                        let mid = message["id"] as! String
                        //let tid = message["threadId"] as! String
                        //let objm = ["mid": mid, "tid": tid]
                        //self.petitions.append(objm)
                        //self.greet(person: objm as NSDictionary)
                        self.getHeaders(theid: mid,thetoken: mytoken!)
                        //self.petitions.removeAll()
                        self.tableView.reloadData()
                    }
                    //self.EnableButtons()
                    self.StopAc()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                
            }
        }
        task.resume()
        self.refreshControl.endRefreshing()

    }
    
    @IBAction func Inbox(_ sender: Any) {
        //self.DisableButtons()
        self.petitions.removeAll()
        UIApplication.shared.beginIgnoringInteractionEvents()
   
        timer.invalidate()
        timerSpeak.invalidate()
        //self.AcIndicator()
        let mytoken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
        
        let gplus = "https://www.googleapis.com/gmail/v1/users/me/messages?labelIds=INBOX&access_token=" + mytoken!
        
        let url = NSURL(string: gplus)
        let request = NSMutableURLRequest(url: url as! URL)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, downloadError in
            if let error = downloadError {
                
                print("Login Failed. (Login Step.)")
                
                print("Could not complete the request \(error)")
            } else {
                
                let Qmessages = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                
                let messages = Qmessages["messages"] as? [AnyObject]
                
                //let mid = messages?[0]["id"] as! String
                
                let jm = JSON(Qmessages)
                
                if jm["resultSizeEstimate"] == 0 {
                    self.Loadlabel.text = "Loading..."
                    self.speaker.speak(string: "You got no emails to load")
                    self.overlay!.removeFromSuperview()
                    self.myactivityIndicator.stopAnimating()
                    //self.petitions.removeAll()
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                    //self.EnableButtons()
                }else{
                    for message in messages! {
                        let mid = message["id"] as! String
                        //let tid = message["threadId"] as! String
                        //let objm = ["mid": mid, "tid": tid]
                        //self.petitions.append(objm)
                        //self.greet(person: objm as NSDictionary)
                        self.getHeaders(theid: mid,thetoken: mytoken!)
                        //self.petitions.removeAll()
                        self.tableView.reloadData()
                    }
                    //self.EnableButtons()
                    self.StopAc()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                
            }
        }
        task.resume()
        self.refreshControl.endRefreshing()
    }
    
    
    
    @IBAction func Spam(_ sender: Any) {
        //self.DisableButtons()
        self.petitions.removeAll()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        timer.invalidate()
        timerSpeak.invalidate()
        //self.AcIndicator()
        let mytoken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
        
        let gplus = "https://www.googleapis.com/gmail/v1/users/me/messages?labelIds=SPAM&access_token=" + mytoken!
        
        let url = NSURL(string: gplus)
        let request = NSMutableURLRequest(url: url as! URL)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, downloadError in
            if let error = downloadError {
                
                print("Login Failed. (Login Step.)")
                
                print("Could not complete the request \(error)")
            } else {
                
                let Qmessages = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                
                let messages = Qmessages["messages"] as? [AnyObject]
                
                //let mid = messages?[0]["id"] as! String
                
                let jm = JSON(Qmessages)
                
                if jm["resultSizeEstimate"] == 0 {
                    self.Loadlabel.text = "Loading..."
                    self.speaker.speak(string: "You got no emails to load")
                    self.overlay!.removeFromSuperview()
                    self.myactivityIndicator.stopAnimating()
                    //self.petitions.removeAll()
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                   // self.EnableButtons()
                }else{
                    for message in messages! {
                        let mid = message["id"] as! String
                        //let tid = message["threadId"] as! String
                        //let objm = ["mid": mid, "tid": tid]
                        //self.petitions.append(objm)
                        //self.greet(person: objm as NSDictionary)
                        //self.getHeaders(theid: mid,thetoken: mytoken!)
                        //self.petitions.removeAll()
                        //self.tableView.reloadData()
                    }
                    //self.EnableButtons()
                    self.StopAc()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                
            }
        }
        task.resume()
        ///self.refreshControl.endRefreshing()
    }
    
    @IBAction func Important(_ sender: Any) {
        self.petitions.removeAll()
        UIApplication.shared.beginIgnoringInteractionEvents()
        //self.DisableButtons()

        timer.invalidate()
        timerSpeak.invalidate()
        //self.AcIndicator()
        let mytoken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
        
        let gplus = "https://www.googleapis.com/gmail/v1/users/me/messages?labelIds=IMPORTANT&access_token=" + mytoken!
        
        let url = NSURL(string: gplus)
        let request = NSMutableURLRequest(url: url as! URL)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, downloadError in
            if let error = downloadError {
                
                print("Login Failed. (Login Step.)")
                
                print("Could not complete the request \(error)")
            } else {
                
                let Qmessages = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                
                let messages = Qmessages["messages"] as? [AnyObject]
                
                //let mid = messages?[0]["id"] as! String
                
                let jm = JSON(Qmessages)
                
                if jm["resultSizeEstimate"] == 0 {
                    self.Loadlabel.text = "Loading..."
                    self.speaker.speak(string: "You got no emails to load")
                    self.overlay!.removeFromSuperview()
                    self.myactivityIndicator.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                    //self.EnableButtons()
                }else{
                    for message in messages! {
                        let mid = message["id"] as! String
                        self.getHeaders(theid: mid,thetoken: mytoken!)
                      //  self.tableView.reloadData()
                    }
                    //self.EnableButtons()
                    self.StopAc()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                
            }
        }
        task.resume()
        self.refreshControl.endRefreshing()
    }
  
    
    @IBAction func Starred(_ sender: Any) {
        self.petitions.removeAll()
        UIApplication.shared.beginIgnoringInteractionEvents()
        //self.DisableButtons()
     
        timer.invalidate()
        timerSpeak.invalidate()
        //self.AcIndicator()
        let mytoken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
        
        let gplus = "https://www.googleapis.com/gmail/v1/users/me/messages?labelIds=STARRED&access_token=" + mytoken!
        
        let url = NSURL(string: gplus)
        let request = NSMutableURLRequest(url: url as! URL)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, downloadError in
            if let error = downloadError {
                
                print("Login Failed. (Login Step.)")
                
                print("Could not complete the request \(error)")
            } else {
                
                let Qmessages = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                
                let messages = Qmessages["messages"] as? [AnyObject]
                
                //let mid = messages?[0]["id"] as! String
                
                let jm = JSON(Qmessages)
                
                if jm["resultSizeEstimate"] == 0 {
                    self.Loadlabel.text = "Loading..."
                    self.speaker.speak(string: "You got no emails to load")
                    self.overlay!.removeFromSuperview()
                    self.myactivityIndicator.stopAnimating()
                    //self.petitions.removeAll()
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                   // self.EnableButtons()
                }else{
                    for message in messages! {
                        let mid = message["id"] as! String
                        //let tid = message["threadId"] as! String
                        //let objm = ["mid": mid, "tid": tid]
                        //self.petitions.append(objm)
                        //self.greet(person: objm as NSDictionary)
                        self.getHeaders(theid: mid,thetoken: mytoken!)
                        //self.petitions.removeAll()
                        self.tableView.reloadData()
                    }
                    //self.EnableButtons()
                    self.StopAc()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                
            }
        }
        task.resume()
        self.refreshControl.endRefreshing()
    }
    
    
    
    //Login to get messages
    func getHeaders(theid: String,thetoken: String) {
        self.petitions.removeAll()
        let Hmessage = "https://www.googleapis.com/gmail/v1/users/me/messages/" + theid + "?metadataHeaders=Subject&metadataHeaders=From&metadataHeaders=To&metadataHeaders=Date&access_token=" + thetoken
        
        let url = NSURL(string: Hmessage)
        let request = NSMutableURLRequest(url: url as! URL)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, downloadError in
            if let error = downloadError {
                
                print("Login Failed. (Login Step.)")
                
                print("Could not complete the request \(error)")
            } else {
                
                let Hmessages = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                
                let json2 = JSON(Hmessages)
                
                let body = json2["payload"]["parts"][1]["body"]["data"].stringValue
                
                var tempEncodedString = body.replacingOccurrences(of: "-", with: "+", options: NSString.CompareOptions.literal, range: nil)
                tempEncodedString = tempEncodedString.replacingOccurrences(of: "_", with: "/", options: NSString.CompareOptions.literal, range: nil)
                var equalsToBeAdded = (body as NSString).length % 4
                if(equalsToBeAdded > 0){
                    for _ in 0..<equalsToBeAdded {
                        tempEncodedString += "="
                    }
                }
                
                
                //decode base64
                tempEncodedString = tempEncodedString.fromBase64()!
                
                let htmlView2 = tempEncodedString
                let plaintxt2 = htmlView2.html2String

                
                //print(json2)
                
                let HeadId = json2["id"].stringValue
                let HthreadId = json2["threadId"].stringValue
                let HeadersDate = json2["payload"]["headers"][16]["value"].stringValue
                let HeadersTo = json2["payload"]["headers"][19]["value"].stringValue
                
                let headers = json2["payload"]["headers"].arrayValue
                
                let subjects = json2["payload"]["headers"].arrayValue
                
                for subject in subjects {
                    let subject1 = subject["name"].stringValue
                    let value1 = subject["value"].stringValue
                   
                    
                    if(subject1 == "Subject" || subject1 == "From"){
                        
                        let objm3 = [subject1: value1] as! NSDictionary
                        //let s = objm3["Subject"] as! String
                        let json3 = JSON(objm3)
                        
                        //print(sub)
                       // print(frm)
                        
                        /*let trimSub = sub.trimmingCharacters(in: .whitespaces)
                        let trimFrm = frm.trimmingCharacters(in: .whitespaces)
                        trimFrm.html2AttributedString*/
                        
                        //self.msubject.append(objm3 as! [String : String])
                        //self.mfrom.append(frm)
                        
                        
                        /*for index in 0 ..< self.msubject.count {
                            if self.msubject[index] == nil || self.mfrom[index] == nil {
                                self.msubject = self.msubject.filter { $0 != nil }
                                self.mfrom = self.mfrom.filter { $0 != nil }
                                
                            }
                        }*/
                        
                        
                        
                        //print("---------------------------------------------------------------------------")
                        
                        //print("---------------------------------------------------------------------------")
                        
                       
                        
                        
                       
                        
                        
                       // if(s.isEmpty == false && f.isEmpty == false){
                           // print("Subject : " + s + " From : " + f)
                        //}
                        
                        
                        
                        
                        //let obj4 = ["Subject": s, "From": f]
                        //print(json3)
                        //print(json3)
                        //print("\(obj)")
                        //print("Date : " + d)
                        //print("To : " + t)
                        
                      
                    }
                    
                    
                }
                
                //let subs1 = JSON(self.msubject)
                
                //let sub2 = subs1[0]["Subject"]
                //let frm2 = subs1[0]["From"]
                
               // let SubFrm = ["subs": sub, "frms": frm]
                
                //print("---------")
                //print(sub2)
                //print(frm2)
               // print("---------")
                
                let obj = ["plaintxt": plaintxt2, "htmlView2": htmlView2, "mid": HeadId, "tid": HthreadId]
                
                self.petitions.append(obj)
                
                
                //let numberofRows =  self.subject.count
                
                //print(headers)
                
                
             /*  for i in 1...numberofRows {
                   var H = "name"
                   H += "\(i)"
                   var Subject = json2["payload"][H]["name"].string as String!
                   print(Subject)
                    Q
                }*/
                
                
                
                
               // let messages = Hmessages["messages"] as? [AnyObject]
                
                //for message in messages! {
                   // let mid = message["payload"] as! String
                   // self.tableView.reloadData()
                   // print("\(messages)")
               // }
                
                
                //let objm3 = ["From": HeadersFrom, "Subject": HeadersSubject, "mid": HeadId, "tid": HthreadId, "plaintxt": plaintxt2, "htmlView2": htmlView2]
                
                //self.petitions.append(objm3)
                self.tableView.reloadData()
                
            }
            self.StopAc()
            self.refreshControl.endRefreshing()
            
        }
        task.resume()
    }
    
    //header 2
    func getHeaders2(theid: String,thetoken: String) {
        self.petitions.removeAll()
        let Hmessage = "https://www.googleapis.com/gmail/v1/users/me/messages/" + theid + "?metadataHeaders=Subject&metadataHeaders=From&metadataHeaders=To&metadataHeaders=Date&access_token=" + thetoken
        
        let url = NSURL(string: Hmessage)
        let request = NSMutableURLRequest(url: url as! URL)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let r_subject = request.addValue("application/json", forHTTPHeaderField: "Subject")
        
        print("----------------")
        print("\(request.allHTTPHeaderFields))")
        print("----------------")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, downloadError in
            if let error = downloadError {
                
                print("Login Failed. (Login Step.)")
                
                print("Could not complete the request \(error)")
            } else {
                
                let Hmessages = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                
                let json2 = JSON(Hmessages)
                
                //print(json2)
                
                let HeadId = json2["id"].stringValue
                let HthreadId = json2["threadId"].stringValue
                let HeadersDate = json2["payload"]["headers"][16]["value"].stringValue
                let HeadersSubject = json2["payload"]["headers"][17]["value"].stringValue.html2String
                let HeadersFrom = json2["payload"]["headers"][18]["value"].stringValue.html2String
                let HeadersTo = json2["payload"]["headers"][19]["value"].stringValue
                let body = json2["payload"]["parts"][1]["body"]["data"].stringValue
                
                var tempEncodedString = body.replacingOccurrences(of: "-", with: "+", options: NSString.CompareOptions.literal, range: nil)
                tempEncodedString = tempEncodedString.replacingOccurrences(of: "_", with: "/", options: NSString.CompareOptions.literal, range: nil)
                var equalsToBeAdded = (body as NSString).length % 4
                if(equalsToBeAdded > 0){
                    for _ in 0..<equalsToBeAdded {
                        tempEncodedString += "="
                    }
                }
                
                
                //decode base64
                tempEncodedString = tempEncodedString.fromBase64()!
                
                let htmlView2 = tempEncodedString
                let plaintxt2 = htmlView2.html2String
                
                print("Header id " + HeadId)
                print("Header thread id Thread " + HthreadId)
                print("Date : " + HeadersDate)
                print("Subject : " + HeadersSubject)
                print("From : " + HeadersFrom.html2String)
                print("To : " + HeadersTo)
                
                // let messages = Hmessages["messages"] as? [AnyObject]
                
                //for message in messages! {
                // let mid = message["payload"] as! String
                // self.tableView.reloadData()
                // print("\(messages)")
                // }
                
                
                let objm3 = ["From": HeadersFrom, "Subject": HeadersSubject, "mid": HeadId, "tid": HthreadId, "plaintxt": plaintxt2, "htmlView2": htmlView2]
                
                self.petitions.append(objm3)
                let gesture2 = UISwipeGestureRecognizer.init(target: self, action: #selector (self.someAction (_:)))
                gesture2.direction = UISwipeGestureRecognizerDirection.left
                self.overlay.addGestureRecognizer(gesture2)
                self.tableView.reloadData()
                
            }
            self.StopAc()
            self.refreshControl.endRefreshing()
            
        }
        task.resume()
    }
    
    
    func DelMsg(mytoken: String, mid: String, eid: String) {
        
        
        if self.petitions.count != 0 {
            let MarkP = "https://www.googleapis.com/gmail/v1/users/" + eid + "/messages/" + mid + "?acess_token=" + mytoken
            
            let url = NSURL(string: MarkP)
            let request = NSMutableURLRequest(url: url as! URL)
            request.httpMethod = "DELETE"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "ACCEPT")
            
            
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { data, response, downloadError in
                if let error = downloadError {
                    
                    print("Login Failed. (Login Step.)")
                    
                    print("Could not complete the request \(error)")
                } else {
                    print("DELETED")
                }
            }
            task.resume()
        }else{
            print("No emails")
        }
    }
    
    
    func MarkRead(mytoken: String, eid: String, mid: String){
        
        if self.petitions.count != 0 {
        
            let read = "https://www.googleapis.com/gmail/v1/users/" + eid + "/messages/" + mid + "/modify?access_token=" + mytoken
            
            let postString = "{ \"removeLabelIds\" : [\"UNREAD\"] }"
            
            let url = NSURL(string: read)
            let request = NSMutableURLRequest(url: url as! URL)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { data, response, downloadError in
                if let error = downloadError {
                    
                    print("Login Failed. (Login Step.)")
                    
                    print("Could not complete the request \(error)")
                } else {
                    
                    print("MARK AS READ")
                    
                    
                }
            }
            task.resume()
        }else{
            print("No emails")
        }
        
    }
    
    // Construct a query and get a list of upcoming labels from the gmail API
     /*
    func fetchLabels() {
    
        query.maxResults = 100
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(ViewController.displayResultWithTicket(ticket:finishedWithObject: error:))
        )
        
        
        
    }
    
    
    // Construct a query and get a list of upcoming events from the user calendar
   
    func fetchEvents() {
        let query = GTLQueryCalendar.queryForEventsList(withCalendarId: "primary")
        query?.maxResults = 10
        query?.timeMin = GTLDateTime(date: NSDate() as Date!, timeZone: NSTimeZone.local)
        query?.singleEvents = true
        query?.orderBy = kGTLCalendarOrderByStartTime
        service.executeQuery(
            query!,
            delegate: self,
            didFinish: #selector(ViewController.displayResultWithTicket(ticket:finishedWithObject: error:))
        )
    }


    // Display the start dates and event summaries in the UITextView
    func displayResultWithTicket(ticket: GTLServiceTicket, finishedWithObject response : GTLRGmailQuery_UsersMessagesList, error : NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        var eventString = ""
        
        if let events = response.items() , !events.isEmpty {
            for event in events as! [GTLRGmailQuery_UsersMessagesList] {
                let start : GTLDateTime! = event.start.dateTime ?? event.start.date
                let startString = DateFormatter.localizedString(
                    from: start.date,
                    dateStyle: .short,
                    timeStyle: .short
                )
                eventString += "\(startString) - \(event.summary)\n"
            }
        } else {
            eventString = "No upcoming events found."
        }
        
        output.text = eventString
    }*/
    
    @IBAction func logOut(_ sender: AnyObject){
        timer.invalidate()
        timerSpeak.invalidate()
        GIDSignIn.sharedInstance().signOut()
        try! FIRAuth.auth()!.signOut()
        print("Sign out")
       self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }

    
    // or for Swift 3
    func someAction(_ sender:UITapGestureRecognizer){
        timer.invalidate()
        timerSpeak.invalidate()
        self.Swicth.setOn(false, animated: true)
        self.Swicth.isOn = false
        self.speaker.synth.stopSpeaking(at: AVSpeechBoundary.immediate)
        self.overlay.removeFromSuperview()
        self.myWebView.removeFromSuperview()
        myactivityIndicator.stopAnimating()
        self.refreshControl.endRefreshing()
    }
    
    func StopAc(){
        self.tableView.reloadData()
        self.overlay.removeFromSuperview()
        myactivityIndicator.stopAnimating()
        //view?.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
    
    
    
}




