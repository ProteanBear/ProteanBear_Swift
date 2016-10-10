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
    //pbScale:缩放指定的图片,等比例缩放
    public class func pbScale(_ image:UIImage,scale:CGFloat) -> UIImage!
    {
        UIGraphicsBeginImageContext(CGSize(width: image.size.width * scale,height: image.size.height * scale))
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width * scale, height: image.size.height * scale))
        let result=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    //pbScale:缩放指定的图片,指定尺寸
    public class func pbScale(_ image:UIImage,size:CGSize) -> UIImage!
    {
        UIGraphicsBeginImageContext(CGSize(width: size.width,height: size.height))
        image.draw(in: CGRect(x: 0, y: 0,width: size.width,height: size.height))
        let result=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    //pbResizeToNew:将指定图片剪裁为指定的大小
    public class func pbResize(_ image:UIImage,to size:CGSize) -> UIImage!
    {
        if size.width > image.size.width || size.height > image.size.height
        {
            return image
        }
        
        let hRatio = size.width / image.size.width
        let vRatio = size.height / image.size.height
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
    
    //pbGenerateBy:根据颜色生成图片
    public class func pbGenerateBy(_ color:UIColor,size:CGSize) -> UIImage
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
