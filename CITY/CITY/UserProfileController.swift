//  UserProfileController.swift
//レイアウト直す
//EmptyState変える
//歯車変える
//

import UIKit
import Firebase
//import GoogleSignIn

class UserProfileController: UICollectionViewController,UICollectionViewDelegateFlowLayout/*,UserProfileCellDelegate*/,UserProfileHeaderDelegate{
  
  let cellId = "cellId"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "マイページ"
    view.backgroundColor = .white
    collectionView?.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1)
    collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
    collectionView?.register(UserProfileCell.self, forCellWithReuseIdentifier: cellId)
    collectionView?.alwaysBounceVertical = true
    setupSettingButton()
    fetchPost()
    handleEmptyState()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    view.backgroundColor = UIColor.white
  }
  
//  func touchEditButton(for cell: UserProfileCell) {
//    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//    alertController.addAction(UIAlertAction(title: "投稿を編集する", style: .default, handler: { (_) in
//      self.editPost(for: cell)
//    }))
//    alertController.addAction(UIAlertAction(title: "投稿を削除する", style: .destructive, handler: { (_) in
//      self.deletePost(for: cell)
//    }))
//    alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
//    alertController.popoverPresentationController?.sourceView = self.view
//    alertController.popoverPresentationController?.sourceRect = CGRect(x: 100.0,y: 100.0,width: 20.0,height: 20.0)
//    present(alertController, animated: true, completion: nil)
//  }
//
//  func editPost(for cell: UICollectionViewCell) {
//    guard let indexPath = collectionView?.indexPath(for: cell) else {return}
//    let post = self.posts[indexPath.item]
//    let alertController = UIAlertController(title: "投稿文の編集", message: "投稿文を編集してください。\n編集前:\(post.caption)", preferredStyle:.alert)
//    alertController.addTextField(configurationHandler: {(text:UITextField!) -> Void in
//    })
//
//    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
//      let textField = alertController.textFields![0] as UITextField
//      print(textField)
//      guard let uid = Auth.auth().currentUser?.uid else {return}
//      guard let newCaption = textField.text else {return} //一文字入力されてる場合のみ有効にする
//      guard let postId = post.id else {return}
//
//      let mvalues = ["caption":newCaption, "creationdate": post.time, "latitude":post.latitude, "longitude":post.longitude] as [String : Any]
//      let values = ["caption":newCaption, "creationdate": post.time, "latitude":post.latitude, "longitude":post.longitude, "mref": post.reference] as [String : Any]
//
//      Database.database().reference().child("posts").child(uid).child(postId).updateChildValues(values, withCompletionBlock: { (err, ref) in
//        if let err = err {
//          print("Failed to save new user info into db:", err)
//          return
//        }
//        print("Successfully saved user info to db")
//
//        let mref = post.reference
//        let autoid = mref.substring(from: mref.index(mref.startIndex, offsetBy: 47))
//
//        Database.database().reference().child("message").child(autoid).updateChildValues(mvalues, withCompletionBlock: { (err, ref) in
//          if let err = err {
//            print("Failed to save new user info into message db:", err)
//            return
//          }
//          print("Successfully saved user info to message db")
//          self.posts.removeAll()
//          self.fetchPost()
//        })
//      })
//    }))
//    alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
//    alertController.popoverPresentationController?.sourceView = self.view
//    alertController.popoverPresentationController?.sourceRect = CGRect(x: 100.0,y: 100.0,width: 20.0,height: 20.0)
//    present(alertController, animated:true, completion:nil)
//  }
  
