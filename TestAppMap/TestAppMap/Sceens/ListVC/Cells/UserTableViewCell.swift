//
//  UserTableViewCell.swift
//  TestAppMap
//
//  Created by Lishanenka, Uladzimir on 31.10.22.
//

import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView?
  
  var model: User?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func updateCell() {
    guard let owner = model?.owner else { return }
    nameLabel.text = owner.name + " " + owner.surname
    avatarImageView?.kf.setImage(with: URL(string: owner.foto))

  }
  
}
