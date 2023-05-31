//
//  Extensions.swift
//  InkWay
//
//  Created by terrorgarten on 23.05.2023.
//

import Foundation

/// Prepares JSON
extension Encodable {
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:]
        } catch {
            return [:]
        }
    }
}


extension TimeInterval {
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy" // Customize the date format as desired
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}
