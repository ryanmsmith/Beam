//
//  MemberDataManaging.swift
//  Beam
//
//  Created by Ryan Smith on 5/19/19.
//  Copyright © 2019 Ryan Smith. All rights reserved.
//

import Foundation

protocol MemberDataManaging {
    func fetchMemberData(completion: @escaping (Member?, Error?) -> Void)
}
