//  ContentController.swift

import UIKit
import Foundation
import Firebase

class ContentController: UIViewController{
  
  var text = ""
  var date = ""
  var imageUrl = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(captionTextView)
    captionTextView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 80, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 200)
    captionTextView.text = text
    
    view.addSubview(dateTextView)
    dateTextView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 200, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
    dateTextView.text = date
    
    view.addSubview(cancelButton)
    cancelButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
    
    view.addSubview(imageView)
    imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    self.view.sendSubviewToBack(imageView)
    
    var post: Post? {
      didSet {
        guard let imageUrl = post?.imageUrl else { return }
        imageView.loadImage(urlString: imageUrl)
      }
    }
    //showPhoto()
//    UITabBar.appearance().tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
//    UITabBar.appearance().barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1)
  }

//  func showPhoto() {
//    self.imageView.loadImage(urlString: imageUrl)
//    //print(self.imageUrl)
//    { (err) in
//      print("Failed to fetch posts:", err)
//    }
//  }
  
  let imageView: CustomImageView = {
    let iv = CustomImageView()
    //iv.loadImage(urlString: imageUrl)
    //iv.image = UIImage(named:"view1")!.withRenderingMode(.alwaysOriginal)
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()
  
  let captionTextView: UITextView = {
    let textView = UITextView()
    textView.font = UIFont.systemFont(ofSize: 20)
    textView.backgroundColor = UIColor(red:0.0,green:0.0,blue:0.0,alpha:0.5)
    
    textView.textColor = .white
    textView.isEditable = false
    return textView
  }()
  
  let dateTextView: UITextView = {
    let textView = UITextView()
    textView.font = UIFont.systemFont(ofSize: 14)
    textView.backgroundColor = .none
    textView.textColor = .white
    textView.isEditable = false
    return textView
  }()
  
  let cancelButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = .white
    button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    return button
  }()

  @objc func handleCancel() {
    self.navigationController?.popViewController(animated: true)
  }
  
}


