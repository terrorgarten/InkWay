//
//  IWErrors.swift
//  InkWay
//
//  Created by terrorgarten on 29.05.2023.
//

import Foundation

// only used on two places, needs refactoring
enum IWError: Error {
    case LogoutError
    case LoginError
    case OtherError
}
