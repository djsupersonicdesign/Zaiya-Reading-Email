//
//  MessageViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
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

class MessageViewController: UIViewController,UINavigationBarDelegate,UINavigationControllerDelegate, GIDSignInUIDelegate, GIDSignInDelegate, UITableViewDelegate, UITableViewDataSource {

    var window: UIWindow?
    var databaseRef: FIRDatabaseReference!
    
    private let kKeychainItemName = "Gmail API"
    private let kClientID = "CLIENT ID"
    private let service = GTLRGmailService()
    private let query = GTLRGmailQuery_UsersMessagesList.query(withUserId: "me")
    
    //var passKey = String()
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    
    let output = UITextView()
    
    @IBOutlet weak var ProfilePhoto: UIImageView!
    
    @IBOutlet weak var ProfileName: UILabel!
    
    @IBOutlet weak var Swicth: UISwitch!
    @IBOutlet weak var autoLbl: UILabel!
    
    
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
    
    let myWebView:UIWebView = UIWebView(frame: CGRect(x:0, y:65, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
    
    var refreshControl: UIRefreshControl!
    
    var counter = 0
    var timer = Timer()
    var timerSpeak = Timer()
    
    var myactivityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    let Loadlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    
    let speaker = Speaker()
    
    let date = NSDate()
    
    @IBOutlet weak var menu: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu.isEnabled = false
        // Do any additional setup after loading the view.
        timer.invalidate()
        timerSpeak.invalidate()
        
       revealViewController().rearViewRevealWidth = 200
       menu.target = revealViewController()
       menu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().scopes.append("https://mail.google.com/")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me") 
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/gmail.modify")
        
        self.SignMeIn()
        
        refreshControl = UIRefreshControl()
        self.AcIndicator()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //autoLbl.text =
        
    }//VIEW DID ENDING
    
    
    
    func SignMeIn(){
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            GIDSignIn.sharedInstance().signInSilently()
            let user = GIDSignIn.sharedInstance().currentUser
             print("Auto login success")
        } else {
            GIDSignIn.sharedInstance().signIn()
            let user = GIDSignIn.sharedInstance().currentUser
        }
    }
    
    /*func userDidEnterData(data: String) {
        print(data)
        speaker.speak(string: data)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNewMessage" {
            let Menu: ViewController = segue.destination as! ViewController
            Menu.delegate = self
            Menu.delegate?.userDidEnterData(data: GIDSignIn.sharedInstance().currentUser.authentication.accessToken)
        }
    }*/
    
    
    
    func profilePicSetting(){
        //ProfilePhoto.layer.borderWidth = 1
        ProfilePhoto.layer.masksToBounds = false
        //ProfilePhoto.layer.borderColor = UIColor.white.cgColor
        ProfilePhoto.layer.cornerRadius = ProfilePhoto.frame.height/2
        ProfilePhoto.clipsToBounds = true
        ProfilePhoto.layer.shadowOpacity = 1
        ProfilePhoto.layer.shadowRadius = 6
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func CheckSpeak(){
        
        if self.speaker.synth.isSpeaking {
            print("Still Speaking...")
        }else{
            self.timerSpeak.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(MessageViewController.update), userInfo: nil, repeats: true)
        }
    }

