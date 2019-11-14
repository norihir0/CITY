
import UIKit

//データ通信　スクロールした時に画像をいちいちスクロールする前の画像、破棄してダウンロードして表示してるから画像とかを一時的に保存しといてそんなことせんでもよくなる処理
var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
  
  var lastURLUsedToLoadImage: String?
  
  func loadImage(urlString: String) {
    //print("Loading image....")
    
    //これなんかようわかってない　なくても別に変わってない気が　２８の最後　白の画像が
    self.image = nil
    
    if let cachedImage = imageCache[urlString] {
      self.image = cachedImage
      return
    }
    
    lastURLUsedToLoadImage = urlString
    
    //userProfilePhotoCellの　didsetからの切り取り
    //imageUrlからurlStringに変更
    guard let url = URL(string: urlString) else { return}
    
    URLSession.shared.dataTask(with: url) { (data, respose, err) in
      if let err = err {
        print("Failed to fetch post image:",err)
        return
      }
      
      //速度遅いの改善　オーダーを小さくしてるらしーけどあんまわかってない　確かに早くはなってる　reloadが関係してるらしいけど　Ep18 self.post?.imageUrlからself.lastURLUsedToLoadImageに変更
      if url.absoluteString != self.lastURLUsedToLoadImage {
        return
      }
      
      guard let imageData = data else { return }
      
      let photoImage = UIImage(data: imageData)
      
      //Cacheに関わる処理
      imageCache[url.absoluteString] = photoImage
      
      DispatchQueue.main.async {
        //self.photoImageView.imageから
        self.image = photoImage
      }
      }.resume()
  }
}
