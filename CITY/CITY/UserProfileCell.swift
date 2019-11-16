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
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
