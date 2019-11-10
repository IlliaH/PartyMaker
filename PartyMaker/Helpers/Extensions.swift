//
//  Extensions.swift
//  PartyMaker
//
//  Created by  Ilia Goncharenko on 2019-11-09.
//  Copyright © 2019 711Development. All rights reserved.
//

import Foundation
import UIKit

// Download image from url extension
extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIView.ContentMode) {
        // set image to nil if exist
        self.image = nil
        // create a UIActivityIndicatorView with the
        let ai = UIActivityIndicatorView(frame: self.frame)
        // Add the UIActivityIndicatorView as a subview on the cell
        self.superview?.addSubview(ai)
        // Start the UIActivityIndicatorView animating
        ai.startAnimating()
        // Load the remote image
        URLSession.shared.dataTask( with: URL(string:link)!, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data {
                    ai.stopAnimating()
                    ai.removeFromSuperview()
                    self.image = UIImage(data: data)
                }
            }
        }).resume()
    }
}
