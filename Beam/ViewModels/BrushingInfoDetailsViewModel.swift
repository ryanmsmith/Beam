//
//  BrushingInfoDetailsViewModel.swift
//  Beam
//
//  Created by Ryan Smith on 5/20/19.
//  Copyright © 2019 Ryan Smith. All rights reserved.
//

import Foundation

public class BrushingInfoDetailsViewModel {
    public var brushingInfo: BrushingInfo
    public var delegate: ViewModelDelegate?

    init(withBrushingInfoRecord brushingInfoRecord: BrushingInfo) {
        self.brushingInfo = brushingInfoRecord
    }

    func title() -> String {
        return "Brushing Details"
    }
    
    func durationLabelText() -> String {
        let durationInSeconds = Decimal(self.brushingInfo.duration)
        let durationInMinutes = durationInSeconds / 60.0

        return "\(durationInMinutes) mins"
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
}
