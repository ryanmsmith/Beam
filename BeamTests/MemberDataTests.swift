//
//  MemberDataTests.swift
//  BeamTests
//
//  Created by Ryan Smith on 5/19/19.
//  Copyright © 2019 Ryan Smith. All rights reserved.
//

import XCTest
@testable import Beam

class MemberDataTests: XCTestCase {

    /// Test decoding

    func testJSONDecodeSingleRecord() {
        let json = """
  {
    "id": 62,
    "primary_insured_id": 249,
    "name": "Remy LeBeau",
    "effective_date": "2018-01-01",
    "terminated_at": null,
    "shipping_address": "616 Thieves' Guild St.",
    "shipping_city": "Columbus",
    "shipping_state": "OH",
    "shipping_zip_code": "43215"
  }
"""
        let data = Data(json.utf8)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.yyyyMMdd)
        do {
            let memberRecord = try decoder.decode(MemberRecord.self, from: data)
            XCTAssertEqual(memberRecord.id, 62)
            XCTAssertEqual(memberRecord.primaryInsuredId, 249)
            XCTAssertEqual(memberRecord.name, "Remy LeBeau")
            XCTAssertEqual(memberRecord.effectiveDate, DateFormatter.yyyyMMdd.date(from: "2018-01-01"))
            XCTAssertEqual(memberRecord.terminatedAt, nil)
            XCTAssertEqual(memberRecord.shippingAddress, "616 Thieves' Guild St.")
            XCTAssertEqual(memberRecord.shippingCity, "Columbus")
            XCTAssertEqual(memberRecord.shippingState, "OH")
            XCTAssertEqual(memberRecord.shippingZipCode, "43215")
        }
        catch {
            XCTFail()
        }
    }

    func testJSONDecodeBadDateFormat() {
        let json = """
  {
    "id": 48,
    "primary_insured_id": null,
    "name": "Remy LeBeau",
    "effective_date": "2018-01-01",
    "terminated_at": "2018-31-10",
    "shipping_address": "616 Thieves' Guild St.",
    "shipping_city": "Columbus",
    "shipping_state": "OH",
    "shipping_zip_code": "43215"
  }
"""
        let data = Data(json.utf8)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.yyyyMMdd)
        do {
            let memberRecord = try decoder.decode(MemberRecord.self, from: data)
            XCTAssertEqual(memberRecord.id, 48)
            XCTAssertEqual(memberRecord.primaryInsuredId, nil)
            XCTAssertEqual(memberRecord.name, "Remy LeBeau")
            XCTAssertEqual(memberRecord.effectiveDate, DateFormatter.yyyyMMdd.date(from: "2018-01-01"))
            XCTAssertEqual(memberRecord.terminatedAt, nil)
            XCTAssertEqual(memberRecord.shippingAddress, "616 Thieves' Guild St.")
            XCTAssertEqual(memberRecord.shippingCity, "Columbus")
            XCTAssertEqual(memberRecord.shippingState, "OH")
            XCTAssertEqual(memberRecord.shippingZipCode, "43215")
        }
        catch {
            XCTFail()
        }
    }

    func testJSONDecodeArraySingle() {
        let json = """
[
  {
    "id": 62,
    "primary_insured_id": 249,
    "name": "Remy LeBeau",
    "effective_date": "2018-01-01",
    "terminated_at": null,
    "shipping_address": "616 Thieves' Guild St.",
    "shipping_city": "Columbus",
    "shipping_state": "OH",
    "shipping_zip_code": "43215"
  }
]
"""
        let data = Data(json.utf8)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.yyyyMMdd)
        do {
            let memberRecords = try decoder.decode([MemberRecord].self, from: data)
            let member = Member(memberRecords: memberRecords)
            XCTAssertTrue(member.memberRecords.count == 1)
            XCTAssertEqual(member.memberRecords.first?.id, 62)
        }
        catch {
            XCTFail()
        }
    }

    func testJSONDecodeArrayMultiple() {
        let json = """
[
  {
    "id": 62,
    "primary_insured_id": 249,
    "name": "Remy LeBeau",
    "effective_date": "2018-01-01",
    "terminated_at": null,
    "shipping_address": "616 Thieves' Guild St.",
    "shipping_city": "Columbus",
    "shipping_state": "OH",
    "shipping_zip_code": "43215"
  },
  {
    "id": 13,
    "primary_insured_id": 0,
    "name": "Remy LeBeau",
    "effective_date": "2018-01-01",
    "terminated_at": null,
    "shipping_address": "616 Thieves' Guild St.",
    "shipping_city": "Columbus",
    "shipping_state": "OH",
    "shipping_zip_code": "43215"
  },
  {
    "id": 43,
    "primary_insured_id": null,
    "name": "Remy LeBeau",
    "effective_date": "2018-01-01",
    "terminated_at": null,
    "shipping_address": "616 Thieves' Guild St.",
    "shipping_city": "Columbus",
    "shipping_state": "OH",
    "shipping_zip_code": "43215"
  },
  {
    "id": 14,
    "primary_insured_id": 0,
    "name": "Remy LeBeau",
    "effective_date": "2018-01-01",
    "terminated_at": null,
    "shipping_address": "616 Thieves' Guild St.",
    "shipping_city": "Columbus",
    "shipping_state": "OH",
    "shipping_zip_code": "43215"
  },
  {
    "id": 67,
    "primary_insured_id": null,
    "name": "Remy LeBeau",
    "effective_date": "2017-01-01",
    "terminated_at": "2017-06-30",
    "shipping_address": "616 Thieves' Guild St.",
    "shipping_city": "Columbus",
    "shipping_state": "OH",
    "shipping_zip_code": "43215"
  },
  {
    "id": 24,
    "primary_insured_id": 34,
    "name": "Remy LeBeau",
    "effective_date": "2018-01-01",
    "terminated_at": null,
    "shipping_address": "616 Thieves' Guild St.",
    "shipping_city": "Columbus",
    "shipping_state": "OH",
    "shipping_zip_code": "43215"
  },
  {
    "id": 52,
    "primary_insured_id": null,
    "name": "Remy LeBeau",
    "effective_date": "2017-01-01",
    "terminated_at": null,
    "shipping_address": "616 Thieves' Guild St.",
    "shipping_city": "Columbus",
    "shipping_state": "OH",
    "shipping_zip_code": "43215"
  },
  {
    "id": 48,
    "primary_insured_id": null,
    "name": "Remy LeBeau",
    "effective_date": "2018-01-01",
    "terminated_at": "2018-31-10",
    "shipping_address": "616 Thieves' Guild St.",
    "shipping_city": "Columbus",
    "shipping_state": "OH",
    "shipping_zip_code": "43215"
  },
  {
    "id": 53,
    "primary_insured_id": null,
    "name": "Remy LeBeau",
    "effective_date": "2017-01-01",
    "terminated_at": null,
    "shipping_address": "616 Thieves' Guild St.",
    "shipping_city": "Columbus",
    "shipping_state": "OH",
    "shipping_zip_code": "43215"
  },
  {
    "id": 39,
    "primary_insured_id": null,
    "name": "Remy LeBeau",
    "effective_date": "2017-01-11",
    "terminated_at": "2017-31-12",
    "shipping_address": "616 Thieves' Guild St.",
    "shipping_city": "Columbus",
    "shipping_state": "OH",
    "shipping_zip_code": "43215"
  }
]
"""
        let data = Data(json.utf8)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.yyyyMMdd)
        do {
            let memberRecords = try decoder.decode([MemberRecord].self, from: data)
            let member = Member(memberRecords: memberRecords)
            XCTAssertTrue(member.memberRecords.count == 10)
            XCTAssertEqual(member.memberRecords.first?.id, 62)
            XCTAssertEqual(member.memberRecords.last?.id, 39)
        }
        catch {
            XCTFail()
        }
    }
}
