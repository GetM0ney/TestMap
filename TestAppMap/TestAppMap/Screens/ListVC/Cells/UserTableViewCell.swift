//
//  UserTableViewCell.swift
//  TestAppMap
//
//  Created by Lishanenka, Uladzimir on 31.10.22.
//

import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {
  //контанты добавить
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView?
  
  static let cellID = "UserTableViewCell"
  static let nibName = "UserTableViewCell"
  
  var model: User?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func prepareForReuse() {
    //
  }
  
  func updateCell() {
    guard let owner = model?.owner else { return }
    nameLabel.text = owner.name + " " + owner.surname
    avatarImageView?.kf.setImage(with: URL(string: owner.foto))
  }
}
