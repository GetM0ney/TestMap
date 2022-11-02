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
    viewModel.getUsersData { [weak self] error in
      if let error = error {
        self?.showError(error: error)
      } else {
        self?.tableView.reloadData()
      }
    }
  }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let users = viewModel.users,
          let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.cellID) as? UserTableViewCell else { return  UITableViewCell()}
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
    guard let user = viewModel.users?[indexPath.row],
          let controller = UIStoryboard.init(name: "DetailUserViewController",
                                             bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailUserViewController")
          as? DetailUserViewController else { return }
    controller.locationsViewModel = DetailsViewModel(networkManager: self.viewModel.networkManager)
    controller.locationsViewModel?.usersVehicleData = user
    controller.locationsViewModel?.getLocationData {error in
      if let error = error {
        self.showError(error: error)
        return
      } else {
        self.navigationController?.pushViewController(controller, animated: true)
      }
    }
  }
}

extension UIViewController {
  func showError(error: Error) {
    let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "ok", style: .default)
    alert.addAction(okAction)
    present(alert, animated: true)
  }
}
