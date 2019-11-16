//  CameraController.swift
//カメラロール導線

import UIKit
import AVFoundation
import CoreLocation

@available(iOS 10.0, *)
class CameraController: UIViewController, AVCapturePhotoCaptureDelegate, CLLocationManagerDelegate {
  
  var mapManager: CLLocationManager = CLLocationManager()
  var latitude: CLLocationDegrees! = CLLocationDegrees()
  var longitude: CLLocationDegrees! = CLLocationDegrees()
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCaptureSession()
    setupHUD()
    
    mapManager.delegate = self
    mapManager.startUpdatingLocation()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.setNavigationBarHidden(true, animated: false)
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
  
  func alertMessage(message:String) {
    let alertController = UIAlertController(title: "注意", message: message, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title:"OK", style: .default, handler:nil)
    alertController.addAction(defaultAction)
    alertController.popoverPresentationController?.sourceView = self.view
    alertController.popoverPresentationController?.sourceRect = CGRect(x: 100.0,y: 100.0,width: 20.0,height: 20.0)
    present(alertController, animated:true, completion:nil)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let userLocation:CLLocation = locations[0] as CLLocation
    latitude = userLocation.coordinate.latitude
    longitude = userLocation.coordinate.longitude
  }
  
  let dismissButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
    button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    return button
  }()
  
  @objc func handleDismiss() {
    dismiss(animated: true, completion: nil)
  }
  
  let capturePhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "capture_photo"), for: .normal)
    button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
    return button
  }()
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  fileprivate func setupHUD() {
    let safeAreaInsets: UIEdgeInsets
    if #available(iOS 11, *) {
      safeAreaInsets = view.safeAreaInsets
    } else {
      safeAreaInsets = .zero
    }
    view.addSubview(capturePhotoButton)
    view.addSubview(dismissButton)
    capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    if #available(iOS 11.0, *) {
      capturePhotoButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 50, paddingRight: 0, width: 80, height: 80)
      dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
    } else {
      capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: 80, height: 80)
      dismissButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
    }
  }
  
  @available(iOS 10.0, *)
  @objc func handleCapturePhoto() {
    
    let settings = AVCapturePhotoSettings()
    
    #if (!arch(x86_64))
      guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
      
      settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
      
      output.capturePhoto(with: settings, delegate: self)
    #endif
  }
  
  @available(iOS 10.0, *)
  func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
    
    let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)
    
    let previewImage = UIImage(data: imageData!)
    
    let containerView = PreviewPhotoContainerView()
    containerView.previewImageView.image = previewImage
    containerView.latitude = "\(latitude!)"
    containerView.longitude = "\(longitude!)"
    view.addSubview(containerView)
    containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
  }
  
  let output = AVCapturePhotoOutput()
  fileprivate func setupCaptureSession() {
    let captureSession = AVCaptureSession()
    
    guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
    
    do {
      let input = try AVCaptureDeviceInput(device: captureDevice)
      if captureSession.canAddInput(input) {
        captureSession.addInput(input)
      }
    } catch let err {
      print("Could not setup camera input:", err)
    }
    
    if captureSession.canAddOutput(output) {
      captureSession.addOutput(output)
    }
    
    let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer.frame = view.frame
    view.layer.addSublayer(previewLayer)
    
    captureSession.startRunning()
  }
  
}
