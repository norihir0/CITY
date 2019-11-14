//  Extentions.swift

import UIKit
import Firebase

extension UIView {
  
  func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
    
    translatesAutoresizingMaskIntoConstraints = false
    
    if let top = top {
      self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
    }
    
    if let left = left {
      self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
    }
    
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
    }
    
    if let right = right {
      rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
    }
    
    if width != 0 {
      widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    if height != 0 {
      heightAnchor.constraint(equalToConstant: height).isActive = true
    }
  }
  
}

extension UIColor {
  
  static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
  }
  
  static func mainPink() -> UIColor {
    return UIColor.rgb(red: 252, green: 102, blue: 104)
  }
  
  static func subPink() -> UIColor {
    return UIColor.rgb(red: 255, green: 211, blue: 225)
  }
  
  static func mainGray() -> UIColor {
    return UIColor.rgb(red: 99, green: 99, blue: 99)
  }
  
}

extension Database {
  static func fetchUserWithUID(uid: String ,completion: @escaping (User) -> ()){
    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
      
      guard let  userDictionary = snapshot.value as? [String: Any] else { return }
      
      let user = User(uid: uid, dictionary: userDictionary)
      
      completion(user)
      
    }) { (err) in
      print("Failed to fetch user for posts",err)
    }
  }
}
