//  LoginController.swift

import UIKit
import Firebase
import SVProgressHUD

class LoginController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    navigationItem.title = "ログイン"
    view.addSubview(logoContainerView)
    logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 70, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
    setupInputFields()
    view.addSubview(termsButton)
    termsButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 9, paddingRight: 0, width: 0, height: 20)
  }
  
  func setupInputFields() {
    let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton,dontHaveAccountButton/*,googleLoginButton*/])
    
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.distribution = .fillEqually
    
    view.addSubview(stackView)
    stackView.anchor(top: view.topAnchor, left:view.leftAnchor , bottom: nil, right: view.rightAnchor, paddingTop: 200, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 190)
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
  
  let emailTextField : UITextField = {
    let tf = UITextField()
    tf.placeholder = "メールアドレス"
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 14)
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    return tf
  }()
  
  let passwordTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "パスワード"
    tf.isSecureTextEntry = true
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 14)
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    return tf
  }()
  
  @objc func handleTextInputChange() {
    let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 >= 6
    if isFormValid {
      loginButton.isEnabled = true
      loginButton.backgroundColor = .mainPink()
    } else {
      loginButton.isEnabled = false
      loginButton.backgroundColor = .subPink()
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  let loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("ログイン", for: .normal)
    button.backgroundColor = .subPink()
    button.layer.cornerRadius = 5
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    button.isEnabled = false
    return button
  }()
  
  @objc func handleLogin() {
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    SVProgressHUD.show(withStatus: "ログイン中")
    SVProgressHUD.setDefaultMaskType(.black)
    Auth.auth().signIn(withEmail: email,password: password,completion: { (user,err) in
      if let err = err {
        print("Failed to sign in with email:", err)
        self.alertMessage(message:"メールアドレスまたはパスワードに誤りがあります。")
        SVProgressHUD.dismiss()
        return
      }
      print("Successfully logged back in with user:", user?.uid ?? "")
      
      guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
      mainTabBarController.setupViewControllers()
      SVProgressHUD.dismiss()
      self.dismiss(animated: true, completion: nil)
    })
  }
  
  let dontHaveAccountButton: UIButton = {
    let button = UIButton(type: .system)
    let attributedTitle = NSMutableAttributedString(string: "アカウントを持っていませんか？",attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    attributedTitle.append(NSAttributedString(string: "新規登録", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14) ,NSAttributedString.Key.foregroundColor: UIColor.mainPink()
      ]))
    
    button.setAttributedTitle(attributedTitle, for: .normal)
    button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
    return button
  }()
  
  @objc func handleShowSignUp() {
    let nextController = SignUpController()
    navigationController?.pushViewController(nextController, animated: true)
  }
  
  let termsButton: UIButton = {
    let button = UIButton(type: .system)
    let attributedTitle = NSMutableAttributedString(string: "利用規約を読む",attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    button.setAttributedTitle(attributedTitle, for: .normal)
    button.addTarget(self, action: #selector(handleShowTerms), for: .touchUpInside)
    return button
  }()
  
  @objc func handleShowTerms() {
    let nextController = TermsController()
    navigationController?.pushViewController(nextController, animated: true)
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
