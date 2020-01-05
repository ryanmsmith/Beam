//
//  BrushingInfoAddViewController.swift
//  Beam
//
//  Created by Ryan Smith on 5/19/19.
//  Copyright © 2019 Ryan Smith. All rights reserved.
//

import UIKit

public class BrushingInfoAddEditViewController: UIViewController {
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var timePicker: UIDatePicker!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var durationStepper: UIStepper!

    public var viewModel: BrushingInfoAddEditViewModel?

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.title = viewModel?.title()
        updateBrushingInfo()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func configureNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = self.view.tintColor
        self.navigationController?.navigationBar.tintColor = UIColor.white

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.setLeftBarButton(cancelButton, animated: false)

        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        self.navigationItem.setRightBarButton(saveButton, animated: false)
    }

    private func updateBrushingInfo() {
        if let duration = self.viewModel?.durationStepperValue() {
            self.durationStepper.value = duration
        }
        self.durationLabel.text = self.viewModel?.durationLabelText()
        guard let date = viewModel?.datePickerDate() else {
            return
        }
        self.datePicker.date = date
        self.timePicker.date = date
    }

    @IBAction private func durationStepperDidChange(_ sender: UIStepper) {
        self.viewModel?.durationDidChange(value: sender.value)
    }

    @IBAction private func datePickerDidChange(_ sender: UIDatePicker) {
        self.viewModel?.dateDidChange(value: sender.date)
    }
    
    @IBAction private func timePickerDidChange(_ sender: UIDatePicker) {
        self.viewModel?.dateDidChange(value: sender.date)
    }

    @objc private func cancel() {
        self.viewModel?.cancel()
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func save() {
        self.viewModel?.save()
        self.navigationController?.popViewController(animated: true)
    }
}

extension BrushingInfoAddEditViewController: ViewModelDelegate {
    public func viewModelDidUpdate() {
        DispatchQueue.main.async {
            self.updateBrushingInfo()
        }
    }
}

extension BrushingInfoAddEditViewController: StoryboardInstantiable {
    static var defaultFilename = "Main"
}

