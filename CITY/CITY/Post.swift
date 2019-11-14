//  Post.swift

import Foundation

struct Post {
  
  var id: String?
  var caption: String
  let creationDate: NSDate
  var latitude: String
  var longitude: String
  var reference:String
  var time: String
  var imageUrl: String
  
  init(dictionary: [String:Any]) {
    
    self.latitude = dictionary["latitude"] as? String ?? ""
    
    self.longitude = dictionary["longitude"] as? String ?? ""
    
    self.caption = dictionary["caption"] as? String ?? ""
    
    let atime = dictionary["creationdate"] as? String
    self.time = atime!
    self.creationDate = NSDate(timeIntervalSinceReferenceDate: TimeInterval(atime!)!)
    
    self.reference = dictionary["mref"] as? String ?? ""
    
    self.imageUrl = dictionary["imageUrl"] as? String ?? ""
  }
}
