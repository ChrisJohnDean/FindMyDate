//
//  KolodaPhotoView.swift
//  FindMyDate
//
//  Created by Chris Dean on 2017-08-16.
//  Copyright © 2017 Chris Dean. All rights reserved.
//

import UIKit

extension UIImageView {
    public func imageFromURL(_ urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data)
                self.image = image 
            })
            
        }).resume()
    }
}

class KolodaPhotoView: UIView {

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var photoTitle: UILabel!

}
