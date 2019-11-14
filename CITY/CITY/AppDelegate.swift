//  AppDelegate.swift

import UIKit
import Firebase
import GoogleMaps
//import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder,UIApplicationDelegate/*,GIDSignInDelegate*/{
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
//    GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//    GIDSignIn.sharedInstance().delegate = self
    GMSServices.provideAPIKey("AIzaSyDq8LHXDykJvrs-e-YPBF6zJH9nRvxi-Ow")
    window = UIWindow()
    window?.rootViewController = MainTabBarController()
    return true
  }
  
//  @available(iOS 9.0, *)
//  func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
//    -> Bool {
//      return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
//  }
//
//  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//    return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
//  }
//
//  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
//
//    guard let username = user.profile.name else {return}
//    let authentication = user.authentication
//    let credential = GoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
//    Auth.auth().signIn(with: credential) { user, error in
//      if let error = error {
//        print("DEBUG_PRINT: " + error.localizedDescription)
//        return
//      }
//      guard let uid = user?.uid else {return}
//      let dictionaryValues = ["username": username ]
//      let values = [uid: dictionaryValues]
//      Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
//        if let err = err {
//          print("Failed to save user info into db:", err)
//          return
//        }
//        print("Successfully saved user info to db")
//      })
//      self.window = UIWindow(frame: UIScreen.main.bounds)
//      self.window!.rootViewController = MainTabBarController()
//      self.window!.makeKeyAndVisible()
//    }
//  }
//
//  func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//  }

  func applicationWillResignActive(_ application: UIApplication) {
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
  }
  
}

