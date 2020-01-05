//
//  BrushingInfoDetailsViewController.swift
//  Beam
//
//  Created by Ryan Smith on 5/20/19.
//  Copyright © 2019 Ryan Smith. All rights reserved.
//

import UIKit

public class BrushingInfoDetailsViewController: UIViewController {
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!

    public var viewModel: BrushingInfoDetailsViewModel?

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.updateBrushingInfo()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func configureNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = self.view.tintColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    private func updateBrushingInfo() {
        self.durationLabel.text = self.viewModel?.durationLabelText()
        self.timestampLabel.text = self.viewModel?.timestampLabelText()
    }
}

extension BrushingInfoDetailsViewController: StoryboardInstantiable {
    static var defaultFilename = "Main"
}
