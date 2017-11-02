//
//  ViewController.swift
//  FindMyDate
//
//  Created by Chris Dean on 2017-05-25.
//  Copyright © 2017 Chris Dean. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var fbLoginSuccess = false
    var authListener: AuthStateDidChangeListenerHandle!
    @IBOutlet weak var navLogo: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Checks to see if the user is already signed into Firebase
        self.authListener = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // Creates Facebook login button
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 250, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
    }

    override func viewDidAppear(_ animated: Bool) {
        //super.viewDidAppear(true)
        let logo = UIImage(named: "FMDIcon")
        let imageView = UIImageView(image:logo)
        //self.navigationItem.titleView = imageView
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navLogo.titleView = imageView
    }
    
    //Removes firebase listener from listening for current user
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(self.authListener)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
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

            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }

    }
}

