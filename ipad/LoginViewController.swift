//
//  LoginViewController.swift
//  ipad
//
//  Created by Macbook Pro on 12/11/2016.
//  Copyright © 2016 SuperSonicDesign.com. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import SystemConfiguration

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired
        
        return isReachable && !needsConnection
        
    }
}

class LoginViewController: UIViewController, AVSpeechSynthesizerDelegate {
  

    override func viewDidLoad() {
            super.viewDidLoad()
    
        
        // Reachability.isConnectedToNetwork() == true
        //{
                       //menuView.layer.shadowOpacity = 1
            //menuView.layer.shadowRadius = 6
            
        
        

       /* }
        else
        {
            self.openSetting()
        }*/
    }
    
    func openSetting(){
        let alertController = UIAlertController (title: "No Internet Connection", message: "Please Check", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)

    }
    
    func Hello(){
        //let utterance = AVSpeechUtterance(string: "ページが読み込まれている間お待ちください...左から右にスワイプしてログインボタンを表示することができます。")
        //utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        
        let utterance = AVSpeechUtterance(string: "Welcome. please swipe from left to right to see login button.")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
   
}
