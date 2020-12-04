//
//  ResponseObject.swift
//  SampleApp
//
//  Created by Louielar Lingat on 03/12/2020.
//  Copyright © 2020 UBX. All rights reserved.
//

import Foundation

//MARK: - RESPONSES
struct TotalSupply: Codable {
    var totalSupply: String
    var message: String
}

struct Balance: Codable {
    var balance: String
    var message: String
}

struct Allowance: Codable {
    var allowance: String
    var message: String
}

struct Message: Codable {
    var message: String
}
