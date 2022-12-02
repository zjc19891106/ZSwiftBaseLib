//
//  ArrayExtension.swift
//  ZSwiftBaseLib
//
//  Created by 朱继超 on 2020/12/17.
//

import Foundation

// MARK: - ArrayExtension
public extension Array {
    var z: ZSwiftLib<Array<Element>> {
        return ZSwiftLib.init(self)
    }
    
    ///数组越界防护
    subscript(safe idx: Index) -> Element? {
        if idx < 0 { return nil }
        return idx < self.endIndex ? self[idx] : nil
    }
    
    subscript(safe range: Range<Int>) -> ArraySlice<Element>? {
        if range.startIndex < 0 { return nil }
        return range.endIndex <= self.endIndex ? self[range.startIndex...range.endIndex]:nil
    }
    
    func zyb_JsonString() -> String {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("无法解析出JSONString")
            return ""
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            assert(false, "\(error)")
        }
        return ""
    }
    
    
    /// Description filterDuplicatesElements
    /// - Parameter filter: filter condition
    /// - Returns: result
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
    
}

public extension ZSwiftLib where Base == Array<String> {
    func splitToString(_ delimiter: String) -> String {
        var result = ""
        for (index,text) in base.enumerated() {
            if index == 0 {
                result = text
            } else {
                result += "\(delimiter)\(text)"
            }
        }
        return result
    }
}


