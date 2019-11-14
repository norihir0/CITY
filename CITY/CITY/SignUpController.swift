//  SignUpController.swift

import UIKit
import Firebase
import SVProgressHUD

class SignUpController: UIViewController{
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "新規登録"
    setupInputFields()
    view.addSubview(logoContainerView)
    logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 70, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
    view.backgroundColor = .white
  }
  
  let logoContainerView: UIView = {
    let view = UIView()
    let logo = UIImageView(image: #imageLiteral(resourceName: "CITYlongLogo"))
    logo.contentMode = .scaleAspectFill
    view.addSubview(logo)
    logo.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
    logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    logo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    return view
  }()
  
  let emailTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "メールアドレス"
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 14)
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    return tf
  }()
  
  let usernameTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "ユーザーネーム"
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 14)
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    return tf
  }()
  
  let passwordTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "パスワード(6文字以上）"
    tf.isSecureTextEntry = true
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 14)
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    return tf
  }()
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  let signUpButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("利用規約に同意して登録する", for: .normal)
    button.backgroundColor = .subPink()
    button.layer.cornerRadius = 5
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    button.isEnabled = false
    return button
  }()
  
  @objc func handleTextInputChange() {
    let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 >= 6
    if isFormValid {
      signUpButton.isEnabled = true
      signUpButton.backgroundColor = .mainPink()
    } else {
      signUpButton.isEnabled = false
      signUpButton.backgroundColor = .subPink()
    }
  }
  
  @objc func handleSignUp() {
    guard let email = emailTextField.text, email.count > 0 else { return }
    guard let username = usernameTextField.text, username.count > 0 else { return }
    guard let password = passwordTextField.text, password.count >= 6 else { return }
    SVProgressHUD.show(withStatus: "新規登録中")
    SVProgressHUD.setDefaultMaskType(.black)
    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error: Error?) in
      
      if let err = error {
        print("Failed to create user:", err)
        self.alertMessage(message:"エラーが発生しました")
        SVProgressHUD.dismiss()
        return
      }
      print("Successfully created user:", user?.uid ?? "")
      guard let uid = user?.uid else { return }
      let dictionaryValues = ["username": username]
      let values = [uid: dictionaryValues]
      Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
        if let err = err {
          print("Failed to save user info into db:", err)
          return
        }
        print("Successfully saved user info to db")
        guard let mainTabBarController =
          UIApplication.shared.keyWindow?.rootViewController as?
          MainTabBarController else { return }
        mainTabBarController.setupViewControllers()
        SVProgressHUD.dismiss()
        self.dismiss(animated: true, completion: nil)
      })
    })
  }
  
  let termsButton: UIButton = {
    let button = UIButton(type: .system)
    let attributedTitle = NSMutableAttributedString(string: "登録前に必ず",attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),NSAttributedStringKey.foregroundColor: UIColor.lightGray])
    attributedTitle.append(NSAttributedString(string: "利用規約", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14) ,NSAttributedStringKey.foregroundColor: UIColor.mainPink()
      ]))
    attributedTitle.append(NSAttributedString(string: "をお読みください", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12) ,NSAttributedStringKey.foregroundColor: UIColor.lightGray
      ]))
    button.setAttributedTitle(attributedTitle, for: .normal)
    button.addTarget(self, action: #selector(handleShowTerms), for: .touchUpInside)
    return button
  }()
  
  @objc func handleShowTerms() {
    let nextController = TermsController()
    navigationController?.pushViewController(nextController, animated: true)
  }
  
  fileprivate func setupInputFields() {
    let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, termsButton, signUpButton])
    stackView.distribution = .fillEqually
    stackView.axis = .vertical
    stackView.spacing = 10
    view.addSubview(stackView)
    stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 200, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 240)
  }
  
  func alertMessage(message:String) {
    let alertController = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title:"OK", style: .default, handler:nil)
    alertController.addAction(defaultAction)
    alertController.popoverPresentationController?.sourceView = self.view
    alertController.popoverPresentationController?.sourceRect = CGRect(x: 100.0,y: 100.0,width: 20.0,height: 20.0)
    present(alertController, animated:true, completion:nil)
  }
  
}
