//
//  DateExtension.swift
//  ZSwiftBaseLib
//
//  Created by 朱继超 on 2020/12/17.
//

import Foundation
import UIKit

public extension Date {
    var z:ZSwiftLib<Self> {
        return ZSwiftLib.init(self)
    }
}

public extension ZSwiftLib where Base == Date {
    
    var dateString: String {
        let formmat = DateFormatter()
        formmat.dateFormat = "yyyy-MM-dd"
        return formmat.string(from: base)
    }
    
    /// Description Advance or hind legs a few hours on the current date
    /// - Parameter num: hours
    mutating func addHours(_ num: Int) {
        base.addTimeInterval(TimeInterval(60.0 * 60.0 * CGFloat(num)))
    }
    
    func futureDate(_ year: Int = 0,_ month: Int = 0,_ day: Int = 0) -> Base {
        let current = Date()
        let calendar = Calendar(identifier: .gregorian)
        var comps:DateComponents?
        comps = calendar.dateComponents([.year,.month,.day], from: current)
        comps?.year = year
        comps?.month = month
        comps?.day = day
        return calendar.date(byAdding: comps!, to: current) ?? Date()
    }
    
    /// Convert current date to string
    /// - Parameter formatter: DateFormatter
    /// - Returns: String  positive forword or negative backword
    func dateString(_ formatter: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let fmt = DateFormatter()
        fmt.timeZone = TimeZone.current
        let newDate = base
        fmt.locale = Locale(identifier: "zh_CN")
        fmt.dateFormat = formatter
        return fmt.string(from: newDate)
    }
    
    /// Description  Compare the size of the current date with another date
    /// - Parameter otherDate: another date
    /// - Returns: 0 same as  1Ascending  2Descending
    func compareToDate(_ otherDate: Date) -> Int {
        let resultDic: [ComparisonResult: Int] = [.orderedSame: 0, .orderedAscending: 1, .orderedDescending: 2]
        return resultDic[base.compare(otherDate)] ?? 0
    }
}
