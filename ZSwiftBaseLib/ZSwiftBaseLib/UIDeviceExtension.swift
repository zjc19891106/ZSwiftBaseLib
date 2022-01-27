//
//  UIDeviceExtension.swift
//  ZSwiftBaseLib
//
//  Created by 朱继超 on 2020/12/17.
//

import Foundation
import UIKit

// MARK: - extension UIDevice
public extension UIDevice {
    
    var infoDic: Dictionary<String,Any> {
        Bundle.main.infoDictionary ?? [:]
    }
    // MARK: - App相关
    // 获取App的版本号
    var appVersion :String {
        guard let appVersion = infoDic["CFBundleShortVersionString"] as? String else {
            return "获取APP版本号失败"
        }
        return appVersion
    }
    
    // 获取App的build版本
    var appBuildVersion :String {
        guard let appBuildVersion = infoDic["CFBundleVersion"] as? String else {
            return "获取APP版本号失败"
        }
        return appBuildVersion
    }
    
    // 获取App的名称
    var appName :String {
        guard let appName = infoDic["CFBundleDisplayName"] as? String else {
            return "获取APP版本号失败"
        }
        return appName
    }
    
    // MARK: - 设备相关
    // 获取设备的型号 iPhone iPad iPod touch
    var deviceModel :String {
        return UIDevice.current.model
    }
    
    // 获取设备UUID
    var deviceUUID :String {
        guard let UUID = UIDevice.current.identifierForVendor?.uuidString else {
            return "获取设备唯一标识失败"
        }
        return UUID
    }
    
    // 获取设备名称（如iPhone：xxxiPhone）
    var deviceName :String {
        return UIDevice.current.name
    }
    
    // 获取系统版本号
    var sysVersion :String {
        return UIDevice.current.systemVersion
    }
    
    // 获取iPhone、ipad、TV、的具体型号
    var machineType: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1","iPhone5,2":                     return "iPhone 5"
        case "iPhone5,3","iPhone5,4":                     return "iPhone 5c"
        case "iPhone6,1","iPhone6,2":                     return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1","iPhone9,3":                     return "iPhone 7"
        case "iPhone9,2","iPhone9,4":                     return "iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":                   return "iPhone 8"
        case "iPhone10,2","iPhone10,5":                   return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":                   return "iPhone X"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4","iPhone11,6":                   return "iPhone XS Max"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12":                                return "iPhone 11 Pro Max"
        case "iPhone12,8":                              return "iPhone SE 2"
        case "iPhone13,1":                              return "iPhone 12 mini"
        case "iPhone13,2":                              return "iPhone 12"
        case "iPhone13,3":                              return "iPhone 12 Pro"
        case "iPhone13,4":                              return "iPhone 12 Pro Max"
        case "i386","x86_64":                           return "Simulator"
        default:                                      return ""
        }
    }
}
