//
//  util.swift
//  lizzie_peaks
//
//  Created by Curtis Chong on 2019-07-21.
//  Copyright © 2019 Curtis Chong. All rights reserved.
//

import Foundation

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return calendar.date(from: dateComponents) ?? nil
    }
}
