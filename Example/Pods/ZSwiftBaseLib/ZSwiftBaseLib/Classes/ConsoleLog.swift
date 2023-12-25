//
//  ConsoleLog.swift
//  ZSwiftBaseLib
//
//  Created by 朱继超 on 2020/12/17.
//

import Foundation

public enum consoleLogType : String {
    case error   = "ERROR"
    case waring  = "WARING"
    case info    = "INFO";
    case debug   = "DEBUG"
    case mark    = "MARK"
    case test    = "TEST"
}

/// Description  日志输出
/// - Parameters:
///   - message: object that you want to print
///   - type: print type
///   - file: fileName
///   - function: functionName
///   - line: print line
public func consoleLogInfo <T> (
    _ message : T,
    type : consoleLogType,
    file : StaticString = #file,
    function : StaticString = #function,
    line : UInt = #line
) {
   consoleLog(message, type: type, file : file, function: function, line: line)
}

private func consoleLog<T> (
    _ message : T,
    type : consoleLogType,
    file : StaticString = #file,
    function : StaticString = #function,
    line : UInt = #line
){
    #if DEBUG
    let time = DateFormatter()
    time.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    let timeString = time.string(from: Date())
    let fileName = (file.description as NSString).lastPathComponent
    print("\(timeString) \(type.rawValue) \(fileName):\(line) logResult is :\(message)")
    #else
    #endif
}
