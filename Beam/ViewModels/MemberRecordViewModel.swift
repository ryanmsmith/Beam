//
//  MemberRecordViewModel.swift
//  Beam
//
//  Created by Ryan Smith on 5/19/19.
//  Copyright © 2019 Ryan Smith. All rights reserved.
//

import Foundation
import CoreData

public class MemberRecordViewModel: NSObject {
    private let dataManager: MemberDataManaging
    private var member: Member?
    public var currentMemberRecord: MemberRecord?
    public var delegate: ViewModelDelegate?

    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BrushingInfo")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]

        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: mainContext(), sectionNameKeyPath: nil, cacheName: nil)
    }()


    init(withDataManager dataManager: MemberDataManaging) {
        self.dataManager = dataManager
        super.init()
        self.fetchedResultsController.delegate = self
        try? self.fetchedResultsController.performFetch()
    }

    public func updateMemberData() {
        self.dataManager.fetchMemberData { (member, error) in
            if let error = error {
                NSLog("Error fetching data: \(error.localizedDescription)")
                return
            }

            guard let member = member else {
                return
            }

            self.member = member
            self.currentMemberRecord = self.findCurrentMemberRecord(inMemberData: member)

            self.delegate?.viewModelDidUpdate()
        }
    }

    private func findCurrentMemberRecord(inMemberData member: Member) -> MemberRecord? {
        guard member.memberRecords.count > 0 else {
            return nil
        }

        let validRecords = member.memberRecords.filter { (record) -> Bool in
            if record.primaryInsuredId != nil {
                return false
            }

            if record.terminatedAt != nil {
                return false
            }

            return true
        }

        if validRecords.count > 1 {
            let currentRecord = validRecords.sorted { (record1, record2) -> Bool in
                if record1.effectiveDate > record2.effectiveDate {
                    return true
                }
                return false
            }.first

            return currentRecord
        }
        else {
            return validRecords.first
        }
    }
}

extension MemberRecordViewModel {
    public func nameLabelText() -> String? {
        return self.currentMemberRecord?.name
    }

    public func shippingAddressLabelText() -> String? {
        guard let street = currentMemberRecord?.shippingAddress, let city = currentMemberRecord?.shippingCity, let state = currentMemberRecord?.shippingState, let zip = currentMemberRecord?.shippingZipCode else {
            return nil
        }

        return street + "\n" + city + ", " + state + " " + zip
    }
}

extension MemberRecordViewModel {
    public func numberOfRows(inSection section: Int) -> Int {
        guard let fetchedObjects = self.fetchedResultsController.fetchedObjects else {
            return 0
        }
        return fetchedObjects.count
    }

    public func brushingInfoCellViewModel(forRow row: Int) -> BrushingInfoCellViewModel? {
        guard let brushingInfo = self.fetchedResultsController.object(at: IndexPath(row: row, section: 0)) as? BrushingInfo else {
            return nil
        }
        return BrushingInfoCellViewModel(withBrushingInfoRecord: brushingInfo)
    }
}

extension MemberRecordViewModel {
    public func deleteInfo(for brushingInfo: BrushingInfo) {
        mainContext().delete(brushingInfo)
        try? mainContext().save()
    }
}

extension MemberRecordViewModel: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.viewModelDidUpdate()
    }
}
