//  UserProfileHeader.swift
//歯車変える

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
  func tapProfileEditButton()
}

class UserProfileHeader: UICollectionViewCell{
  
  var delegate: UserProfileHeaderDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    fetchUser()
    backgroundColor = .white
    addSubview(usernameLabel)
    usernameLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    usernameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    addSubview(editProfileButton)
    editProfileButton.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 90, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    editProfileButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    
    let bottomDividerView = UIView()
    bottomDividerView.backgroundColor = UIColor.lightGray
    addSubview(bottomDividerView)
    bottomDividerView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
  }
  
  var user: User?
  public func fetchUser() {
    
    guard let uid =  Auth.auth().currentUser?.uid else {return}
    Database.fetchUserWithUID(uid: uid) { (user) in
      self.user = user
      self.usernameLabel.text = self.user?.username
      
    }
  }
  
  let usernameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    return label
  }()
  
  //これはoverride initしたらついてくるやつ
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var editProfileButton: UIButton = {
    let button = UIButton(type:.system)
    button.setTitle("      プロフィールを編集      ", for: .normal)
    button.setTitleColor(.mainGray(), for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
    button.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 245) //マップのベースカラーと同色
    button.layer.borderWidth = 0
    button.layer.cornerRadius = 7
    button.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
    return button
  }()
  
  @objc func handleEditProfile() {
    print("プロフィール編集")
    delegate?.tapProfileEditButton()
  }
  
}
