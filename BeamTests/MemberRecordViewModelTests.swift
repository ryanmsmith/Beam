//
//  MemberRecordViewModelTests.swift
//  BeamTests
//
//  Created by Ryan Smith on 5/19/19.
//  Copyright © 2019 Ryan Smith. All rights reserved.
//

import XCTest
@testable import Beam

class MemberRecordViewModelTests: XCTestCase {
    func testSingleRecordWithinArrayResponse() {
        let dataManager = MockMemberDataManager(withMockResponseFilename: "SingleRecordWithinArrayResponse")
        let viewModel = MemberRecordViewModel(withDataManager: dataManager)
        viewModel.updateMemberData()

        XCTAssertEqual(viewModel.currentMemberRecord?.id, 43)
        XCTAssertEqual(viewModel.currentMemberRecord?.primaryInsuredId, nil)
        XCTAssertEqual(viewModel.currentMemberRecord?.name, "Remy LeBeau")
        XCTAssertEqual(viewModel.currentMemberRecord?.effectiveDate, DateFormatter.yyyyMMdd.date(from: "2018-01-01"))
        XCTAssertEqual(viewModel.currentMemberRecord?.terminatedAt, nil)
        XCTAssertEqual(viewModel.currentMemberRecord?.shippingAddress, "616 Thieves' Guild St.")
        XCTAssertEqual(viewModel.currentMemberRecord?.shippingCity, "Columbus")
        XCTAssertEqual(viewModel.currentMemberRecord?.shippingState, "OH")
        XCTAssertEqual(viewModel.currentMemberRecord?.shippingZipCode, "43215")
    }

    func testMultipleRecordsWithinArrayResponse() {
        let dataManager = MockMemberDataManager(withMockResponseFilename: "MultipleRecordsWithArrayResponse")
        let viewModel = MemberRecordViewModel(withDataManager: dataManager)
        viewModel.updateMemberData()

        XCTAssertEqual(viewModel.currentMemberRecord?.id, 43)
        XCTAssertEqual(viewModel.currentMemberRecord?.primaryInsuredId, nil)
        XCTAssertEqual(viewModel.currentMemberRecord?.name, "Remy LeBeau")
        XCTAssertEqual(viewModel.currentMemberRecord?.effectiveDate, DateFormatter.yyyyMMdd.date(from: "2018-01-01"))
        XCTAssertEqual(viewModel.currentMemberRecord?.terminatedAt, nil)
        XCTAssertEqual(viewModel.currentMemberRecord?.shippingAddress, "616 Thieves' Guild St.")
        XCTAssertEqual(viewModel.currentMemberRecord?.shippingCity, "Columbus")
        XCTAssertEqual(viewModel.currentMemberRecord?.shippingState, "OH")
        XCTAssertEqual(viewModel.currentMemberRecord?.shippingZipCode, "43215")
    }
}

fileprivate class MockMemberDataManager: MemberDataManaging {
    var responseFilename: String

    init(withMockResponseFilename filename: String) {
        self.responseFilename = filename
    }

    func fetchMemberData(completion: @escaping (Member?, Error?) -> Void) {
        guard let data = self.mockJSON(from: self.responseFilename) else {
            return
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.yyyyMMdd)
        do {
            let memberRecords = try decoder.decode([MemberRecord].self, from: data)
            let member = Member(memberRecords: memberRecords)
            completion(member, nil)
        }
        catch {
            return
        }
    }

    func mockJSON(from filename: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: filename, ofType: "json") else {
            return nil
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return data
        }

        catch {
            return nil
        }
    }
}
