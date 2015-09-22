//
//  PbSystem.swift
//  pb.swift.basic
//  通用的系统判断方法
//  Created by Maqiang on 15/6/24.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

class PbSystem
{
    //字体设置
    static let fontMedium="STHeitiSC-Medium"
    static let fontLight="STHeitiSC-Light"
    
    //默认配置文件名称
    static let configData="DataConfig"
    static let configUser="UserData"
    
    //尺寸配置
    static let sizeBottomTabBarHeight=49
    static let sizeBottomToolBarHeight=44
    static let sizeTopStatusBarHeight=20
    static let sizeTopTitleBarHeight=44
    static let sizeTopMenuBarHeight=34
    static let sizeTopDecorationHeight=20
    static let sizeiPhone4Width=320
    static let sizeiPhone4Height=480
    static let sizeiPhone5Width=320
    static let sizeiPhone5Height=568
    static let sizeiPhone6Width=375
    static let sizeiPhone6Height=667
    static let sizeiPhone6pWidth=414
    static let sizeiPhone6pHeight=736
    static let sizeiPadWidth=1024
    static let sizeiPadHeight=768
    static let sizeUpdateViewHeight=64
    
    //是否为手机端
    class func isPhone() -> Bool
    {
        return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone
    }
    
    //是否为iPhone5
    class func isPhone5() -> Bool
    {
        return UIScreen.instancesRespondToSelector(Selector("currentMode")) ? (CGSizeEqualToSize(CGSizeMake(CGFloat(sizeiPhone5Width*2),CGFloat(sizeiPhone5Height*2)),UIScreen.mainScreen().currentMode!.size)) : false
    }
    
    //是否为iPhone6
    class func isPhone6() -> Bool
    {
        return UIScreen.instancesRespondToSelector(Selector("currentMode")) ? (CGSizeEqualToSize(CGSizeMake(CGFloat(sizeiPhone6Width*2),CGFloat(sizeiPhone6Height*2)),UIScreen.mainScreen().currentMode!.size)) : false
    }
    
    //是否为iPhone6p
    class func isPhone6p() -> Bool
    {
        return UIScreen.instancesRespondToSelector(Selector("currentMode")) ? (CGSizeEqualToSize(CGSizeMake(1242,2208),UIScreen.mainScreen().currentMode!.size)||CGSizeEqualToSize(CGSizeMake(1125,2001),UIScreen.mainScreen().currentMode!.size)) : false
    }
    
    //获取当前系统版本号（转为浮点数）
    class func osVersion() -> Float
    {
        return (NSString(string:UIDevice.currentDevice().systemVersion)).floatValue
    }
    
    //当前系统是否为6.0以上、7.0以下
    class func os6() -> Bool
    {
        return osVersion()>6.0&&osVersion()<7.0
    }
    
    //当前系统是否为7.0以上、8.0以下
    class func os7() -> Bool
    {
        return osVersion()>7.0&&osVersion()<8.0
    }
    
    //当前系统是否为8.0以上、9.0以下
    class func os8() -> Bool
    {
        return osVersion()>8.0&&osVersion()<9.0
    }
    
    //当前系统是否为8.0以上版本
    class func osUp8() -> Bool
    {
        return osVersion()>8.0
    }
    
    //获取当前屏幕的宽度
    class func screenWidth() -> CGFloat
    {
        let width=UIScreen.mainScreen().applicationFrame.size.width
        return ( os7() && (width == CGFloat(sizeiPhone5Width)-CGFloat(sizeTopStatusBarHeight)||(width==CGFloat(sizeiPadHeight)-CGFloat(sizeTopStatusBarHeight))) ) ? (width+CGFloat(sizeTopStatusBarHeight)) : width
    }
    
    //获取当前屏幕的高度
    class func screenHeight() -> CGFloat
    {
        let height=UIScreen.mainScreen().applicationFrame.size.height
        return ( os7() && (height == CGFloat(sizeiPhone5Height)-CGFloat(sizeTopStatusBarHeight)||(height==CGFloat(sizeiPadWidth)-CGFloat(sizeTopStatusBarHeight))) ) ? (height+CGFloat(sizeTopStatusBarHeight)) : height
    }
    
    //获取当前屏幕的尺寸
    class func screenSize() -> CGSize
    {
        return CGSizeMake(screenWidth(),screenHeight())
    }
    
