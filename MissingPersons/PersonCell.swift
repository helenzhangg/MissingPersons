//
//  PersonCell.swift
//  MissingPersons
//
//  Created by H on 6/1/16.
//  Copyright © 2016 H. All rights reserved.
//

import UIKit

class PersonCell: UICollectionViewCell {
    
    @IBOutlet weak var personImage:UIImageView!
    var person: Person!
    
    // download the image from the internet and pass it through the image view
    
    func configureCell(person: Person) {
        
        self.person = person
        if let url = NSURL(string: "\(baseURL)\(person.personImageUrl!)") {
            
            downloadImage(url)
        }
    }
    
    func downloadImage(url: NSURL) {
        
        getDataFromUrl(url) { (data, response, error) in
            // always manipulate data on the main thread
            
            // if there is data and if there is no error 
            // then shove data into the let
            // otherwise, go into else clause and return / blank image 
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.personImage.image = UIImage(data: data)
                self.person.personImage = self.personImage.image
                
                // UImage(data: data) refers to let data = data
            }
        }
    }

    func getDataFromUrl(url: NSURL, completion: ((data:NSData?, response: NSURLResponse?, error:NSError?) -> Void)) {
        
        // make calls through dataTaskWithURL to throw it on a backend thread
        // once data is retrieved put it on mainUI thread 
        
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
        }.resume()
    }
    
    func setSelected() {
        // highlighting a selected image with a border
        
        personImage.layer.borderWidth = 4.0
        personImage.layer.borderColor = UIColor.purpleColor().CGColor
        
        // after an image is picked, then retrieve imageId for selection
        
        self.person.downloadFaceId()
    }
}

