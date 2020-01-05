//
//  MemberDataManager.swift
//  Beam
//
//  Created by Ryan Smith on 5/19/19.
//  Copyright © 2019 Ryan Smith. All rights reserved.
//

import Foundation

public class MemberDataManager: MemberDataManaging {
    func fetchMemberData(completion: @escaping (Member?, Error?) -> Void) {
        if let url = URL(string: "https://member-data.beam.dental/searchResults.json") {
            let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                    completion(nil, DataManagerError(type: .httpError))
                }
                guard let data = data else {

                    completion(nil, DataManagerError(type: .dataError))
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
                    completion(nil, DataManagerError(type: .decoderError))
                }
            }

            dataTask.resume()
        }
    }
}

struct DataManagerError: Error {
    enum ErrorType {
        case httpError
        case dataError
        case decoderError
    }

    let type: ErrorType
}
