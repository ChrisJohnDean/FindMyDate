//
//  AcceptedDateViewController.swift
//  FindMyDate
//
//  Created by Chris Dean on 2017-09-15.
//  Copyright © 2017 Chris Dean. All rights reserved.
//

import UIKit
import Firebase

class AcceptedDateViewController: UIViewController {

    @IBOutlet weak var acceptedView: AcceptedDateView!
    var match: Match!
    let storageRef = Storage.storage().reference(forURL: "gs://findmydate-1c6f4.appspot.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        acceptedView.location.text = match?.location
        acceptedView.matchName.text = match?.suitorsName
        acceptedView.layer.cornerRadius = 10
        acceptedView.layer.masksToBounds = true
        acceptedView.clipsToBounds = false
        acceptedView.layer.shadowColor = UIColor.black.cgColor
        acceptedView.layer.shadowOpacity = 1
        acceptedView.layer.shadowOffset = CGSize.zero
        acceptedView.layer.shadowRadius = 10
        acceptedView.layer.shadowPath = UIBezierPath(roundedRect: acceptedView.bounds, cornerRadius: 10).cgPath
        
        let profilePicRef = self.storageRef.child(match.suitorsUid + "/profile_pic.jpg")
        profilePicRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print("an error occurred when downloading profile picture from firebase storage")
            } else {
                let image = UIImage(data: data!)
                self.acceptedView.suitorPic.image = image
            }
        }
        
        /*
         image.layer.borderWidth = 1
         image.layer.masksToBounds = false
         image.layer.borderColor = UIColor.blackColor().CGColor
         image.layer.cornerRadius = image.frame.height/2
         image.clipsToBounds = true
         */
        let suitorPic = acceptedView.suitorPic
        suitorPic?.layer.borderWidth = 1
        suitorPic?.layer.masksToBounds = false
        suitorPic?.layer.borderColor = UIColor.black.cgColor
        suitorPic?.layer.cornerRadius = acceptedView.suitorPic.frame.height/2
        suitorPic?.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
