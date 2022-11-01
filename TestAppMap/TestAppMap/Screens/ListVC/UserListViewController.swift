//
//  UserListViewController.swift
//  TestAppMap
//
//  Created by Lishanenka, Uladzimir on 30.10.22.
//

import UIKit

class UserListViewController: UIViewController {
  
  var viewModel: UserListViewModel!
  @IBOutlet private weak var tableView: UITableView! {
    didSet {
      tableView.register(UINib(nibName: UserTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: UserTableViewCell.cellID)
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    viewModel.getUsersData { [weak self] in
      self?.tableView.reloadData()
    }
  }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
    guard let users = viewModel.users else { return  UITableViewCell()}
    cell.model = users[indexPath.row]
    cell.updateCell()
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let count = viewModel.users?.count else { return 0 }
    return count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let controller = UIStoryboard.init(name: "DetailUserViewController",
                                             bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailUserViewController") as? DetailUserViewController else { return }
    guard let user = viewModel.users?[indexPath.row] else { return }
    controller.locationsViewModel = DetailsViewModel()
    controller.locationsViewModel?.usersVehicleData = user
    controller.locationsViewModel?.networkManager = self.viewModel.networkManager
    controller.locationsViewModel?.getLocationData {
      self.navigationController?.pushViewController(controller, animated: true)
      //координатор
    }
  }
}
