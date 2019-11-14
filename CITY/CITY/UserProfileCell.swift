//  UserProfileCell.swift

import UIKit

protocol UserProfileCellDelegate {
  func touchEditButton(for cell: UserProfileCell)
}

class UserProfileCell: UICollectionViewCell {
  
  var delegate: UserProfileCellDelegate?
  var post: Post? {
    didSet {
      guard let imageUrl = post?.imageUrl else { return }
      photoImageView.loadImage(urlString: imageUrl)
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
//    addSubview(captionLabel)
//    captionLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 42, width: 0, height: 0)
//    addSubview(postEditButton)
//    postEditButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
    addSubview(photoImageView)
    photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    self.backgroundColor = .white
  }
  
  let photoImageView: CustomImageView = {
    let iv = CustomImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()

  
//  fileprivate func setupAttributeText() {
//
//    guard let post = self.post else {return}
//
//    let attributedText = NSMutableAttributedString(string: post.caption, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
//    attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 4)]))
//
//    let formatter = DateFormatter()
//    formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
//    formatter.dateFormat = "yyyy-MM-dd HH:mm"
//    let timedata:String = formatter.string(from: post.creationDate as Date )
//
//    attributedText.append(NSAttributedString(string:" \(timedata)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.gray]))
//
//    captionLabel.attributedText = attributedText
//  }
  
//  let captionLabel: UILabel = {
//    let label = UILabel()
//    label.numberOfLines = 0
//    return label
//  }()
  
//  lazy var postEditButton: UIButton = {
//    let button = UIButton(type: .system)
//    button.setImage(#imageLiteral(resourceName: "down-arrow"), for: .normal)
//    button.tintColor = UIColor.mainPink()
//    button.addTarget(self, action: #selector(handlePostEdit), for: .touchUpInside)
//
//    return button
//  }()
  
//  @objc func handlePostEdit() {
//    delegate?.touchEditButton(for: self)
//  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
