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
    /// 计算当前文字的尺寸
    /// - parameter size:尺寸（宽度为0获取高度；高度为0获取宽度）
    /// - parameter font:字体
    public func pbTextSize(_ size:CGSize,font:UIFont) -> CGSize
    {
        let attribute = [NSFontAttributeName: font]
        let rect=NSString(string:self).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        return CGSize(width: rect.width, height: rect.height)
    }
    
    /// 计算当前文字的高度
    /// - parameter width   :限制文字的宽度
    /// - parameter font    :字体
    public func pbTextHeight(_ width:CGFloat,font:UIFont) -> CGFloat
    {
        let attribute = [NSFontAttributeName: font]
        let size=CGSize(width: width, height: 0)
        let rect=NSString(string:self).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        return rect.height
    }
}
