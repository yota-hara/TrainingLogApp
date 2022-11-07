//
//  DateUtils.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import UIKit

class DateUtils {
    class func toDateFromString(string: String, format: String = "yyyy年MM月dd日HH") -> Date {
        let dateString = string + "12"
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.dateFormat = format
        return formatter.date(from: dateString)!
    }

    class func toStringFromDate(date: Date, format: String = "yyyy年MM月dd日") -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
