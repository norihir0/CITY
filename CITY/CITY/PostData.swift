//  PostData.swift

import Foundation

struct PostData {
  
  var caption: String
  let creationDate: NSDate
  var latitude: String
  var longitude: String
  var imageUrl: String
  
  init(dictionary: [String:Any]) {
    
    self.latitude = dictionary["latitude"] as? String ?? ""
    
    self.longitude = dictionary["longitude"] as? String ?? ""
    
    self.caption = dictionary["caption"] as? String ?? ""
    
    let time = dictionary["creationdate"] as? String
    self.creationDate = NSDate(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
    
    self.imageUrl = dictionary["imageUrl"] as? String ?? ""
  }
}
