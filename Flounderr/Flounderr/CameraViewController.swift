//
//  CameraViewController.swift
//  Flounderr
//
//  Created by Ha Nuel Lee on 3/31/16.
//  Copyright © 2016 Flounderr. All rights reserved.
//

import UIKit
import TesseractOCR

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate {
    
    let tesseract:G8Tesseract = G8Tesseract(language: "eng")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let vc = UIImagePickerController()
        vc.delegate = self

        vc.allowsEditing = true
        // If camera is available, use camera as the source type
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            vc.sourceType = UIImagePickerControllerSourceType.Camera
        }
        else { // Use photo library as source type
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        // Tesseract stuff
        tesseract.delegate = self
        tesseract.charWhitelist = "01234567890"
        tesseract.engineMode = .CubeOnly
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images
        tesseract.image = originalImage
        
        tesseract.recognize()
        print("Recognized: \(tesseract.recognizedText)")
        dismissViewControllerAnimated(true) { 
            self.performSegueWithIdentifier("eventDetailSegue", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