//  func deletePost(for cell: UICollectionViewCell) {
//    guard let indexPath = collectionView?.indexPath(for: cell) else { return }
//    let post = self.posts[indexPath.item]
//    print("remove"+"\(post.caption)")
//    guard let postId = post.id else { return }
//    guard let uid = Auth.auth().currentUser?.uid else { return }
//    let mref = post.reference
//    let autoid = mref.substring(from: mref.index(mref.startIndex, offsetBy: 42))
//    let alertController = UIAlertController(title: "投稿を削除", message: "本当にこの投稿を削除してよろしいですか？", preferredStyle: .alert)
//    alertController.addAction(UIAlertAction(title: "削除", style: .destructive, handler: { (_) in
//      Database.database().reference().child("posts").child(uid).child(postId).removeValue()
//      Database.database().reference().child("message").child(autoid).removeValue()
//      self.posts.removeAll()
//      self.fetchPost()
//    }))
//    alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
//    alertController.popoverPresentationController?.sourceView = self.view
//    alertController.popoverPresentationController?.sourceRect = CGRect(x: 100.0,y: 100.0,width: 20.0,height: 20.0)
//    present(alertController, animated: true, completion: nil)
//  }
  
  func tapProfileEditButton() {
    let alertController = UIAlertController(title: "プロフィールの編集", message: "新しいユーザーネームを入力してください。", preferredStyle:.alert)
    alertController.addTextField(configurationHandler: {(text:UITextField!) -> Void in
    })
    alertController.addAction(UIAlertAction(title: "登録", style: .default, handler: { (_) in
      let textField = alertController.textFields![0] as UITextField
      print(textField)
      guard let uid = Auth.auth().currentUser?.uid else { return }
      guard let newName = textField.text else {return}
      let value = ["username": newName]
      Database.database().reference().child("users").child(uid).updateChildValues(value, withCompletionBlock: { (err, ref) in
        if let err = err {
          print("Failed to save new user info into db:", err)
          return
        }
        print("Successfully saved user info to db")
        UserProfileHeader().usernameLabel.text = textField.text!
      })
    }))
    alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
    alertController.popoverPresentationController?.sourceView = self.view
    alertController.popoverPresentationController?.sourceRect = CGRect(x: 100.0,y: 100.0,width: 20.0,height: 20.0)
    present(alertController, animated:true, completion:nil)
  }
  
  func handleEmptyState() {
    if posts.count == 0 {
      view.addSubview(emptylogoContainerView)
      emptylogoContainerView.anchor(top: nil, left: view.leftAnchor, bottom: bottomLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 140, paddingRight: 0, width: 0, height: 0)
    }else if posts.count >= 1{
      emptylogoContainerView.isHidden = true
    }
  }
  
  let emptylogoContainerView: UIView = {
    let view = UIView()
    let logo = UIImageView(image: #imageLiteral(resourceName: "xmark")) //error?
    logo.contentMode = .scaleAspectFill
    view.addSubview(logo)
    logo.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)
    logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    logo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    return view
  }()
  
  var posts = [Post](){
    didSet {
      handleEmptyState()
    }
  }
  
  fileprivate func fetchPost(){
    guard let uid = Auth.auth().currentUser?.uid else {return}
    let ref = Database.database().reference().child("posts").child(uid)
    ref.observe(.childAdded, with: { (snapshot) in
      guard let dictionary = snapshot.value as? [String: Any] else {return}
      var post = Post(dictionary: dictionary)
      post.id = snapshot.key
      self.posts.append(post)
      self.posts.sort(by: { (p1, p2) -> Bool in
        return p1.creationDate.compare(p2.creationDate as Date) == .orderedDescending
      })
      self.collectionView?.reloadData()
    })
    { (err) in
      print("Faild to fetch  post:", err)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.posts.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfileCell
    cell.post = posts[indexPath.item]
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let squareWidth = (view.frame.width - 20) / 3
    return CGSize(width: squareWidth, height: squareWidth)
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
    header.delegate = self
    return header
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: view.frame.width, height: 160)
  }
  
  fileprivate func setupSettingButton() {
    let image = #imageLiteral(resourceName: "profile_unselected").withRenderingMode(.alwaysOriginal)
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleSetting) )
  }
  
  @objc func handleSetting() {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    alertController.addAction(UIAlertAction(title: "利用規約", style: .default, handler: { (_) in
      self.hidesBottomBarWhenPushed = true
      let nextController = TermsController()
      self.navigationController?.pushViewController(nextController, animated: true)
      self.hidesBottomBarWhenPushed = false
    }))
    alertController.addAction(UIAlertAction(title: "ログアウト", style: .destructive, handler: { (_) in
      do {
        try Auth.auth().signOut()
        let loginController = LoginController()
        let navController = UINavigationController(rootViewController: loginController)
        self.present(navController, animated: true, completion: nil)
      } catch let signOutErr {
        print("Failed to sign out:", signOutErr)
      }
    }))
    alertController.addAction(UIAlertAction(title: "退会する", style: .destructive, handler: { (_) in
      self.handleWithdraw()
    }))
    alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
    alertController.popoverPresentationController?.sourceView = self.view
    alertController.popoverPresentationController?.sourceRect = CGRect(x: 100.0,y: 100.0,width: 20.0,height: 20.0)
    present(alertController, animated: true, completion: nil)
  }
  
  func handleWithdraw() {
    let currentUser = Auth.auth().currentUser
    guard let uid = currentUser?.uid else {return}
    let ref = Database.database().reference().child("posts").child(uid)
    let alertController = UIAlertController(title: "退会する", message: "本当に退会しますか？\n退会するとユーザー情報・投稿データが全て削除されます。", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "退会", style: .destructive, handler: { (_) in
      
      //したのAuthデリートのとこいれたらuid取得できす投稿が消せなかった。
      ref.observe(.childAdded, with: { (snapshot) in
        
        guard let dictionary = snapshot.value as? [String: Any] else {return}
        
        let post = Post(dictionary: dictionary)
        let mref = post.reference
        let autoid = mref[..<mref.index(mref.startIndex, offsetBy: 47)]
        Database.database().reference().child("message").child(String(autoid)).removeValue()
        
      })
      { (err) in
        print("Faild to fetch  post:", err)
      }
      
      Database.database().reference().child("posts").child(uid).removeValue()
      Database.database().reference().child("users").child(uid).removeValue()
      
      currentUser?.delete { error in
        if let error = error {
          print("退会失敗",error)
        } else {
          print("退会完了")
          
          let signUpController = SignUpController()
          let navController = UINavigationController(rootViewController: signUpController)
          self.present(navController, animated: true, completion: nil)
        }
      }
    }))
    alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
    alertController.popoverPresentationController?.sourceView = self.view
    alertController.popoverPresentationController?.sourceRect = CGRect(x: 100.0,y: 100.0,width: 20.0,height: 20.0)
    present(alertController, animated: true, completion: nil)
  }
  

  
}
