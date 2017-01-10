//
//  AppDelegate.swift
//  ipad
//
//  Created by Macbook Pro on 24/10/2016.
//  Copyright © 2016 SuperSonicDesign.com. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import CoreData
import Firebase
import Alamofire
import GoogleSignIn

extension String {
    var html2AttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    /// Encode a String to Base64
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    /// Decode a String from Base64. Returns nil if unsuccessful.
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func base64Encoded() -> String {
        
        guard let plainData = (self as NSString).data(using: String.Encoding.utf8.rawValue) else {
            
            fatalError()
            
        }
        
        
        let base64String = plainData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: NSData.Base64DecodingOptions(rawValue: NSData.Base64DecodingOptions.ignoreUnknownCharacters.rawValue).rawValue))
        
        
        return base64String as String
        
    }
    
    func base64Decoded() -> String {
        
        if let decodedData = NSData(base64Encoded: self, options:NSData.Base64DecodingOptions(rawValue: 0)),
            
            let decodedString = NSString(data: decodedData as Data, encoding: String.Encoding.utf8.rawValue) {
            
            return decodedString as String
            
        } else {
            
            
            return self
            
        }
    }
    
    /*func trunc(length: Int, trailing: String? = "...") -> String {
     if self.characters.count > length {
     return self.substring(to: self.startIndex) + (trailing ?? "")
     } else {
     return self
     }
     }*/
}

class Speaker: NSObject {
    let synth = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        synth.delegate = self
    }
    
    func speak(string: String) {
        let utterance = AVSpeechUtterance(string: string)
        utterance.rate = 0.5
        synth.speak(utterance)
    }
}

extension Speaker: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        //print("all done")
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    var databaseRef: FIRDatabaseReference!
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        //GIDSignIn.sharedInstance().clientID = "com.googleusercontent.apps.399678307940-g1vqof5v5u7anssej6h7t7eh4944en67"
        GIDSignIn.sharedInstance().delegate = self
        let user = GIDSignIn.sharedInstance().currentUser

                return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
     
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
       
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ipad")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

