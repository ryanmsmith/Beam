//
//  BrushingInfoCell.swift
//  Beam
//
//  Created by Ryan Smith on 5/19/19.
//  Copyright © 2019 Ryan Smith. All rights reserved.
//

import UIKit

class BrushingInfoCell: UITableViewCell {
    @IBOutlet private weak var timestampLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!

    public var viewModel: BrushingInfoCellViewModel?

    public func configureCell(withViewModel viewModel: BrushingInfoCellViewModel?) {
        if let viewModel = viewModel {
            self.viewModel = viewModel
            self.timestampLabel.text = self.viewModel?.timestampLabelText()
            self.durationLabel.text = self.viewModel?.durationLabelText()
        }
    }

    @IBAction private func editInfo(_ sender: Any) {
        self.viewModel?.editInfo()
    }

    @IBAction private func deleteInfo(_ sender: Any) {
        self.viewModel?.deleteInfo()
    }
}
