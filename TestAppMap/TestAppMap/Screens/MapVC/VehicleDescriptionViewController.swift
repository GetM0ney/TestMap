//
//  VehicleDescriptionViewController.swift
//  TestAppMap
//
//  Created by Lishanenka, Uladzimir on 30.10.22.
//

import UIKit
import Kingfisher

class VehicleDescriptionViewController: UIViewController {
  var vehicleModel: Vehicle?
  
  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var yearLabel: UILabel!
  @IBOutlet weak var makeModelLabel: UILabel!
  @IBOutlet weak var vinLabel: UILabel!
  @IBOutlet weak var vehicleImage: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI() {
    guard let model = vehicleModel else { return }
    colorView.backgroundColor = UIColor(hexString: model.color)
    yearLabel.text = "Year \(model.year)"
    makeModelLabel.text = "\(model.make) \(model.model)"
    vinLabel.text = model.vin
    vehicleImage.kf.setImage(with: URL(string: model.foto))
  }
}
