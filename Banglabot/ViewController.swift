//
//  ViewController.swift
//  scene copy
//
//  Created by Rayhan Mia on 24/8/19.
//  Copyright © 2019 Rayhan Mia. All rights reserved.
//

import UIKit
import SwiftyTesseract
import GPUImage
import MobileCoreServices


class ViewController: UIViewController,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextViewDelegate {
    
    
    
    @IBOutlet weak var textView: UITextView!
    //@IBOutlet weak var imv: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //testing 1
        //var gg = UIImage(named: "b6")!
        //performImageRecognition(gg)
        //tesing 1 end
        
        //testing now retern keyboard (so far working)
        self.setupToHideKeyboardOnTapOnView()
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    //Function for opening camera starts here
    
    @IBAction func openCamera(_ sender: Any) {
        let imgpickerControler = UIImagePickerController()
         imgpickerControler.delegate = self
        
        let actionsheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
           /*
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imgpickerControler.sourceType = .camera;
                //make true if editing required after capturing a photo
                imgpickerControler.allowsEditing = true
                self.present(imgpickerControler, animated: true, completion: nil)
            }
 */
           if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imgpickerControler.sourceType = .camera;
                //make true if editing required after capturing a photo
                imgpickerControler.allowsEditing = true
            
            
                self.present(imgpickerControler, animated: true, completion: nil)
            }
            
            
            
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imgpickerControler.sourceType = .photoLibrary;
                imgpickerControler.allowsEditing = true
                self.present(imgpickerControler, animated: true, completion: nil)
            }
            
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        
        self.present(actionsheet, animated: true, completion: nil)
        
    }
    
    //Function for camera open ends here
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
      //  guard let selectedImage = info[.originalImage] as? UIImage else {
      //      fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
      //  }
        
        let imagess = info[.editedImage] as! UIImage
        dismiss(animated:true, completion: nil)
            performImageRecognition(imagess)

    }
    

    
    // Tesseract Image Recognition coding...
    func performImageRecognition(_ image: UIImage) {
        // TODO: Add more code here...
//        imv.image = image
        //let swiftyTesseract = SwiftyTesseract(language: .bengali)
        let swiftyTesseract = SwiftyTesseract(languages: [.bengali, .english])

        //let scaledImage = image.scaledImage(1000) ?? image
        let preprocessedImage = image.preprocessedImage() ?? image
        
        
        // 1

        //    let scaledImage = image.scaledImage(1000) ?? image
        // let preprocessedImage = scaledImage.preprocessedImage() ?? scaledImage
        //  let preImage = image.preprocessedImage() ?? image
        
        
        swiftyTesseract.performOCR(on: preprocessedImage) {
            recognizedString in
            
            guard let recognizedString = recognizedString else {
                return
            }
            //For testing and printing in the console
           // print("Hi")
            //print("Texts are: \(recognizedString)")
           
            self.textView.text = recognizedString
        }
        activityIndicator.stopAnimating()
        
    }
}
// MARK: - UIImage extension
//1
extension UIImage {
    
    func preprocessedImage() -> UIImage? {
        // 1
        let stillImageFilter = GPUImageAdaptiveThresholdFilter()
        // 2
        stillImageFilter.blurRadiusInPixels = 15.0
        // 3
        let filteredImage = stillImageFilter.image(byFilteringImage: self)
        // 4
        return filteredImage
    }
    // 2
    func scaledImage(_ maxDimension: CGFloat) -> UIImage? {
        func preprocessedImage() -> UIImage? {
            // 1
            let stillImageFilter = GPUImageAdaptiveThresholdFilter()
            // 2
            stillImageFilter.blurRadiusInPixels = 15.0
            // 3
            let filteredImage = stillImageFilter.image(byFilteringImage: self)
            // 4
            return filteredImage
        }
        // 3
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        // 4
        if size.width > size.height {
            scaledSize.height = size.height / size.width * scaledSize.width
        } else {
            scaledSize.width = size.width / size.height * scaledSize.height
        }
        // 5
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // 6
        return scaledImage
    }
}

//For reterning Keyboard when user taps anywhere outside the TextView and Keybaord(Working so far)
extension UIViewController{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}


