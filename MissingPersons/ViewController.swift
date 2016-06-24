//
//  ViewController.swift
//  MissingPersons
//
//  Created by H on 5/25/16.
//  Copyright © 2016 H. All rights reserved.
//

import UIKit
import ProjectOxfordFace

let baseURL = "http://localHost:6069/img/"

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedImg: UIImageView!
    
    var selectedPerson: Person?
    var hasSelectedImage: Bool = false
    
    let imagePicker = UIImagePickerController()
    
    let missingPeople = [
        
        Person(personImageUrl:"person10.jpg"),
        Person(personImageUrl:"person11.jpg"),
        Person(personImageUrl:"person3.jpg"),
        Person(personImageUrl:"person2.jpg"),
        Person(personImageUrl:"person5.jpg"),
        Person(personImageUrl:"person6.jpg")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        imagePicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(loadPicker(_:)))
        tap.numberOfTapsRequired = 1
        selectedImg.addGestureRecognizer(tap)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missingPeople.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonCell", forIndexPath: indexPath) as! PersonCell
        
        let person = missingPeople[indexPath.row]
        cell.configureCell(person)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedPerson = missingPeople[indexPath.row]
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PersonCell
        cell.configureCell(selectedPerson!)
        cell.setSelected()
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // grabbing the photo that was just selected
        // setting the black profile image to the one that was selected 
        
        if let pickedImage  = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImg.image = pickedImage
            hasSelectedImage = true
        }
        
        // after an image is selected, must dismiss camera roll view
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadPicker(gesture: UITapGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        // if you want to do it with a photo you take from camera
        // change imagePicker.sourceType = .Camera
        // however, this will crash the simulator 
        // need to add more code to resolve this 
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func showErrorAlert() {
        
        // if selected image or uploaded image is missing
        // show popup and ask user to select both
        
        let alert = UIAlertController(title: "Select Person & Image", message: "Please select a missing person and upload an image to check", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func showMatchAlert() {
        
        let alert = UIAlertController(title: "It is a match!", message: "The person in your image and the one you selected are the same", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func showNoMatchAlert() {
        
        let alert = UIAlertController(title: "It is not a match", message: "The person in your image and the one selected are not the same", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func checkMatch(sender: AnyObject) {
        if selectedPerson == nil || hasSelectedImage == false {
            showErrorAlert()
        } else {
            if let myImg = selectedImg.image, let imgData = UIImageJPEGRepresentation(myImg, 0.8) {
                FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: {(faces: [MPOFace]!, err: NSError!) in
                    
                    if err == nil {
                        var faceId: String?
                        for face in faces {
                            faceId = face.faceId
                            break
                        }
                        
                        if faceId != nil  {
                            FaceService.instance.client.verifyWithFirstFaceId(self.selectedPerson!.faceId, faceId2:faceId, completionBlock: {
                                (result: MPOVerifyResult!, err:NSError!) in
                                
                                if err == nil {
                                    print(result.confidence)
                                    print(result.isIdentical)
                                    print(result.debugDescription)
                                    
                                    if Double(result.confidence) > 0.5 {
                                        self.showMatchAlert()
                                    } else {
                                        
                                        self.showNoMatchAlert()
                                    }
                                } else {
                                    print(err.debugDescription)
                                }
                            })
                        }
                    }
                    
                })
            }
        }
    }

}