    //try to update selected table row
    func update() {
        self.refreshControl.beginRefreshing()
        if petitions.count == 0 {
            self.loginWithToken(mytoken: GIDSignIn.sharedInstance().currentUser.authentication.accessToken)
            self.StopAc()
            self.refreshControl.endRefreshing()
            menu.isEnabled = true
        }else{
            if self.speaker.synth.isSpeaking {
                print("Still Speaking...")
                self.timer.invalidate()
                timerSpeak = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(MessageViewController.CheckSpeak), userInfo: nil, repeats: true)
                self.refreshControl.endRefreshing()
            }else{
                if self.petitions.count == count {
                    count = 0
                    //timerSpeak.invalidate()
                   // timer.invalidate()
                    self.myWebView.removeFromSuperview()
                    //self.refreshControl.beginRefreshing()
                    //self.refreshControl.endRefreshing()
                    self.loginWithToken(mytoken: GIDSignIn.sharedInstance().currentUser.authentication.accessToken)
                    self.petitions.removeAll()
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    menu.isEnabled = false
                }else{
                    //self.loginWithToken(mytoken: GIDSignIn.sharedInstance().currentUser.authentication.accessToken)
                    // let delayInSeconds = 7.0
                    //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                    
                    let indexPath = IndexPath(row: self.count, section: 0)
                    if(indexPath != nil){
                        if(self.count > self.petitions.count){
                            self.count = 0
                        }else{
                            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
                            self.tableView.delegate?.tableView!(self.tableView, didSelectRowAt: indexPath)
                            self.count += 1
                        }
                    }else{
                        self.count = 0
                    }
                    print("Row Selected")
                    print("Table has been refresh...")
                    self.refreshControl.endRefreshing()
                    //}
                }
                
            }
        }
        
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
        switch swipeGesture.direction {
        case UISwipeGestureRecognizerDirection.right:
           print("Swiped right")
        case UISwipeGestureRecognizerDirection.down:
            print("Swiped down")
        case UISwipeGestureRecognizerDirection.left:
            print("Swiped left")
            self.myWebView.removeFromSuperview()
            self.overlay.removeFromSuperview()
            self.myactivityIndicator.stopAnimating()
            timer.invalidate()
            timerSpeak.invalidate()
            self.Swicth.setOn(false, animated: true)
            self.Swicth.isOn = false
            self.speaker.synth.stopSpeaking(at: AVSpeechBoundary.immediate)
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            menu.isEnabled = true
        case UISwipeGestureRecognizerDirection.up:
            print("Swiped up")
            default:
            break
            }
        }
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
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let uname = user.profile.name
        
        let uphoto = user.profile.imageURL(withDimension: 150)
        let authentication = user.authentication
        let utoken = authentication?.accessToken
        
        //self.ProfileName.text = uname!
       // self.ProfilePhoto.setImageFromURl(stringImageUrl: (uphoto?.absoluteString)!)
        
       // let str = "Hi Welcome " + uname! //just some string here, this string exists, and it's in english
        
        //speaker.speak(string: str)
        
       
        
        //self.refreshControl.beginRefreshing()
        
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
                
                //self.performSegue(withIdentifier: "HomeViewSegue", sender: self)
                
                self.loginWithToken(mytoken: utoken!)
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let petition = petitions[indexPath.row]
        let plain = petition["plaintxt"]
        let htmlView = petition["htmlView2"]
        let plainHtml2 = plain?.html2String
        var trimPlain = plainHtml2?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //let psub = msubject[indexPath.row]
        //let pfrm = mfrom[indexPath.row]
        //let pfrm = mfrom[indexPath.row]
        //print(psub)
        //print("-------")
        
        
        if(trimPlain == "") || (trimPlain?.isEmpty)!{
            cell.mname?.text = "Send to: You" //GIDSignIn.sharedInstance().currentUser.profile.email
            cell.mm?.text = "Unable to load"
        }else{
            cell.mname?.text = "Send to: You" //GIDSignIn.sharedInstance().currentUser.profile.email
            cell.mm?.text = trimPlain
        }
        
        
        //petition["tid"]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "OneSegue", sender: petitions[indexPath.row])
        menu.isEnabled = false
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let petition = petitions[indexPath.row]
        let messageid = petition["mid"]
        let plain = petition["plaintxt"]
        let htmlView = petition["htmlView2"]
        let plainHtml2 = plain?.html2String
        var trimPlain = plainHtml2?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.speaker.speak(string: plain!)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
        
        var button = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: self.view.frame.height - 112), size: CGSize(width: self.myWebView.frame.width, height: 50)))
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        
        
        button.backgroundColor = UIColor.black
        button.tintColor = UIColor.white
        button.setTitle("<- Close",for: .normal)
        self.myWebView.contentMode = UIViewContentMode.scaleAspectFit
        self.myWebView.addSubview(button)
        button.addGestureRecognizer(swipeLeft)
        
        self.myWebView.addSubview(button)
        
        self.myWebView.loadHTMLString(htmlView!, baseURL: nil)
        self.view.addSubview(self.myWebView)
            
        }
        
        
        self.MarkRead(mytoken: GIDSignIn.sharedInstance().currentUser.authentication.accessToken, eid: GIDSignIn.sharedInstance().currentUser.profile.email, mid: messageid!)
        
        
        if self.speaker.synth.isSpeaking {
            self.refreshControl.endRefreshing()
            print("Still Speaking...")
            self.tableView.reloadData()
        }else{
            if self.petitions.count == count {
                count = 0
                
            }else{
                //self.speaker.speak(string: "You got a new message.")
                //self.singleMesage(mtoken: GIDSignIn.sharedInstance().currentUser.authentication.accessToken, myid: messageid!, userid: GIDSignIn.sharedInstance().currentUser.profile.email)
                print("Row Selected")
                print("Table has been refresh...")
                print("SELECTED MESSAGE : " + messageid!)
                //self.petitions.remove(at: indexPath.row)
                }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       // self.menu.isEnabled = true
        //self.StopAc()
        //view?.backgroundColor = UIColor(white: 1, alpha: 0.5)
        //self.refreshControl.beginRefreshing()
        self.tableView.reloadData()
        return print("loading table completed...")
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let petition = petitions[indexPath.row]
        let messageid = petition["tid"]
        
        if editingStyle == .delete {
            petitions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            //self.DelMsg(mytoken: GIDSignIn.sharedInstance().currentUser.authentication.accessToken, mid: messageid!, eid: GIDSignIn.sharedInstance().currentUser.profile.email)
        }
    }
    
    //Login to get messages
    func loginWithToken(mytoken: String) {
        self.petitions.removeAll()
       
        let gplus = "https://www.googleapis.com/gmail/v1/users/me/messages?labelIds=UNREAD&access_token=" + mytoken
        
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
                    
                    //self.speaker.speak(string: "You got no emails to load")
                    self.overlay!.removeFromSuperview()
                    self.myactivityIndicator.stopAnimating()
                    //self.petitions.removeAll()
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                 
                }else{
                    for message in messages! {
                        let mid = message["id"] as! String
                        self.getHeaders(theid: mid,thetoken: mytoken)
                        self.tableView.reloadData()
                    }
                    
                    self.StopAc()
                    
                }
                
            }
        }
        task.resume()
       // self.refreshControl.endRefreshing()
        
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
                
               /*
                
                for subject in subjects {
                    let subject1 = subject["name"].stringValue
                    let value1 = subject["value"].stringValue
                    
                    
                    if(subject1 == "Subject" || subject1 == "From"){
                        
                        let objm3 = [subject1: value1] as! NSDictionary
                        //let s = objm3["Subject"] as! String
                        let json3 = JSON(objm3)*/
                        
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
                        
                        
                   // }
                    
                    
                //}
                
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
    
    func AcIndicator(){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
        
        self.overlay = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 50))
        self.overlay!.backgroundColor = UIColor.black
        self.overlay!.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        self.overlay!.alpha = 0.8
        self.overlay!.layer.cornerRadius = 10
        self.view.addSubview(self.overlay!)
        
        /*self.Loadlabel.textColor = UIColor.white
        self.Loadlabel.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        self.Loadlabel.textAlignment = .center
        self.overlay.addSubview(self.Loadlabel)*/
        
        self.myactivityIndicator.center = self.view.center
        self.myactivityIndicator.hidesWhenStopped = true
        self.myactivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        self.view.addSubview(self.myactivityIndicator)
        
        self.myactivityIndicator.startAnimating()
        //UIApplication.shared.beginIgnoringInteractionEvents()
        //self.Loadlabel.text = "Loading..."
        }
        
    }
  
    func StopAc(){
        self.tableView.reloadData()
        self.overlay.removeFromSuperview()
        myactivityIndicator.stopAnimating()
        //view?.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        autoLbl.text = "Off"
        self.speaker.synth.stopSpeaking(at: AVSpeechBoundary.immediate)
        self.petitions.removeAll()
        self.tableView.reloadData()
        self.myWebView.removeFromSuperview()
        self.overlay.removeFromSuperview()
        self.myactivityIndicator.stopAnimating()
        timerSpeak.invalidate()
        self.refreshControl.endRefreshing()
    }
    
    @IBAction func Switchy(_ sender: Any) {
        if Swicth.isOn {
            autoLbl.text = "Automatic"
            self.AcIndicator()
            timerSpeak.invalidate()
            timer.invalidate() // just in case this button is tapped multiple times
            // start the timer
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(MessageViewController.update), userInfo: nil, repeats: true)
            
            
        }else{
                timer.invalidate()
                autoLbl.text = "Off"
                self.speaker.synth.stopSpeaking(at: AVSpeechBoundary.immediate)
                self.petitions.removeAll()
                self.tableView.reloadData()
                self.myWebView.removeFromSuperview()
                self.overlay.removeFromSuperview()
                self.myactivityIndicator.stopAnimating()
                timerSpeak.invalidate()
                self.refreshControl.endRefreshing()
                menu.isEnabled = true
            }
    }


}


