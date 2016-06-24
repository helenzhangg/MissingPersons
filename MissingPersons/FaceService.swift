//
//  FaceService.swift
//  MissingPersons
//
//  Created by H on 6/20/16.
//  Copyright © 2016 H. All rights reserved.
//

import Foundation
import ProjectOxfordFace

class FaceService {
    static let instance = FaceService()
    
    let client = MPOFaceServiceClient(subscriptionKey: "e018a4c9871f4a01af5e9e61e33c62d4")
}
