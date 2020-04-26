//
//  FeedViewController.swift
//  Snapagram
//
//  Created by Arman Vaziri on 3/8/20.
//  Copyright © 2020 iOSDeCal. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var threadCollectionView: UICollectionView!
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var captionTextField: UITextField!
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var chosenImageView: UIImageView!
    var chosenImage: UIImage!
    var choice = 0;
    var chosenThread = feed.threads[0];
    var threadEntry = ThreadEntry(username: feed.username, image: UIImage());
   

    
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           threadCollectionView.delegate = self
           threadCollectionView.dataSource = self
           chosenImageView.image = chosenImage;

       }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
              return feed.threads.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
               let thread = feed.threads[index]
               
               if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "threadCell", for: indexPath) as? ThreadCollectionViewCell {
                   cell.threadEmojiLabel.text = thread.emoji
                   cell.threadNameLabel.text = thread.name
                   cell.threadUnreadCountLabel.text = String(thread.unreadCount())
                   
                   cell.threadBackground.layer.cornerRadius =  cell.threadBackground.frame.width / 2
                   cell.threadBackground.layer.borderWidth = 3
                   cell.threadBackground.layer.masksToBounds = true
                   
                   cell.threadUnreadCountLabel.layer.cornerRadius = cell.threadUnreadCountLabel.frame.width / 2
                   cell.threadUnreadCountLabel.layer.masksToBounds = true
                   
                   if thread.unreadCount() == 0 {
                       cell.threadUnreadCountLabel.alpha = 0
                   } else {
                       cell.threadUnreadCountLabel.alpha = 1
                   }
                   
                   return cell
               } else {
                   return UICollectionViewCell()
               }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           // segue to preview controller with selected thread
           chosenThread = feed.threads[indexPath.item]
           threadEntry = ThreadEntry(username: feed.username, image: chosenImage);
           choice = 1;
           
       }

    
//     Post(location: "New York City", image: UIImage(named: "skyline"), user: "nyerasi", caption: "Concrete jungle, wet dreams tomato 🍅 —Alicia Keys", date: Date())
    
    @IBAction func createPost(_ sender: Any) {
        
        if (choice == 0) {
        let location = locationTextField.text!
        let image = chosenImage
        let caption = captionTextField.text!
        let date = Date();
        let user = feed.username
        let post = Post(location: location, image: image, user: user, caption: caption, date: date);
        feed.addPost(post: post);
    }
        else {
            chosenThread.addEntry(threadEntry: threadEntry);
        }
         self.navigationController?.popToRootViewController(animated: true)
         chosenImageView.image = nil;
    }
    
    
    
}

