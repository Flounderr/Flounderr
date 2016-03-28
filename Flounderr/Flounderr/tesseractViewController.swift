//
//  tesseractViewController.swift
//  Flounderr
//
//  Created by Sanaya Sanghvi on 3/22/16.
//  Copyright © 2016 Flounderr. All rights reserved.
//


import UIKit

//Tesseract infor learnt from Ray Wenderlich tutorial

class tesseractViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet var recognisedTextView: UITextView!
    
    var activityIndicator:UIActivityIndicatorView!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //instantiates camera on first glance if camera is available
        if UIImagePickerController.isSourceTypeAvailable(.Camera)
        {
            let instantiateCamera = UIImagePickerController()
            instantiateCamera.delegate = self
            instantiateCamera.sourceType = .Camera
            self.presentViewController(instantiateCamera, animated: true, completion: nil)
        }
        //don't need an else. If no camera, goes to default view. Should this be under view did load?
        //How can I make this more interactive like the snapchat camera?
        //Will look into a tutorial on it.
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //lets you take a picture
    @IBAction func takePhoto(sender: AnyObject) {
        
        let choiceController = UIAlertController(title: "Snap or Upload a Picture?", message: nil, preferredStyle: .ActionSheet)
        
        //in case no camera is available inititially. Also if the person decides to choose a picture, and then decides against it, wanting to click a picture instead. Option should be available
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera)
        {
            let takePictureOption = UIAlertAction(title: "Take photo", style: .Default) { (UIAlertAction) -> Void in
                let instantiateCamera = UIImagePickerController()
                instantiateCamera.delegate = self
                instantiateCamera.sourceType = .Camera
                self.presentViewController(instantiateCamera, animated: true, completion: nil)
            }
            choiceController.addAction(takePictureOption)
        }
        //no else if because you might not always want to snap a picture right?
        //don't need an if for photolibrary, since this is the default option if no camera is available at all
        
        let cameraRollOption = UIAlertAction(title: "Choose from camera Roll", style: .Default) { (UIAlertAction) -> Void in
            let instantiateLibrary = UIImagePickerController()
            instantiateLibrary.delegate = self
            instantiateLibrary.sourceType = .PhotoLibrary
            self.presentViewController(instantiateLibrary, animated: true, completion: nil)
        }
        //even if camera is available library button will always be there
        //adding directly to the function
        
        choiceController.addAction(cameraRollOption)
        
        let cancelOption = UIAlertAction(title: "Cancel", style: .Cancel) { (UIAlertAction) -> Void in
            //automatic cancel stuff
        }
        choiceController.addAction(cancelOption)
        
        //have to present the choice controller or code crashes (obviously)
        presentViewController(choiceController, animated: true, completion: nil)
        
    }
    
    //Activity indicator. Might replace with MBDHUD
    func addActivityIndicator() {
    activityIndicator = UIActivityIndicatorView(frame: view.bounds)
    activityIndicator.activityIndicatorViewStyle = .WhiteLarge
    activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
    activityIndicator.startAnimating()
    view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
    }

    //need to scale image for tesseract
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension // if width is too big, scale width
            scaledSize.height = scaledSize.width * scaleFactor // scale with respect to width. We don't make it equal to maxDimension as that might stretch the image vertically and blur it. There is no min dimension
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension // if height is too big, scale height
            scaledSize.width = scaledSize.height * scaleFactor // aspect ratio thing. Ray Wenderlich explained this formula well
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    func performImageRecognition(image: UIImage)
    {
        let tesseract = G8Tesseract()
        
        tesseract.language = "eng+fra"
        
        
        
        tesseract.engineMode = .CubeOnly
        //Tesseract only = fast but less accurate
        //Cubeo only = slow but more accurate
        //Both combined = more slow but way more accurate which is what we want or maybe not. Takes too much time. Easy text edit makes up for lack of accuracy and more convenience as less time taken and half is already right for them.
        
        tesseract.pageSegmentationMode = .Auto
        
        //detects paragraph -> detects new lines. Could try to make it choose the first line only as title. Then perform a second recogniton or not -> will take too much time. Will test with other modes as well.
        //Once formatted, we could detect what is what or even allow user input to detect. 
        //Like choose title, etc.
        //Date will already be put in if it's only one. If more than one create a start date and end date
        
        tesseract.maximumRecognitionTime = 3*60.0
        //this does practically nothing. TesseractCubeCombined engine will take its own sweet time. If done within 3 minutes, displays entire thing, if not, displays what little it recognise. Might consider reducing time by converting to cube engine. It is pretty accurate as well. And we need some accuracy so cube engine it is. This is why our text is editable.
        
        tesseract.image = image.g8_blackAndWhite()
        //increases contrast and exposure automatically
        
        tesseract.charWhitelist = "01234567890";
        
        tesseract.recognize()// creates recognised text as part of tesseract I think. Also is of type bool. Hmm, further understanding would be cool
        
        recognisedTextView.autocorrectionType = UITextAutocorrectionType.Default
        recognisedTextView.text = tesseract.recognizedText
        recognisedTextView.editable = true
        
        removeActivityIndicator()
        
        
        
    }

    
    //once image picked you want activity indicator to show right?
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        addActivityIndicator()
        
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        let scaledImage = scaleImage(selectedPhoto, maxDimension: 640) // gets modified image returned from the function
        
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
            self.performImageRecognition(scaledImage)
        })
        
        
    }


    //ask question: do you want the user to pick the image, then be able to view picked image in this view controller, and then be able to press a decode button to decode it?
    //or do you want to automatically decode the picture the minute it is chosen?
   
    //will have to add a swap text feature so we can autocorrect after text has been added
    //use swap text feature for dates. If satur- then saturday etc

}
