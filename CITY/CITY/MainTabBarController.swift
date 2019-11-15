//  ViewController.swift

import UIKit
import Firebase

class MainTabBarController: UITabBarController,UITabBarControllerDelegate{
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    self.view.backgroundColor = .white
    if Auth.auth().currentUser == nil {
      DispatchQueue.main.async {
        let loginController = LoginController()
        let navController = UINavigationController(rootViewController: loginController)
        self.present(navController, animated: true, completion: nil)
      }
      return
    }
    setupViewControllers()
  }
  

  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    let index = viewControllers?.firstIndex(of: viewController)
    if index == 1 {
      if #available(iOS 10.0, *) {
        let postViewController = CameraController()
        let navController = UINavigationController(rootViewController: postViewController)
        present(navController, animated: true, completion: nil)
      }
      else {
        let postViewController = PhotoSelectorController()
        let navController = UINavigationController(rootViewController: postViewController)
        present(navController, animated: true, completion: nil)
        
      }
      return false
    }
    return true
  }
  
  func setupViewControllers() {
    
    let mapViewController = MapViewController()
    let homeNavController = templateNavController(unselectedImage:  #imageLiteral(resourceName: "home_unselected"),selectedImage: #imageLiteral(resourceName: "home_selected"),rootViewController: mapViewController)
    //カメラボタンにする
    let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
    let userProfileNavController = templateNavController(unselectedImage:#imageLiteral(resourceName: "profile_unselected") , selectedImage: #imageLiteral(resourceName: "profile_selected"),rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
    
    tabBar.tintColor = .mainGray()
    viewControllers = [homeNavController,plusNavController,userProfileNavController]
    
    guard let items = tabBar.items else { return }
    for item in items {
      item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
    }
  }
  
  fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
    
    let viewController = rootViewController
    let navController = UINavigationController(rootViewController: viewController)
    navController.tabBarItem.image = unselectedImage
    navController.tabBarItem.selectedImage = selectedImage
    return navController
  }
  
}


