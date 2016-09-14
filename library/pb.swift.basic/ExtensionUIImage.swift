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
    public class func scaleImage(_ image:UIImage,toScale:CGFloat) -> UIImage!
    {
        UIGraphicsBeginImageContext(CGSize(width: image.size.width * toScale,height: image.size.height * toScale))
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width * toScale, height: image.size.height * toScale))
        let result=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    //scaleImage:缩放指定的图片,指定尺寸
    public class func scaleImage(_ image:UIImage,toSize:CGSize) -> UIImage!
    {
        UIGraphicsBeginImageContext(CGSize(width: toSize.width,height: toSize.height))
        image.draw(in: CGRect(x: 0, y: 0,width: toSize.width,height: toSize.height))
        let result=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    //resizeToNewImage:将指定图片剪裁为指定的大小
    public class func resizeToNewImage(_ image:UIImage,newSize:CGSize) -> UIImage!
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
        let bitsPerComponent = image.cgImage?.bitsPerComponent
        let space = image.cgImage?.colorSpace
        let bitmapInfo = image.cgImage?.bitmapInfo
        let context = CGContext(data: nil, width: newWidth, height: newHeight, bitsPerComponent: bitsPerComponent!, bytesPerRow: 0, space: space!, bitmapInfo: (bitmapInfo?.rawValue)!)
        
        let rect = CGRect(origin: CGPoint.zero, size: scaledSize)
        context?.draw(image.cgImage!, in: rect)
        let newImageRef = context?.makeImage()
        let newImage = UIImage(cgImage: newImageRef!)
        
        return newImage
    }
    
    //imageWithColor:根据颜色生成图片
    public class func imageWithColor(_ color:UIColor,size:CGSize) -> UIImage
    {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
