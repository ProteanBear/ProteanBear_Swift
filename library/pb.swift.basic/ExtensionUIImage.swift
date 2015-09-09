//
//  ExtensionUIImage.swift
//  pb.swift.basic
//  扩展图片对象的方法，增加裁剪等方法
//  Created by Maqiang on 15/6/24.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

extension UIImage
{
    //resizeToNewImage:将指定图片剪裁为指定的大小
    class func resizeToNewImage(image:UIImage,newSize:CGSize) -> UIImage!
    {
        if newSize.width > image.size.width || newSize.height > image.size.height
        {
            return image
        }
        
        var hRatio = newSize.width / image.size.width
        var vRatio = newSize.height / image.size.height
        var ratio = hRatio > vRatio ? hRatio : vRatio
        var scaledSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
        
        var newWidth = Int(scaledSize.width)
        var newHeight = Int(scaledSize.height)
        var bitsPerComponent = CGImageGetBitsPerComponent(image.CGImage)
        var space = CGImageGetColorSpace(image.CGImage)
        var bitmapInfo = CGImageGetBitmapInfo(image.CGImage)
        var context = CGBitmapContextCreate(nil, newWidth, newHeight, bitsPerComponent, 0, space, bitmapInfo)
        
        var rect = CGRect(origin: CGPointZero, size: scaledSize)
        CGContextDrawImage(context, rect, image.CGImage)
        var newImageRef = CGBitmapContextCreateImage(context)
        var newImage = UIImage(CGImage: newImageRef)
        
        return newImage
    }
    
    //imageWithColor:根据颜色生成图片
    class func imageWithColor(color:UIColor,size:CGSize) -> UIImage
    {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
