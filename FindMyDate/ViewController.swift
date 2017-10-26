//
//  ViewController.swift
//  FindMyDate
//
//  Created by Chris Dean on 2017-05-25.
//  Copyright © 2017 Chris Dean. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    var fbLoginSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assigns image to nav bar and assigns back button
        let logo = UIImage(named: "FMDIcon")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Creates Facebook login button
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 250, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
             print(error)
            print("0")
            return
        }
        else{
            print(result)
            print("1")
            fbLoginSuccess = true
        }
        
        if (FBSDKAccessToken.current() != nil && fbLoginSuccess == true)
        {
            print("2")
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
                if error != nil {
                    print("Something went wrong with our fb user", error ?? "")
                    return
                }
            }
            print("3")
            performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
}

