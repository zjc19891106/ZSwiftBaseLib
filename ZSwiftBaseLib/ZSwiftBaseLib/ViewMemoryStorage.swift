//
//  ViewMemoryStorage.swift
//  TestPods
//
//  Created by 朱继超 on 2021/1/13.
//

import Foundation

public enum MemoryAlignment: Int {
    case one = 1, two = 2, four = 4, eight = 8
}

private let empty_point = UnsafeRawPointer(bitPattern: 0x1)!

/// A small tool class to assist in viewing memory
public struct ViewMemoryStorage<T> {
    private static func memoryString(_ ptr: UnsafeRawPointer,
                                _ size: Int,
                                _ aligment: Int) ->String {
        if ptr == empty_point { return "" }
        var rawPointer = ptr
        var string = ""
        let formatter = "0x%0\(aligment << 1)lx"
        let count = size / aligment
        for i in 0..<count {
            if i > 0 {
                string.append(" ")
                rawPointer += aligment
            }
            let value: CVarArg
            switch aligment {
            case MemoryAlignment.eight.rawValue:
                value = rawPointer.load(as: UInt64.self)
            case MemoryAlignment.four.rawValue:
                value = rawPointer.load(as: UInt32.self)
            case MemoryAlignment.two.rawValue:
                value = rawPointer.load(as: UInt16.self)
            default:
                value = rawPointer.load(as: UInt8.self)
            }
            string.append(String(format: formatter, value))
        }
        return string
    }
    
    private static func memoryBytes(_ ptr: UnsafeRawPointer,
                                  _ size: Int) -> [UInt8] {
        var array: [UInt8] = []
        if ptr == empty_point { return array }
        for i in 0..<size {
            array.append((ptr + i).load(as: UInt8.self))
        }
        return array
    }
    
    
    /// Description Get the memory data of the variable (byte array format)
    /// - Parameter v: T is Any
    /// - Returns:E.g. 0x00007089
    public static func memoryBytes(ofVal v: inout T) -> [UInt8] {
        return memoryBytes(getPointer(ofVal: &v), MemoryLayout.stride(ofValue: v))
    }
    
    
    /// Description Get the memory data pointed to by the reference (byte array format)
    /// - Parameter v: T is Any
    /// - Returns: E.g. 0x00007089
    public static func memoryBytes(ofRef v: T) -> [UInt8] {
        let p = getPointer(ofRef: v)
        return memoryBytes(p, malloc_size(p))
    }
    
    
    /// Description  Get the memory data of the variable (string format)
    /// - Parameters:
    ///   - v: T is Any
    ///   - alignment: MemoryAlignment's any case
    /// - Returns: Data string stored in memory
    public static func memoryString(ofVal v: inout T, alignment: MemoryAlignment? = nil) -> String {
        let p = getPointer(ofVal: &v)
        guard let raw = alignment?.rawValue else {
            return ""
        }
        return memoryString(p, MemoryLayout.stride(ofValue: v),
                       alignment != nil ? raw : MemoryLayout.alignment(ofValue: v))
    }
    
    
    /// Description  Get the memory data pointed to by the reference (string format)
    /// - Parameters:
    ///   - v: T is Any
    ///   - alignment: MemoryAlignment's any case
    /// - Returns: memory data pointed to by the reference (string format)
    public static func memoryString(ofRef v: T, alignment: MemoryAlignment? = nil) -> String {
        let p = getPointer(ofRef: v)
        return memoryString(p, malloc_size(p),
                       alignment != nil ? alignment!.rawValue : MemoryLayout.alignment(ofValue: v))
    }
    
    
    /// Description  Get the memory address of the variable
    /// - Parameter v: T is Any
    /// - Returns: point
    public static func getPointer(ofVal v: inout T) -> UnsafeRawPointer {
        return MemoryLayout.size(ofValue: v) == 0 ? empty_point : withUnsafePointer(to: &v) {
            UnsafeRawPointer($0)
        }
    }
    
    
    /// Description   Get the address of the memory pointed to by the reference
    /// - Parameter v: T is Any
    /// - Returns: point
    public static func getPointer(ofRef v: T) -> UnsafeRawPointer {
        if v is Array<Any>
            || Swift.type(of: v) is AnyClass
            || v is AnyClass {
            return UnsafeRawPointer(bitPattern: unsafeBitCast(v, to: UInt.self))!
        } else if v is String {
            var memoryString = v as! String
            if memoryString.mw.type() != .heap {
                return empty_point
            }
            return UnsafeRawPointer(bitPattern: unsafeBitCast(v, to: (UInt, UInt).self).1)!
        } else {
            return empty_point
        }
    }
    
    
    /// Description  Get the memory size occupied by the variable
    /// - Parameter v: T is Any
    /// - Returns: memory size occupied by the variable
    public static func size(ofVal v: inout T) -> Int {
        return MemoryLayout.size(ofValue: v) > 0 ? MemoryLayout.stride(ofValue: v) : 0
    }
    
    
    /// Description  Get the size of the memory pointed to by the reference
    /// - Parameter v: T is Any
    /// - Returns:  size of the memory pointed to by the reference
    public static func size(ofRef v: T) -> Int {
        return malloc_size(getPointer(ofRef: v))
    }
}

public enum StringMemoryType : UInt8 {
    /// TEXT段（常量区）
    case text = 0xd0
    /// taggerPointer
    case tagPtr = 0xe0
    /// 堆空间
    case heap = 0xf0
    /// 未知
    case unknow = 0xff
}

public struct MemoryWrapper<Base> {
    public private(set) var base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol MemsCompatible {}
public extension MemsCompatible {
    static var mw: MemoryWrapper<Self>.Type {
        get { return MemoryWrapper<Self>.self }
        set {}
    }
    var mw: MemoryWrapper<Self> {
        get { return MemoryWrapper(self) }
        set {}
    }
}

extension String: MemsCompatible {}
public extension MemoryWrapper where Base == String {
    mutating func type() -> StringMemoryType {
        let ptr = ViewMemoryStorage.getPointer(ofVal: &base)
        return StringMemoryType(rawValue: (ptr + 15).load(as: UInt8.self) & 0xf0)
            ?? StringMemoryType(rawValue: (ptr + 7).load(as: UInt8.self) & 0xf0)
            ?? .unknow
    }
}
