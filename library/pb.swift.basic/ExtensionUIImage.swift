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
    //scaleImage:缩放指定的图片,等比例缩放
    public class func scaleImage(image:UIImage,toScale:CGFloat) -> UIImage!
    {
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width * toScale,image.size.height * toScale))
        image.drawInRect(CGRectMake(0, 0, image.size.width * toScale, image.size.height * toScale))
        let result=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    //scaleImage:缩放指定的图片,指定尺寸
    public class func scaleImage(image:UIImage,toSize:CGSize) -> UIImage!
    {
        UIGraphicsBeginImageContext(CGSizeMake(toSize.width,toSize.height))
        image.drawInRect(CGRectMake(0, 0,toSize.width,toSize.height))
        let result=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    //resizeToNewImage:将指定图片剪裁为指定的大小
    public class func resizeToNewImage(image:UIImage,newSize:CGSize) -> UIImage!
    {
        if newSize.width > image.size.width || newSize.height > image.size.height
        {
            return image
        }
        
        let hRatio = newSize.width / image.size.width
        let vRatio = newSize.height / image.size.height
        let ratio = hRatio > vRatio ? hRatio : vRatio
        let scaledSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
        
        let newWidth = Int(scaledSize.width)
        let newHeight = Int(scaledSize.height)
        let bitsPerComponent = CGImageGetBitsPerComponent(image.CGImage)
        let space = CGImageGetColorSpace(image.CGImage)
        let bitmapInfo = CGImageGetBitmapInfo(image.CGImage)
        let context = CGBitmapContextCreate(nil, newWidth, newHeight, bitsPerComponent, 0, space, bitmapInfo.rawValue)
        
        let rect = CGRect(origin: CGPointZero, size: scaledSize)
        CGContextDrawImage(context, rect, image.CGImage)
        let newImageRef = CGBitmapContextCreateImage(context)
        let newImage = UIImage(CGImage: newImageRef!)
        
        return newImage
    }
    
    //imageWithColor:根据颜色生成图片
    public class func imageWithColor(color:UIColor,size:CGSize) -> UIImage
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
