//
//  ExtensionString.swift
//  pb.swift.basic
//  扩展String对象
//  Created by Maqiang on 15/6/17.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation

extension String
{
    //计算文字的尺寸
    public func pbTextSize(_ size:CGSize,font:UIFont) -> CGSize
    {
        let attribute = [NSFontAttributeName: font]
        let rect=NSString(string:self).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        return CGSize(width: rect.width, height: rect.height)
    }
    
    //计算文字的高度
    public func pbTextHeight(_ width:CGFloat,font:UIFont) -> CGFloat
    {
        let attribute = [NSFontAttributeName: font]
        let size=CGSize(width: width, height: 0)
        let rect=NSString(string:self).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        return rect.height
    }
}
