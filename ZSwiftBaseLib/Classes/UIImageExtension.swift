//
//  UIImageExtension.swift
//  Pods
//
//  Created by 朱继超 on 2022/6/29.
//

import UIKit
import Foundation

public extension UIImage {
    
    var z: ZSwiftLib<UIImage> {
        return ZSwiftLib(self)
    }
    
}

public extension UIImage {
    /// 等比缩放图片 (注：压缩后的image转成data去使用的时候又把图片变大了)
    /// - Parameter scale: 缩放比例
    func scaleZoomImage(scale: CGFloat) -> UIImage?{
        let reSize = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        return resetImgSize(size: reSize)
    }
    
    /// 重置图片大小 (注：压缩后的image转成data去使用的时候又把图片变大了)
    /// - Parameter size: 图片大小
    func resetImgSize(size: CGSize) -> UIImage?{
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resultImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImg
    }
    /// 直接使用data进行压缩
    /// - Parameter toKb: 指定data最大的体积
    /// - Returns: data
    func compressOriginalImage(_ toKb: Int = 1024000) -> Data?{
        var compression: CGFloat = 1
        let minCompression: CGFloat = 0.1
        var imageData = self.jpegData(compressionQuality: compression)
        if imageData!.count < toKb {
            return imageData
        }
        while imageData!.count > toKb, compression > minCompression {
            compression -= 0.1
            imageData = self.jpegData(compressionQuality: compression)
        }
        if imageData!.count > toKb {
            return nil
        }
        return imageData
    }
}




