//
//  DateViewController.swift
//  FindMyDate
//
//  Created by Chris Dean on 2017-07-04.
//  Copyright © 2017 Chris Dean. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class DateViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var dateeName: UILabel!
    @IBOutlet weak var dateePic: UIImageView!
    
    var user: FirebaseUser!
    var suitorsName: String!
    var suitorsUid: String!
    let datesRef = Database.database().reference(withPath: "dates")
    let usersRef = Database.database().reference(withPath: "users")
    var place: String!
    var accepted: Bool = false
    let storageRef = Storage.storage().reference(forURL: "gs://findmydate-1c6f4.appspot.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assigns image to nav bar and assigns back button
        let logo = UIImage(named: "FMDIcon")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.location.delegate = self
        dateeName.text = user?.name
        
        // Retrieves current user's info
        let userID = Auth.auth().currentUser?.uid
        usersRef.child(userID!).observeSingleEvent(of: .value, with: { snap in
            let value = snap.value as? NSDictionary
            self.suitorsName = value?["name"] as? String ?? ""
            self.suitorsUid = value?["uid"] as? String ?? ""
        })
        
//        DispatchQueue.global(qos: .userInitiated).async {
//            let image = self.loadOrGenerateAnImage()
//            // Bounce back to the main thread to update the UI
//            DispatchQueue.main.async {
//                self.imageView.image = image
//            }
//        }
        DispatchQueue.global(qos: .userInitiated).async {
            let profilePicRef = self.storageRef.child(self.user.uid + "/profile_pic.jpg")
            profilePicRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if error != nil {
                    print("an error occurred when downloading profile picture from firebase storage")
                } else {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data!)
                        self.dateePic.image = image
                    }
                }
            }
        }
            
        dateePic.layer.borderWidth = 1
        dateePic.layer.masksToBounds = false
        dateePic.layer.borderColor = UIColor.black.cgColor
        dateePic.layer.cornerRadius = dateePic.frame.height/2
        dateePic.clipsToBounds = true
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func swipeAction(swipe: UISwipeGestureRecognizer) -> Void {
        if swipe.direction == UISwipeGestureRecognizerDirection.right {
            place = location.text
            print(place)
            print(suitorsUid)
            print(suitorsName)
            self.datesRef.child((self.user?.uid)!).child(suitorsUid).setValue(["location": place, "Suitor's Name": suitorsName, "Suitor's Uid": suitorsUid, "Accepted": accepted])
            self.navigationController?.popViewController(animated: true)
        }
        else {
            return
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


