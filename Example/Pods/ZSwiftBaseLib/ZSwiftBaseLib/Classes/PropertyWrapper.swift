//
//  PropertyWrapper.swift
//  ZSwiftBaseLib
//
//  Created by 朱继超 on 2020/12/17.
//

import Foundation

/**
 property wrapper 的局限性

 不能在协议里的属性使用。
 不能再 enum 里用。
 wrapper 属性不能定义 getter or setter 方法。
 不能再 extension 里用，因为 extension 里面不能有存贮属性。
 class 里的 wrapper property 不能覆盖其他的 property。
 wrapper 属性不能是 lazy、 @NSCopying、 @NSManaged、 weak、 或者、unowned.
 */

/// 先告诉编译器 下面这个UserDefault是一个属性包裹器
@propertyWrapper public struct UserDefault<T> {
    ///这里的属性key 和 defaultValue 还有init方法都是实际业务中的业务代码
    ///我们不需要过多关注
    let key: String
    let defaultValue: T

    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    ///  wrappedValue是@propertyWrapper必须要实现的属性
    /// 当操作我们要包裹的属性时  其具体set get方法实际上走的都是wrappedValue 的set get 方法。
    public var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}


//struct Test {
//    @Default("1") var change :String
//    @Default(1) var change :Int
//    @Default(DefineClass()) var change :DefineClass
//}
@propertyWrapper public struct Default<T> {//变量初始化赋予默认值
    private var value: T
    public init(_ wrappedValue: T) {
        self.value = wrappedValue
    }
    
    public var wrappedValue: T {
        get { value }
        set { value = newValue }
    }
    
}

///copy一个值创建一个属性
@propertyWrapper
public struct CopyingProperty<Value: NSCopying> {
    var storage: Value
    
    public init(wrappedValue: Value) {
        storage = wrappedValue.copy() as! Value
    }
    
    public init(withoutCopying value: Value) {
        storage = value
    }
    
    public var wrappedValue: Value {
        get { return storage }
        set { storage = newValue.copy() as! Value }
    }
}

///环境变量属性包裹器
@propertyWrapper
public struct EnvironmentVariableObject {
    var name: String
    public var wrappedValue: String? {
        get {
            guard let pointer = getenv(name) else { return nil }
            return String(cString: pointer)
        }
        set {
            guard let value = newValue else {
                unsetenv(name)
                return
            }
            setenv(value, value, 1)
        }
    }
}

/// Usage:
/// ```
/// @Expirable(duration: 60)
/// var name: String?
///
/// // New values will be valid for 60s
/// name = "123456abcd"
/// print(name) // "123456abcd"
/// sleep(61)
/// print(name) // nil
///
/// // You can also construct an expirable with an initial value and expiration date:
/// @Expirable(wrappedValue: "test", expirationDate: date, duration: 60)
/// var test: String?
/// // or just update an existing one:
/// test.set("test", expirationDate: date)
/// ```
@propertyWrapper
public struct Expirable<Value> {
    
    let duration: TimeInterval
    
    /// Stores a value toguether with its expiration date.
    var storage: (value: Value, expirationDate: Date)?
    
    /// Instantiate the wrapper with no initial value.
    public init(duration: TimeInterval) {
        self.duration = duration
        storage = nil
    }
    
    /// Instantiate the wrapper with an initial value and its expiration date, toguether with a duration.
    ///
    /// This method is meant to be used when a value is restored from some form of persistent storage and the expiration
    /// is well known and doesn't depend on the current date. It is perfectly fine to pass an expiration date in the past; the
    /// wrapper will simply treat the initial value as expired inmediatly.
    ///
    /// The duration will be ignored for this initial value but will be used as soon as a new value is set.
    public init(wrappedValue: Value, expirationDate: Date, duration: TimeInterval) {
        self.duration = duration
        storage = (wrappedValue, expirationDate)
    }
    
    public var wrappedValue: Value? {
        get {
            isValid ? storage?.value : nil
        }
        set {
            storage = newValue.map { newValue in
                let expirationDate = Date().addingTimeInterval(duration)
                return (newValue, expirationDate)
            }
        }
    }
    
    /// A Boolean value that indicates whether the expirable value is still valid or has expired.
    public var isValid: Bool {
        guard let storage = storage else { return false }
        return storage.expirationDate >= Date()
    }
    
    /// Set a new value toguether with its expiration date.
    ///
    /// By calling this method the duration set while constructing the property wrapper will be ignored for this concrete new value.
    /// Setting a new value without using this method will revert back to use the duration to compute the expiration date.
    public mutating func set(_ newValue: Value, expirationDate: Date) {
        storage = (newValue, expirationDate)
    }
}
