//  User.swift

import Foundation

struct User {
  
  let uid: String
  let username: String
  
  init(uid: String, dictionary: [String: Any]) {
    self.uid = uid
    self.username = dictionary["username"] as? String ?? ""
  }
}
