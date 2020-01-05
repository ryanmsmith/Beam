//
//  BrushingInfoAddViewModel.swift
//  Beam
//
//  Created by Ryan Smith on 5/19/19.
//  Copyright © 2019 Ryan Smith. All rights reserved.
//

import Foundation

public class BrushingInfoAddEditViewModel: BrushingInfoDetailsViewModel {
    private var newRecord = false

    override init(withBrushingInfoRecord brushingInfoRecord: BrushingInfo) {
        super.init(withBrushingInfoRecord: brushingInfoRecord)
    }

    init(withNewBrushingInfoRecord brushingInfoRecord: BrushingInfo) {
        super.init(withBrushingInfoRecord: brushingInfoRecord)
        self.newRecord = true
        self.setDefaults()
    }

    func setDefaults() {
        self.brushingInfo.timestamp = Date()
        self.brushingInfo.duration = 120
    }

    override func title() -> String {
        return newRecord ? "Add Brushing" : "Edit Brushing"
    }

    func durationStepperValue() -> Double {
        return Double(self.brushingInfo.duration)
    }

    func durationDidChange(value: Double) {
        self.brushingInfo.duration = Int64(value)
        self.delegate?.viewModelDidUpdate()
    }

    func datePickerDate() -> Date? {
        return self.brushingInfo.timestamp
    }

    func timePickerDate() -> Date? {
        return self.brushingInfo.timestamp
    }

    func dateDidChange(value: Date) {
        self.brushingInfo.timestamp = value
        self.delegate?.viewModelDidUpdate()
    }

    func timeDidChange(value: Date) {
        self.brushingInfo.timestamp = value
        self.delegate?.viewModelDidUpdate()
    }

    func cancel() {
        if self.newRecord {
            mainContext().delete(self.brushingInfo)
            try? mainContext().save()
        }
        mainContext().refresh(self.brushingInfo, mergeChanges: false)
    }

    func save() {
        do {
            try self.brushingInfo.managedObjectContext?.save()
        }
        catch { }
    }
}
