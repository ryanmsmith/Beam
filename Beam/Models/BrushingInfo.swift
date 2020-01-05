//
//  BrushingInfo+CoreDataClass.swift
//  Beam
//
//  Created by Ryan Smith on 5/20/19.
//  Copyright © 2019 Ryan Smith. All rights reserved.
//
//

import Foundation
import CoreData

@objc(BrushingInfo)
public final class BrushingInfo: NSManagedObject {
    @NSManaged public var duration: Int64
    @NSManaged public var timestamp: Date?
}

extension BrushingInfo {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BrushingInfo> {
        return NSFetchRequest<BrushingInfo>(entityName: "BrushingInfo")
    }
}

extension BrushingInfo: Decodable {
    public convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            fatalError("Missing context or invalid context")
        }

        guard let entity = NSEntityDescription.entity(forEntityName: "BrushingInfo", in: context) else {
            fatalError("Unknown entity Passenger in context")
        }

        self.init(entity: entity, insertInto: context)

        var container = try decoder.unkeyedContainer()
        self.timestamp = try container.decode(Date?.self)
        self.duration = try container.decode(Int64.self)
    }
}

