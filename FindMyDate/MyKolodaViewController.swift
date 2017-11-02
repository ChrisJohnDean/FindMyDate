//
//  MyKolodaViewController.swift
//  FindMyDate
//
//  Created by Chris Dean on 2017-08-10.
//  Copyright © 2017 Chris Dean. All rights reserved.
//

import UIKit
import Koloda
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import pop
import FBSDKCoreKit
import FBSDKLoginKit

private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private var numberOfCards: Int = 5

class MyKolodaViewController: UIViewController {

    @IBOutlet weak var kolodaView: CustomKolodaView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var user: FirebaseUser!
    let storageRef = Storage.storage().reference(forURL: "gs://findmydate-1c6f4.appspot.com/")
    let usersRef = Database.database().reference(withPath: "users")
    var users = Array<FirebaseUser>()
    var authListener: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self// as? KolodaViewDelegate
      
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        fetchPhotos() {
            (_: [FirebaseUser]) in
            print("fetched urls")
        }
        createUserInFirebase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let logo = UIImage(named: "FMDIcon")
        let imageView = UIImageView(image:logo)
        //self.navigationItem.titleView = imageView
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navItem.titleView = imageView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(self.authListener)
    }
    
    func createUserInFirebase() {
        
            self.authListener = Auth.auth().addStateDidChangeListener { auth, user in
                guard let user = user else { return }
                self.user = FirebaseUser(authData: user)
                
                // Download facebook profile picture to Firebase Storage
                self.usersRef.child(self.user.uid).setValue(["name": self.user.name, "email": self.user.email,
                                                             "profileURL": self.user.profileURL.absoluteString, "uid": self.user.uid])
                let profilePic = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":300,"width":300,"redirect":false])
                profilePic?.start(completionHandler: {(connection, result, error) -> Void in
                    
                    if(error == nil)
                    {
                        let dictionary = result as? NSDictionary
                        let data = dictionary?.object(forKey: "data")
                        
                        let urlPic = (data as AnyObject).object(forKey: "url") as AnyObject?
                        let url = urlPic as? String ?? ""
                        
                        if let imageData = NSData(contentsOf: NSURL(string: url)! as URL)
                        {
                            let profilePicRef = self.storageRef.child(self.user.uid + "/profile_pic.jpg")
                            let uploadTask = profilePicRef.putData(imageData as Data, metadata:nil){
                                metadata,error in
                                
                                if(error == nil)
                                {
                                    let downloadUrl = metadata!.downloadURL
                                    
                                }
                                else
                                {
                                    print("error in downloading image")
                                }
                            }
     
                        }
                    }
                })
            }
    }
    
    func fetchPhotos(completion: @escaping (Array<FirebaseUser>) -> ()) {
        //DispatchQueue.main.async {
        //var users: Array<FirebaseUser> = []
        self.usersRef.observe(.value, with: {snap in
            var users = Array<FirebaseUser>()
            
            if let snapshots = snap.children.allObjects as? [DataSnapshot] {
                for snapShot in snapshots {
                    guard let getName = snapShot.childSnapshot(forPath: "name").value! as? String else {return}
                    guard let getProfileURL = snapShot.childSnapshot(forPath: "profileURL").value! as? String else {return}
                    let url = NSURL(string: getProfileURL)! as URL
                    guard let getEmail = snapShot.childSnapshot(forPath: "email").value! as? String else {return}
                    guard let getUid = snapShot.childSnapshot(forPath: "uid").value! as? String else {return}
                    let user = FirebaseUser(uid: getUid, email: getEmail, name: getName, profileURL: url)
                    users.append(user)
                    
                    //print(users.count)
                }
            }
            self.users = users
            self.kolodaView.reloadData()
            completion(users)
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        self.kolodaView?.swipe(SwipeResultDirection.left)
    }
    
    @IBAction func rightButtonTapped(_ sender: Any) {
        
        let currentIndex = (kolodaView.currentCardIndex )
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let DvC = Storyboard.instantiateViewController(withIdentifier: "DateViewController") as! DateViewController
        DvC.user = self.users[currentIndex]
        self.navigationController?.pushViewController(DvC, animated: true)
        //self.kolodaView.reloadData()
        print("swiped right")
        kolodaView?.swipe(SwipeResultDirection.right)
        self.kolodaView.reloadData()
        
        
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

extension MyKolodaViewController: KolodaViewDelegate {
    
//    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
//        
//        if direction == .right {
//            print("apple")
//        } else if direction == .left {
//            print("cherry")
//        }
//    }
    
    func kolodaDidSwipeCardAtIndex(_ koloda: KolodaView, index: Int, direction: SwipeResultDirection) {
        print("ahh")
        //DispatchQueue.main.async() {
        if direction == .right {
            print("swiped right")
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let DvC = Storyboard.instantiateViewController(withIdentifier: "DateViewController") as! DateViewController
            DvC.user = self.users[Int(index)]
            self.navigationController?.pushViewController(DvC, animated: true)
            //self.kolodaView.reloadData()
            print("swiped right")
//            DispatchQueue.main.async() {
//                self.kolodaView.reloadData()
//            }
        }
       // }
        //self.kolodaView.reloadData()
        
        
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        //Example: reloading
        kolodaView.resetCurrentCardIndex()
        fetchPhotos() {
            (_: [FirebaseUser]) in
            print("fetched urls")
        }
     
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    

    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation?.springBounciness = frameAnimationSpringBounciness
        animation?.springSpeed = frameAnimationSpringSpeed
        return animation
    }
    
}

extension MyKolodaViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        print(self.users.count)
        return self.users.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let photoView = Bundle.main.loadNibNamed("KolodaPhotoView", owner: self, options: nil)?[0] as? KolodaPhotoView
     
        let user = users[Int(index)]
        let photoImage = photoView?.photoImage
        
        koloda.layer.shadowColor = UIColor.black.cgColor
        koloda.layer.shadowOpacity = 1
        koloda.layer.shadowOffset = CGSize.zero
        koloda.layer.shadowRadius = 10
        koloda.layer.shadowPath = UIBezierPath(rect: (koloda.bounds)).cgPath
        koloda.layer.cornerRadius = 10
        //koloda.clipsToBounds = true
        
        photoView?.clipsToBounds = true
        photoView?.layer.cornerRadius = 10;
        photoView?.layer.masksToBounds = true;
        photoView?.layer.borderWidth = 1
        photoView?.layer.borderColor = UIColor.black.cgColor
        
        photoImage?.clipsToBounds = true
        photoImage?.layer.masksToBounds = false
        
        
        let profilePicRef = self.storageRef.child(user.uid + "/profile_pic.jpg")
        profilePicRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print("an error occurred when downloading profile picture from firebase storage")
            } else {
                let image = UIImage(data: data!)
                photoView?.photoImage.image = image
                //contentView.bringSubview(toFront: photoImage)
                
                //self.tableView.reloadData()
            }
        }
        
        //photoView?.photoImage?.imageFromURL(user.profileURL.absoluteString)
        photoView?.photoTitle?.text = user.name
        print(user.name)
        print(user.profileURL.absoluteString) 
        return photoView!
    }
    
//    func koloda(koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//        return Bundle.main.loadNibNamed("OverlayView",
//                                                  owner: self, options: nil)?[0] as? OverlayView
//    }
}
