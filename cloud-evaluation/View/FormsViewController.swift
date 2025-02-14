//
//  FormsViewController.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 14/02/25.
//

import UIKit
import Combine

class FormsViewController: UITableViewController {
    private var viewModel = FormsViewModel()
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Forms"
        viewModel.fetchForms()
        setupBindings()
    }

    private func setupBindings() {
        viewModel.$forms.sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.forms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.forms[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = FormDetailViewController()
        detailVC.form = viewModel.forms[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
