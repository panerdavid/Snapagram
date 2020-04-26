//
//  CameraViewController.swift
//  Snapagram
//
//  Created by RJ Pimentel on 3/11/20.
//  Copyright © 2020 iOSDeCal. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagePickerController = UIImagePickerController();

    @IBOutlet weak var selectCamera: UIButton!
    @IBOutlet weak var selectPhoto: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var postButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePickerController.delegate = self;
        //call when want to present imagepickercontroller
        self.postButton.isHidden = true;

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cameraSelected(_ sender: Any) {
        self.imagePickerController.sourceType = .camera;
        present(imagePickerController, animated: true, completion: nil);

    }
    
    @IBAction func photoSelected(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary;
        present(imagePickerController, animated: true, completion: nil);
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image;
             
            
        }
        imagePickerController.dismiss(animated: true, completion: nil);
         self.postButton.isHidden = false;

}
    @IBAction func makePost(_ sender: Any?) {
        let chosenImage = imageView.image;
           performSegue(withIdentifier: "uploadSegue", sender: chosenImage);
           imageView.image = nil;
       }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? UploadViewController, let chosenImage = sender as? UIImage  {
            dest.chosenImage = chosenImage;
        }
    }
    
    
    


   
}
