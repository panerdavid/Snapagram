//
//  FeedData.swift
//  Snapagram
//
//  Created by Arman Vaziri on 3/8/20.
//  Copyright © 2020 iOSDeCal. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

// Create global instance of the feed
var feed = FeedData()
let db = Firestore.firestore();
let storage = Storage.storage();

class Thread {
    var name: String
    var emoji: String
    var entries: [ThreadEntry]
  
    
    
    init(name: String, emoji: String) {
        self.name = name
        self.emoji = emoji
        self.entries = []
    }
    
    func addEntry(threadEntry: ThreadEntry) {
        entries.append(threadEntry)
     
        //our unique ID key
        let threadEntryID = UUID.init().uuidString;
        
        //saving image to firestore storage
        let storageRef = storage.reference(withPath: "images/\(threadEntryID).jpg");
        guard let imageData = threadEntry.image.jpegData(compressionQuality: 0.75) else {return}
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        storageRef.putData(imageData);
        
        //saving data to database
        var ref: DocumentReference? = nil;
        ref = db.collection("threadEntries").addDocument(data: [
            "threadEntryID": threadEntryID,
            "username": threadEntry.username
        ])
        {err in
            if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                   
                       print("no ID!")
                   }

        }
        
      
    }
    
    
    func removeFirstEntry() -> ThreadEntry? {
        if entries.count > 0 {
            return entries.removeFirst()
        }
        return nil
    }
    
    func unreadCount() -> Int {
        return entries.count
    }
}

struct ThreadEntry {
    var username: String
    var image: UIImage
}

struct Post {
    var location: String
    var image: UIImage?
    var user: String
    var caption: String
    var date: Date
}

class FeedData {
    var username = "panerdavid"
    
    var threads: [Thread] = [
        Thread(name: "memes", emoji: "😂"),
        Thread(name: "dogs", emoji: "🐶"),
        Thread(name: "fashion", emoji: "🕶"),
        Thread(name: "fam", emoji: "👨‍👩‍👧‍👦"),
        Thread(name: "tech", emoji: "💻"),
        Thread(name: "eats", emoji: "🍱"),
    ]

    // Adds dummy posts to the Feed
    var posts: [Post] = [
        Post(location: "New York City", image: UIImage(named: "skyline"), user: "nyerasi", caption: "Concrete jungle, wet dreams tomato 🍅 —Alicia Keys", date: Date()),
        Post(location: "Memorial Stadium", image: UIImage(named: "garbers"), user: "rjpimentel", caption: "Last Cal Football game of senior year!", date: Date()),
        Post(location: "Soda Hall", image: UIImage(named: "soda"), user: "chromadrive", caption: "Find your happy place 💻", date: Date())
    ]
    
    // Adds dummy data to each thread
    init() {
        for thread in threads {
            let entry = ThreadEntry(username: self.username, image: UIImage(named: "garbers")!)
            thread.addEntry(threadEntry: entry)
        }
    }
    
    func addPost(post: Post) {
        posts.append(post)
        let postID = UUID.init().uuidString;
        
        let storageRef = storage.reference(withPath: "images/\(postID).jpg");
        guard let imageData = post.image!.jpegData(compressionQuality: 0.75) else {return}
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        storageRef.putData(imageData);
        
               var ref: DocumentReference? = nil;
               ref = db.collection("Posts").addDocument(data: [
                "postID": postID,
                "postCaption":post.caption,
                "postDate": post.date,
                "postLocation": post.location,
                "postUser": post.user
               ])
               {err in
                   if let err = err {
                          print("Error getting documents: \(err)")
                      } else {
                          
                              print("no ID!")
                          }

               }
               
    }
    
    // Optional: Implement adding new threads!
    func addThread(thread: Thread) {
        threads.append(thread)
    }
}


// write firebase functions here (pushing, pulling, etc.) 
