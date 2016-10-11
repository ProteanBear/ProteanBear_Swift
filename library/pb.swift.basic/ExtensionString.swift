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
    
    /// 获取当前时间的字符串描述，格式默认为 yyyy-MM-dd HH:mm:ss，默认为描述模式（转换为几分钟前）
    public static func date() -> String
    {
        return String.date(Date(), format: "yyyy-MM-dd HH:mm:ss")
    }
    /// 获取当前时间的字符串描述，格式默认为 yyyy-MM-dd HH:mm:ss
    /// - parameter useDescription:指定为true时使用描述模式，即转换成“几分钟前”之类的方式
    public static func date(_ useDescription:Bool) -> String
    {
        return String.date(Date(), format: "yyyy-MM-dd HH:mm:ss",useDescription:useDescription)
    }
    /// 获取指定时间的字符串描述，格式默认为 yyyy-MM-dd HH:mm:ss，默认为描述模式（转换为几分钟前）
    /// - parameter date :指定时间
    public static func date(_ date:Date) -> String
    {
        return String.date(date, format: "yyyy-MM-dd HH:mm:ss",useDescription: true)
    }
    /// 获取指定时间的字符串描述，格式默认为 yyyy-MM-dd HH:mm:ss
    /// - parameter date :指定时间
    /// - parameter useDescription:指定为true时使用描述模式，即转换成“几分钟前”之类的方式
    public static func date(_ date:Date,useDescription:Bool) -> String
    {
        return String.date(date, format: "yyyy-MM-dd HH:mm:ss",useDescription: true)
    }
    /// 获取当前时间的字符串描述并指定格式，默认为描述模式（转换为几分钟前）
    /// - parameter format :指定格式
    public static func date(_ format:String) -> String
    {
        return String.date(Date(), format: format,useDescription: true)
    }
    /// 获取当前时间的字符串描述并指定格式
    /// - parameter format :指定格式
    /// - parameter useDescription:指定为true时使用描述模式，即转换成“几分钟前”之类的方式
    public static func date(_ format:String,useDescription:Bool) -> String
    {
        return String.date(Date(), format: format,useDescription: useDescription)
    }
    /// 获取指定时间的字符串描述并指定格式，默认为描述模式（转换为几分钟前）
    /// - parameter date :指定时间
    /// - parameter format :指定格式
    public static func date(_ date:Date,format:String) -> String
    {
        return String.date(date, format: format, useDescription: true)
    }
    /// 获取指定时间的字符串描述并指定格式
    /// - parameter date :指定时间
    /// - parameter format :指定格式
    /// - parameter useDescription:指定为true时使用描述模式，即转换成“几分钟前”之类的方式
    public static func date(_ date:Date,format:String,useDescription:Bool) -> String
    {
        let formatter=DateFormatter()
        var result=""
        
        if(useDescription)
        {
            let interval=date.timeIntervalSince(Date())
            if(interval<60)             {result="刚刚更新"}
            else if(interval<60*60)     {result=(interval/60).description+"分钟前"}
            else if(interval<60*60*24)
            {
                formatter.dateFormat="HH:mm"
                result=formatter.string(from: date)
            }
            else
            {
                formatter.dateFormat=format
                result=formatter.string(from: date)
            }
        }
        else
        {
            formatter.dateFormat=format
            result=formatter.string(from: date)
        }
        
        return result
    }
    /// 获取指定时间戳的字符串描述并指定格式
    /// - parameter timestamp :时间戳
    /// - parameter format :指定格式
    public static func date(_ timestamp:Int64,format:String) -> String
    {
        let formatter=DateFormatter()
        formatter.dateFormat=format
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
}
