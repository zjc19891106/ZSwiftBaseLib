//
//  URLExtension.swift
//  ZSwiftBaseLib
//
//  Created by 朱继超 on 2020/12/17.
//

import Foundation
import UIKit
import AVFoundation
/// Description url params convert dic
/// - Parameter url: get url
/// - Returns: url's params
public func queryParameters(for url: URL?) -> [String: String] {
    (url?.absoluteString)
        .flatMap { URLComponents(string: $0) }?
        .queryItems?
        .compactMap { item in
            item.value?.removingPercentEncoding.flatMap { (item.name, $0) }
        }
        .toDictionary() ?? [:]
}

public extension Array where Element == (String, String) {
    func toDictionary() -> [String: String] {
        Dictionary(uniqueKeysWithValues: self)
    }
}

public extension URL {
    var z: ZSwiftLib<Self> {
        ZSwiftLib.init(self)
    }
}

public extension ZSwiftLib where Base == URL {
    
    /// Description  URL拼接参数
    /// - Parameter parameters: param
    /// - Returns: URL
    func appendingQueryParameters(_ parameters: [String: String]) -> URL? {
        var urlComponents = URLComponents(url: base, resolvingAgainstBaseURL: true) ?? URLComponents()
        var items = urlComponents.queryItems ?? []
        items += parameters.map({ URLQueryItem(name: $0, value: $1) })
        urlComponents.queryItems = items
        return urlComponents.url
    }
    
    /// Description 获取视频某一刻的缩略图
    /// - Parameter time: timeInterval
    /// - Returns: Image
    func thumbnail(fromTime time: Float64 = 0) -> UIImage? {
        let imageGenerator = AVAssetImageGenerator(asset: AVAsset(url: base))
        let time = CMTimeMakeWithSeconds(time, preferredTimescale: 1)
        var actualTime = CMTimeMake(value: 0, timescale: 0)
        
        guard let cgImage = try? imageGenerator.copyCGImage(at: time, actualTime: &actualTime) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