    //获取当前翻转模式下屏幕的宽度
    class func screenCurrentWidth() -> CGFloat
    {
        return UIDevice.currentDevice().orientation.isLandscape ? screenHeight() : screenWidth()
    }
    
    //获取当前翻转模式下屏幕的高度
    class func screenCurrentHeight() -> CGFloat
    {
        return UIDevice.currentDevice().orientation.isLandscape ? screenWidth() : screenHeight()
    }
    
    //获取当前翻转模式下屏幕的尺寸
    class func screenCurrentSize() -> CGSize
    {
        return CGSizeMake(screenCurrentWidth(),screenCurrentHeight())
    }
    
    //获取当前屏幕的宽度
    class func screenWidth(full:Bool) -> CGFloat
    {
        let width=UIScreen.mainScreen().applicationFrame.size.width
        return full ? width : self.screenWidth()
    }
    
    //获取当前屏幕的高度
    class func screenHeight(full:Bool) -> CGFloat
    {
        let height=UIScreen.mainScreen().applicationFrame.size.height
        return full ? height+(os8() ? 20:0) : self.screenHeight()
    }
    
    //获取当前屏幕的尺寸
    class func screenSize(full:Bool) -> CGSize
    {
        return CGSizeMake(screenWidth(full),screenHeight(full))
    }
    
    //获取当前翻转模式下屏幕的宽度
    class func screenCurrentWidth(full:Bool) -> CGFloat
    {
        return UIDevice.currentDevice().orientation.isLandscape ? screenHeight(full) : screenWidth(full)
    }
    
    //获取当前翻转模式下屏幕的高度
    class func screenCurrentHeight(full:Bool) -> CGFloat
    {
        return UIDevice.currentDevice().orientation.isLandscape ? screenWidth(full) : screenHeight(full)
    }
    
    //获取当前翻转模式下屏幕的尺寸
    class func screenCurrentSize(full:Bool) -> CGSize
    {
        return CGSizeMake(screenCurrentWidth(full),screenCurrentHeight(full))
    }
    
    //度数转化为弧度
    class func toRadians(degrees:Double) -> Double
    {
        return (M_PI * (degrees))/180.0
    }
    
    //获取一个随机整数((int)((from)+(arc4random()%((to)–(from)+1)))))
    class func toRandom(from:UInt32,to:UInt32) -> UInt32
    {
        return from + (arc4random() % (to - from + 1))
    }
    
    //获取整数颜色值对应的颜色设置值
    class func toColor(color:Float) -> Float
    {
        return color/255.00
    }
    
    //获取指定日期类型的时间描述
    class func stringFromDate() -> String
    {
        return stringFromDate(NSDate(), format: "yyyy-MM-dd HH:mm:ss")
    }
    class func stringFromDate(useDescription:Bool) -> String
    {
        return stringFromDate(NSDate(), format: "yyyy-MM-dd HH:mm:ss")
    }
    class func stringFromDate(date:NSDate) -> String
    {
        return stringFromDate(date, format: "yyyy-MM-dd HH:mm:ss",useDescription: true)
    }
    class func stringFromDate(date:NSDate,useDescription:Bool) -> String
    {
        return stringFromDate(date, format: "yyyy-MM-dd HH:mm:ss",useDescription: true)
    }
    class func stringFromDate(format:String) -> String
    {
        return stringFromDate(NSDate(), format: format,useDescription: true)
    }
    class func stringFromDate(format:String,useDescription:Bool) -> String
    {
        return stringFromDate(NSDate(), format: format,useDescription: useDescription)
    }
    class func stringFromDate(date:NSDate,format:String) -> String
    {
        return stringFromDate(date, format: format, useDescription: true)
    }
    class func stringFromDate(date:NSDate,format:String,useDescription:Bool) -> String
    {
        let formatter=NSDateFormatter()
        var result=""
        
        if(useDescription)
        {
            let interval=date.timeIntervalSinceDate(NSDate())
            if(interval<60)             {result="刚刚更新"}
            else if(interval<60*60)     {result=(interval/60).description+"分钟前"}
            else if(interval<60*60*24)
            {
                formatter.dateFormat="HH:mm"
                result=formatter.stringFromDate(date)
            }
            else
            {
                formatter.dateFormat=format
                result=formatter.stringFromDate(date)
            }
        }
        
        return result
    }
    class func stringFromDate(timestamp:Int64,format:String) -> String
    {
        let formatter=NSDateFormatter()
        formatter.dateFormat=format
        return formatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval(timestamp)))
    }
}
