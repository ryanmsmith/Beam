//
//  BrushingInfoCellViewModel.swift
//  Beam
//
//  Created by Ryan Smith on 5/19/19.
//  Copyright © 2019 Ryan Smith. All rights reserved.
//

import Foundation

public class BrushingInfoCellViewModel {
    var brushingInfo: BrushingInfo
    var delegate: BrushingInfoCellViewModelDelegate?

    init(withBrushingInfoRecord brushingInfoRecord: BrushingInfo) {
        self.brushingInfo = brushingInfoRecord
    }

    public func timestampLabelText() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        guard let timestamp = self.brushingInfo.timestamp else {
            return nil
        }
        let dateString = dateFormatter.string(from: timestamp)
        return dateString
    }

    public func durationLabelText() -> String? {
        let durationInSeconds = Decimal(self.brushingInfo.duration)
        let durationInMinutes = durationInSeconds / 60.0

        return "\(durationInMinutes) mins"
    }

    public func editInfo() {
        self.delegate?.editInfo(for: self.brushingInfo)
    }

    public func deleteInfo() {
        self.delegate?.deleteInfo(for: self.brushingInfo)
    }
}
