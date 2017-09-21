//
//  AcceptedDateViewController.swift
//  FindMyDate
//
//  Created by Chris Dean on 2017-09-15.
//  Copyright © 2017 Chris Dean. All rights reserved.
//

import UIKit

class AcceptedDateViewController: UIViewController {

    @IBOutlet weak var acceptedView: AcceptedDateView!
    var match: Match!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        acceptedView.location.text = match?.location
        acceptedView.matchName.text = match?.suitorsName
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
