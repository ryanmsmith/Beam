//
//  BrushingInfoCellViewModelDelegate.swift
//  Beam
//
//  Created by Ryan Smith on 5/20/19.
//  Copyright © 2019 Ryan Smith. All rights reserved.
//

import Foundation

public protocol BrushingInfoCellViewModelDelegate {
    func editInfo(for brushingInfo: BrushingInfo)
    func deleteInfo(for brushingInfo: BrushingInfo)
}
