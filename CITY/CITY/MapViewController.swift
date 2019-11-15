//  MapViewController.swift

import UIKit
import CoreLocation
import Firebase
import GoogleMaps
import MessageUI

class MapViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,MFMailComposeViewControllerDelegate{
  
  var mapManager: CLLocationManager = CLLocationManager()
  var latitude: CLLocationDegrees! = CLLocationDegrees()
  var longitude: CLLocationDegrees! = CLLocationDegrees()
  var pinView: UIImageView?
  var markers: [GMSMarker] = []
  var gmap = GMSMapView()
  var posts = [PostData]()
  var imageUrl: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.isNavigationBarHidden = true
    mapManager.delegate = self
    mapManager.desiredAccuracy = kCLLocationAccuracyBest
    mapManager.distanceFilter = 1000
    view.backgroundColor = .white
    gmapSetting()
    showPosts()
  }
  
  func gmapSetting() {
    gmap.isMyLocationEnabled = true
    gmap.settings.compassButton = true
    gmap.settings.myLocationButton = true
    view.addSubview(gmap)
    gmap.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: bottomLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    do {
      if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
        gmap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
      } else {
        NSLog("Unable to find MapStyle.json")
      }
    } catch {
      NSLog("One or more of the map styles failed to load. \(error)")
    }
    
    gmap.delegate = self
  }
  
  func showPosts() {
    let postsRef = Database.database().reference().child("message")
    postsRef.observe(.childAdded, with: { snapshot in
      guard let dictionary = snapshot.value as? [String: Any] else {return}
      let postData = PostData(dictionary: dictionary)
      self.posts.append(postData)
      self.makeMarker(postData: postData)
    })
    { (err) in
      print("Failed to fetch posts:", err)
    }
  }
  
  func changePosts(){
    let postsRef = Database.database().reference().child("message")
    postsRef.observe(.childChanged, with: { snapshot in
      guard let dictionary = snapshot.value as? [String: Any] else {return}
      let postData = PostData(dictionary: dictionary)
      print("observe childChanged")
      self.posts.append(postData)
      self.makeMarker(postData: postData)
    })
    postsRef.observe(.childRemoved, with: { snapshot in
      guard let dictionary = snapshot.value as? [String: Any] else {return}
      let postData = PostData(dictionary: dictionary)
      print("observe childRemoved")
      self.posts.append(postData)
      self.makeMarker(postData: postData)
    })
  }
  
  func makeMarker(postData: PostData) -> [GMSMarker] {
    let marker = GMSMarker()
    //    let markerImage = UIImage(named:"marker")!.withRenderingMode(.alwaysOriginal)
    //    let markerView = UIImageView(image: markerImage)
    //    marker.iconView = markerView
    //    pinView = markerView
    
    let latitude = Double(postData.latitude)
    let longitude = Double(postData.longitude)
    marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
    
    marker.title = postData.caption
    let formatter = DateFormatter()
    formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    let dateString:String = formatter.string(from: postData.creationDate as Date)
    marker.snippet = dateString
    
    marker.infoWindowAnchor = CGPoint(x:0.5, y:0.2)
    marker.tracksInfoWindowChanges = true
    marker.appearAnimation = GMSMarkerAnimation.pop
    gmap.selectedMarker = marker
    
    imageUrl = postData.imageUrl
    
    marker.map = gmap
    markers = [marker]
    return markers
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .notDetermined:
      print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
      mapManager.requestWhenInUseAuthorization()
      break
    case .denied:
      alertMessage(message: "位置情報の利用が許可されていないため利用できません。「設定」⇒「プライバシー」⇒「位置情報サービス」⇒「アプリ名」")
      break
    case .restricted:
      alertMessage(message: "位置情報サービスの利用が制限されているため利用できません。「設定」⇒「一般」⇒「機能制限」")
      break
    case .authorizedAlways:
      print("常時位置情報の取得が許可されています。")
      mapManager.startUpdatingLocation()
      break
    case .authorizedWhenInUse:
      print("起動時のみ位置情報の取得が許可されています。")
      mapManager.startUpdatingLocation()
      break
    @unknown default:
      fatalError()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let userLocation:CLLocation = locations[0] as CLLocation
    latitude = userLocation.coordinate.latitude
    longitude = userLocation.coordinate.longitude
    let now :GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude,longitude:longitude,zoom:16)
    gmap.camera = now
  }
  
  func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
    let text = marker.title!
    let date = marker.snippet!
    
    let nextViewController = ContentController()
    nextViewController.text = text
    nextViewController.date = date
    nextViewController.imageUrl = imageUrl!
    self.navigationController?.pushViewController(nextViewController, animated: true)
  }
  
  func mapView(_ mapView:GMSMapView, didLongPressInfoWindowOf marker:GMSMarker) {
    reportAlertMessage(message:"不適切なコンテンツとして報告しますか？" ,marker: marker)
  }
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    switch result {
    case .cancelled:
      print("キャンセル")
    case .saved:
      print("下書き保存")
    case .sent:
      print("送信成功")
    default:
      print("送信失敗")
    }
    dismiss(animated: true, completion: nil)
  }
  
  func alertMessage(message:String) {
    let alertController = UIAlertController(title: "注意", message: message, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title:"OK", style: .default, handler:nil)
    alertController.addAction(defaultAction)
    alertController.popoverPresentationController?.sourceView = self.view
    alertController.popoverPresentationController?.sourceRect = CGRect(x: 100.0,y: 100.0,width: 20.0,height: 20.0)
    present(alertController, animated:true, completion:nil)
  }
  
  func reportAlertMessage(message:String, marker:GMSMarker) {
    let alertController = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
    let destructiveAction = UIAlertAction(title:"報告する", style: .destructive, handler:{
      (action: UIAlertAction!) in
      if MFMailComposeViewController.canSendMail() {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["report@sirube.co.jp"])
        mail.setSubject("不適切な投稿の報告："+"\(marker.title!)")
        mail.setMessageBody("【投稿内容】\(marker.title!)"+"\n【投稿時刻】\(marker.snippet!)" ,isHTML: false)
        self.present(mail, animated: true, completion: nil)
      } else {
        print("送信できません")
      }
    })
    let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler:nil)
    
    alertController.addAction(destructiveAction)
    alertController.addAction(cancelAction)
    alertController.popoverPresentationController?.sourceView = self.view
    alertController.popoverPresentationController?.sourceRect = CGRect(x: 100.0,y: 100.0,width: 20.0,height: 20.0) //位置調整する
    present(alertController, animated:true, completion:nil)
  }
  
}
