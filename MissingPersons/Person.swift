//
//  Person.swift
//  MissingPersons
//
//  Created by H on 6/20/16.
//  Copyright © 2016 H. All rights reserved.
//

import UIKit
import ProjectOxfordFace

class Person {
    
    var faceId: String?
    var personImage: UIImage?
    var personImageUrl: String?
    
    init(personImageUrl: String) {
        self.personImageUrl = personImageUrl
    }
    
    // need to get faceId before comparing if the faces are the same
    func downloadFaceId() {
        
        // 0.8 = compression level
        if let img = personImage, let imgData = UIImageJPEGRepresentation(img, 0.8) {
            FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces:[MPOFace]!, err: NSError!) in
                
                if err == nil {
                    var faceId: String?
                    for face in faces {
                        faceId = face.faceId
                        print("Face Id: \(faceId)")
                        
                        break // break out of for loop since we are only assuming there is one face
                              // in the image we are analyzing
                    }
                    
                    self.faceId = faceId
                }
            })
        }
    }
    
}
