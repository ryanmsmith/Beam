//
//  MemberRecordViewController.swift
//  Beam
//
//  Created by Ryan Smith on 5/19/19.
//  Copyright © 2019 Ryan Smith. All rights reserved.
//

import UIKit

class MemberRecordViewController: UIViewController {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var shippingAddressLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    public var viewModel: MemberRecordViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MemberRecordViewModel(withDataManager: MemberDataManager())
        viewModel?.delegate = self
        viewModel?.updateMemberData()
        self.updateMemberInformation()
        self.tableView.separatorColor = UIColor(white: 1.0, alpha: 0.3)
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }

    private func updateMemberInformation() {
        self.nameLabel.text = viewModel?.nameLabelText()
        self.shippingAddressLabel.text = viewModel?.shippingAddressLabelText()
    }

    @IBAction private func addBrushingInfo(_ sender: UIButton) {
        let managedContext = mainContext()
        let newBrushingInfoRecord = BrushingInfo(entity: BrushingInfo.entity(), insertInto: managedContext)
        let brushingInfoAddViewModel = BrushingInfoAddEditViewModel(withNewBrushingInfoRecord: newBrushingInfoRecord)
        let addViewController = BrushingInfoAddEditViewController.instantiateViewController(withIdentifier: String(describing: BrushingInfoAddEditViewController.self))
        addViewController.viewModel = brushingInfoAddViewModel
        addViewController.viewModel?.delegate = addViewController

        self.navigationController?.pushViewController(addViewController, animated: true)
    }
}

extension MemberRecordViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else {
            return 0
        }

        return viewModel.numberOfRows(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "brushingInfoCell") as? BrushingInfoCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(withViewModel: self.viewModel?.brushingInfoCellViewModel(forRow: indexPath.row))
        cell.viewModel?.delegate = self

        return cell
    }
}

extension MemberRecordViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let brushingInfo = self.viewModel?.fetchedResultsController.object(at: indexPath) as? BrushingInfo else {
            return
        }

        let brushingInfoDetailsViewModel = BrushingInfoDetailsViewModel(withBrushingInfoRecord: brushingInfo)
        let detailsViewController = BrushingInfoDetailsViewController.instantiateViewController(withIdentifier: String(describing: BrushingInfoDetailsViewController.self))
        detailsViewController.viewModel = brushingInfoDetailsViewModel

        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension MemberRecordViewController: ViewModelDelegate {
    func viewModelDidUpdate() {
        DispatchQueue.main.async {
            self.updateMemberInformation()
            self.tableView.reloadData()
        }
    }
}

extension MemberRecordViewController: BrushingInfoCellViewModelDelegate {
    public func editInfo(for brushingInfo: BrushingInfo) {
        let brushingInfoAddViewModel = BrushingInfoAddEditViewModel(withBrushingInfoRecord: brushingInfo)
        let addViewController = BrushingInfoAddEditViewController.instantiateViewController(withIdentifier: String(describing: BrushingInfoAddEditViewController.self))
        addViewController.viewModel = brushingInfoAddViewModel
        addViewController.viewModel?.delegate = addViewController

        self.navigationController?.pushViewController(addViewController, animated: true)
    }

    public func deleteInfo(for brushingInfo: BrushingInfo) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        guard let timestamp = brushingInfo.timestamp else {
            return
        }
        let dateString = dateFormatter.string(from: timestamp)
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete the record from \(dateString)?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
            })
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.viewModel?.deleteInfo(for: brushingInfo)
            })
        
        self.present(alertController, animated: true)
    }
}
