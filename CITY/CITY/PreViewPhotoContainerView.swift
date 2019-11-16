//  PreViewPhotoContainerView.swift
//カメラロールからの導線
//テキスト位置直す
//配置直す

import UIKit
import CoreLocation
import Photos
import Firebase
import SVProgressHUD

class PreviewPhotoContainerView: UIView, UITextViewDelegate{
  
  var latitude: String! = ""
  var longitude: String! = ""
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.textView.delegate = self
    backgroundColor = .black
    
    addSubview(previewImageView)
    previewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 70, paddingLeft: 0, paddingBottom: 85, paddingRight: 0, width: 0, height: 0)
    //レイアウト微調整
    addSubview(proceedButton)
    proceedButton.anchor(top: nil, left: nil, bottom: previewImageView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 27, paddingRight: 27, width: 30, height: 30)
    
    addSubview(cancelButton)
    cancelButton.anchor(top: nil, left: leftAnchor, bottom: previewImageView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 27, paddingBottom: 27, paddingRight: 0, width: 30, height: 30)

    
    setupTextViews()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  let previewImageView: UIImageView = {
    let iv = UIImageView()
    return iv
  }()
  
  let proceedButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "proceedButton").withRenderingMode(.alwaysOriginal), for: .normal)
    button.tintColor = UIColor.white
    button.addTarget(self, action: #selector(handleProceed), for: .touchUpInside)
    return button
  }()
  
  let textView: UITextView = {
    let tv = UITextView()
    tv.font = UIFont.systemFont(ofSize: 16)
    tv.textColor = .white
    tv.backgroundColor = .none
    return tv
  }()
  
  let placeholder:UILabel = {
    let label = UILabel()
    label.text = "なにがありましたか？"
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 16)
    return label
  }()
  
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
  {
    placeholder.isHidden = true
    return true
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if(textView.text.isEmpty){
      placeholder.isHidden = false
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.endEditing(true)
  }
  
  fileprivate func setupTextViews() {
    let containerView = UIView()
    containerView.backgroundColor = .black
    containerView.alpha = 0.3
    addSubview(containerView)
    containerView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 70, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
    containerView.sendSubviewToBack(textView)
    
    addSubview(textView)
    textView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    
    addSubview(placeholder)
    placeholder.anchor(top: textView.topAnchor, left: textView.leftAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
  }
  
  let cancelButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "reloadButton").withRenderingMode(.alwaysOriginal), for: .normal)
    button.tintColor = UIColor.white
    button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    return button
  }()
  
  @objc func handleProceed() {
    guard let postImage = previewImageView.image else { return }
    
    SVProgressHUD.show(withStatus: "投稿中")
    SVProgressHUD.setDefaultMaskType(.black)
    let library = PHPhotoLibrary.shared()
    library.performChanges({
      PHAssetChangeRequest.creationRequestForAsset(from: postImage)
    })
    
    guard let uploadData = postImage.jpegData(compressionQuality: 0.5) else { return }
    
    let filename = NSUUID().uuidString
    Storage.storage().reference().child("posts").child(filename).putData(uploadData, metadata: nil)
    { ( metadata, err) in
      
      if let err = err {
        print("Failed to upload post image", err)
        return
      }
      
      guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
      print("Successfully uploaded post image", imageUrl)
      
      self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
    }
  }
  
  fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
    
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    let userPostRef = Database.database().reference().child("posts").child(uid)
    let messageUserPostRef = Database.database().reference().child("message")
    let ref = userPostRef.childByAutoId()
    
    let mref = messageUserPostRef.childByAutoId()
    let time = NSDate.timeIntervalSinceReferenceDate
    
    let values = ["creationdate": String(time), "caption": "\(textView.text!)", "imageUrl": imageUrl, "latitude":latitude ?? "20", "longitude":longitude ?? "30", "mref": "\(mref)"] as [String : Any]
    let mvalues = ["creationdate": String(time), "caption": "\(textView.text!)", "imageUrl": imageUrl, "latitude":latitude ?? "20", "longitude":longitude ?? "30",] as [String : Any]
    
    ref.updateChildValues(values) { (err, ref) in
      if let err = err {
        print("Failed to save post to DB", err)
        return
      }
      mref.updateChildValues(mvalues){( err, mref) in
        if let err = err {
          print("Failed to save post to DB", err)
          return
        }
        print("Successfully saved post to DB")
      }
      SVProgressHUD.showSuccess(withStatus: "投稿しました！")
      self.removeFromSuperview()
      SVProgressHUD.dismiss(withDelay: 0.85)
    }
  }
  
  @objc func handleCancel() {
    guard let previewImage = previewImageView.image else { return }
    let library = PHPhotoLibrary.shared()
    library.performChanges({
      PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
    })
    self.removeFromSuperview()
  }
  
}

