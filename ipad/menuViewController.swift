//
//  menuViewController.swift
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

extension UIImageView{
    
    func setImageFromURl(stringImageUrl url: String){
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}

class menuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, GIDSignInUIDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    var databaseRef: FIRDatabaseReference!
    
    let speaker = Speaker()
    var timer = Timer()

    @IBOutlet weak var tblTableView: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var name: UILabel!
    
    var ManuNameArray:Array = [String]()
    var iconArray:Array = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(menuViewController.reloadPhoto), userInfo: nil, repeats: true)
        self.SignMeIn()
        
        ManuNameArray = ["Home","New Message", "Inbox", "Starred", "Important", "Spam","Setting","Log out"]
        iconArray = [UIImage(named:"home")!,UIImage(named:"newmessage")!,UIImage(named:"message")!,UIImage(named:"starred")!,UIImage(named:"important")!,UIImage(named:"spam")!,UIImage(named:"setting")!,UIImage(named:"logout")!]
        
        //imgProfile.layer.borderWidth = 2
        imgProfile.layer.borderColor = UIColor.green.cgColor
        imgProfile.layer.cornerRadius = 50
        
        imgProfile.layer.masksToBounds = false
        imgProfile.clipsToBounds = true
        imgProfile.layer.shadowOpacity = 1
        imgProfile.layer.shadowRadius = 6
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadPhoto(){
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            let user = GIDSignIn.sharedInstance().currentUser
            let uphoto = user?.profile.imageURL(withDimension: 150)
            self.imgProfile.setImageFromURl(stringImageUrl: (uphoto?.absoluteString)!)
            self.nickname.text = GIDSignIn.sharedInstance().currentUser.profile.givenName
            self.name.text = GIDSignIn.sharedInstance().currentUser.profile.familyName
        } 
    }
    
    func SignMeIn(){
        let user = GIDSignIn.sharedInstance().currentUser
        let uphoto = user?.profile.imageURL(withDimension: 150)
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            GIDSignIn.sharedInstance().signInSilently()
            self.imgProfile.setImageFromURl(stringImageUrl: (uphoto?.absoluteString)!)
            self.nickname.text = GIDSignIn.sharedInstance().currentUser.profile.givenName
            self.name.text = GIDSignIn.sharedInstance().currentUser.profile.familyName
            
            let str = "Hi Welcome " + GIDSignIn.sharedInstance().currentUser.profile.givenName + " " + GIDSignIn.sharedInstance().currentUser.profile.familyName//just some string here, this string exists, and it's in english
            
            speaker.speak(string: str)
            
            print("Auto login success")
        } else {
            GIDSignIn.sharedInstance().signIn()
            self.imgProfile.setImageFromURl(stringImageUrl: (uphoto?.absoluteString)!)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().uiDelegate = self
        
        


    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ManuNameArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        cell.lblMenuname.text! = ManuNameArray[indexPath.row]
        cell.imgIcon.image = iconArray[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        
        let cell:MenuCell = tableView.cellForRow(at: indexPath) as! MenuCell
        print(cell.lblMenuname.text!)
        
        if cell.lblMenuname.text! == "Home"
        {
            print("Home Tapped")
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
            
        }
        
        if cell.lblMenuname.text! == "New Message"
        {
            print("message Tapped")
           
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
            
            /*(GIDSignIn.sharedInstance().signInSilently()
            let user = GIDSignIn.sharedInstance().currentUser
            
            let authentication = user?.authentication
            let utoken = authentication?.accessToken
            
            let uphoto = user?.profile.imageURL(withDimension: 150)
            
            self.imgProfile.setImageFromURl(stringImageUrl: (uphoto?.absoluteString)!)
            self.nickname.text = GIDSignIn.sharedInstance().currentUser.profile.givenName
            self.name.text = GIDSignIn.sharedInstance().currentUser.profile.familyName*/
            
            // let uname = user.profile.name
            
            // let uphoto = user.profile.imageURL(withDimension: 150)

           
            
        }
        
        if cell.lblMenuname.text! == "Inbox"
        {
            print("message Tapped")
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "InboxViewController") as! InboxViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
            
            
        }
        
        if cell.lblMenuname.text! == "Starred"
        {
            print("message Tapped")
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "Starred") as! Starred
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
            
        
        }

        if cell.lblMenuname.text! == "Important"
        {
            print("message Tapped")
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "Important") as! Important
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
        
        }

        if cell.lblMenuname.text! == "Spam"
        {
            print("message Tapped")
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "Spam") as! Spam
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
            
        }

        if cell.lblMenuname.text! == "Map"
        {
            print("Map Tapped")
        }
        
        if cell.lblMenuname.text! == "Setting"
        {
           print("setting Tapped")
          
        }
        
        if cell.lblMenuname.text! == "Log out"
        {
            //timer.invalidate()
           //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
            
            //self.dismiss(animated: true, completion: nil)
            
            
            GIDSignIn.sharedInstance().signOut()
            try! FIRAuth.auth()!.signOut()
            print("Sign out")

        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
