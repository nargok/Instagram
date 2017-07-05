//
//  PostData.swift
//  Instagram
//
//  Created by 後閑諒一 on 2017/06/15.
//  Copyright © 2017年 ryoichi.gokan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostData: NSObject {
    var id: String?
    var image: UIImage?
    var imageString: String?
    var name: String?
    var caption: String?
    var date: NSDate?
    var likes: [String] = []
    var isLiked: Bool = false
    typealias comment = Dictionary<String, String>
    var comments: [comment] = []
    
    init(snapshot: FIRDataSnapshot, myId: String) {
    
        
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: AnyObject]

        print("DEBUG PRINT: \(valueDictionary["comments"])")
        
        imageString = valueDictionary["image"] as? String
        image = UIImage(data: NSData(base64Encoded: imageString!, options: .ignoreUnknownCharacters)! as Data)
        
        self.name = valueDictionary["name"] as? String
        
        self.caption = valueDictionary["caption"] as? String
        
        let time = valueDictionary["time"] as? String
        self.date = NSDate(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        
        if let likes = valueDictionary["likes"] as? [String] {
            self.likes = likes
        }
        
        for likeId in self.likes {
            if likeId == myId {
                self.isLiked = true
                break
            }
        }
        //　コメントを格納
        if let comments = valueDictionary["comments"]{
            print("Test Pint3: \(comments)")
            self.comments = comments as! [PostData.comment]
        }
    }
    
}
