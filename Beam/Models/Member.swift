//
//  Member.swift
//  Beam
//
//  Created by Ryan Smith on 5/19/19.
//  Copyright © 2019 Ryan Smith. All rights reserved.
//

import Foundation

public struct Member: Decodable {
    var memberRecords: [MemberRecord]

    public struct MemberRecord: Decodable {
        let id: Int
        let primaryInsuredId: Int?
        let name: String
        let effectiveDate: Date
        let terminatedAt: Date?
        let shippingAddress: String
        let shippingCity: String
        let shippingState: String
        let shippingZipCode: String
    }
}

public typealias MemberRecord = Member.MemberRecord

private extension MemberRecord {
    private enum CodingKeys: String, CodingKey {
        case id
        case primaryInsuredId = "primary_insured_id"
        case name
        case effectiveDate = "effective_date"
        case terminatedAt = "terminated_at"
        case shippingAddress = "shipping_address"
        case shippingCity = "shipping_city"
        case shippingState = "shipping_state"
        case shippingZipCode = "shipping_zip_code"
    }
}

public extension MemberRecord {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        primaryInsuredId = try container.decode(Int?.self, forKey: .primaryInsuredId)
        name = try container.decode(String.self, forKey: .name)

        let dateFormatter = DateFormatter.yyyyMMdd
        let effectiveDateString = try container.decode(String.self, forKey: .effectiveDate)
        if let date = dateFormatter.date(from: effectiveDateString) {
            effectiveDate = date
        }
        else {
            throw DecodingError.dataCorruptedError(forKey: .effectiveDate, in: container, debugDescription: "Effective Date date string does not match format expected by formatter.")
        }

        let terminatedAtString = try container.decode(String?.self, forKey: .terminatedAt)
        if let terminatedAtString = terminatedAtString, let date = dateFormatter.date(from: terminatedAtString) {
            terminatedAt = date
        }
        else {
            terminatedAt = nil
        }

        shippingAddress = try container.decode(String.self, forKey: .shippingAddress)
        shippingCity = try container.decode(String.self, forKey: .shippingCity)
        shippingState = try container.decode(String.self, forKey: .shippingState)
        shippingZipCode = try container.decode(String.self, forKey: .shippingZipCode)
    }
}
