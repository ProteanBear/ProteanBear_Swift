//
//  PbSystem.swift
//  pb.swift.basic
//  通用的系统判断方法
//  Created by Maqiang on 15/6/24.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

open class PbSystem
{
    //字体设置
    open static let fontMedium="STHeitiSC-Medium"
    open static let fontLight="STHeitiSC-Light"
    
    //默认配置文件名称
    open static let configData="DataConfig"
    open static let configUser="UserData"
    
    //尺寸配置
    open static let sizeBottomTabBarHeight=49
    open static let sizeBottomToolBarHeight=44
    open static let sizeTopStatusBarHeight=20
    open static let sizeTopTitleBarHeight=44
    open static let sizeTopMenuBarHeight=34
    open static let sizeiPhone4Width=320
    open static let sizeiPhone4Height=480
    open static let sizeiPhone5Width=320
    open static let sizeiPhone5Height=568
    open static let sizeiPhone6Width=375
    open static let sizeiPhone6Height=667
    open static let sizeiPhone6pWidth=414
    open static let sizeiPhone6pHeight=736
    open static let sizeiPadWidth=1024
    open static let sizeiPadHeight=768
    open static let sizeUpdateViewHeight=64
    
    //是否为手机端
    open class func isPhone() -> Bool
    {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    
    //是否为iPhone5
    open class func isPhone5() -> Bool
    {
        return UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? (CGSize(width: CGFloat(sizeiPhone5Width*2),height: CGFloat(sizeiPhone5Height*2)).equalTo(UIScreen.main.currentMode!.size)) : false
    }
    
    //是否为iPhone6
    open class func isPhone6() -> Bool
    {
        return UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? (CGSize(width: CGFloat(sizeiPhone6Width*2),height: CGFloat(sizeiPhone6Height*2)).equalTo(UIScreen.main.currentMode!.size)) : false
    }
    
    //是否为iPhone6p
    open class func isPhone6p() -> Bool
    {
        return UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? (CGSize(width: 1242,height: 2208).equalTo(UIScreen.main.currentMode!.size)||CGSize(width: 1125,height: 2001).equalTo(UIScreen.main.currentMode!.size)) : false
    }
    
    //获取当前系统版本号（转为浮点数）
    open class func osVersion() -> Float
    {
        return (NSString(string:UIDevice.current.systemVersion)).floatValue
    }
    
    //当前系统是否为6.0以上、7.0以下
    open class func os6() -> Bool
    {
        return osVersion()>6.0&&osVersion()<7.0
    }
    
    //当前系统是否为7.0以上、8.0以下
    open class func os7() -> Bool
    {
        return osVersion()>7.0&&osVersion()<8.0
    }
    
    //当前系统是否为8.0以上、9.0以下
    open class func os8() -> Bool
    {
        return osVersion()>8.0&&osVersion()<9.0
    }
    
    //当前系统是否为9.0以上、10.0以下
    open class func os9() -> Bool
    {
        return osVersion()>9.0&&osVersion()<10.0
    }
    
    //当前系统是否为8.0以上版本
    open class func osUp8() -> Bool
    {
        return osVersion()>8.0
    }
    
    //获取当前屏幕的宽度
    open class func screenWidth() -> CGFloat
    {
        let width=UIScreen.main.bounds.size.width
        return ( os7() && (width == CGFloat(sizeiPhone5Width)-CGFloat(sizeTopStatusBarHeight)||(width==CGFloat(sizeiPadHeight)-CGFloat(sizeTopStatusBarHeight))) ) ? (width+CGFloat(sizeTopStatusBarHeight)) : width
    }
    
    //获取当前屏幕的高度
    open class func screenHeight() -> CGFloat
    {
        let height=UIScreen.main.bounds.size.height
        return ( os7() && (height == CGFloat(sizeiPhone5Height)-CGFloat(sizeTopStatusBarHeight)||(height==CGFloat(sizeiPadWidth)-CGFloat(sizeTopStatusBarHeight))) ) ? (height+CGFloat(sizeTopStatusBarHeight)) : height
    }
    
    //获取当前屏幕的尺寸
    open class func screenSize() -> CGSize
    {
        return CGSize(width: screenWidth(),height: screenHeight())
    }
    
    //获取当前翻转模式下屏幕的宽度
    open class func screenCurrentWidth() -> CGFloat
    {
        return UIDevice.current.orientation.isLandscape ? screenHeight() : screenWidth()
    }
    
    //获取当前翻转模式下屏幕的高度
    open class func screenCurrentHeight() -> CGFloat
    {
        return UIDevice.current.orientation.isLandscape ? screenWidth() : screenHeight()
    }
    
    //获取当前翻转模式下屏幕的尺寸
    open class func screenCurrentSize() -> CGSize
    {
        return CGSize(width: screenCurrentWidth(),height: screenCurrentHeight())
    }
    
    //获取当前屏幕的宽度
    open class func screenWidth(_ full:Bool) -> CGFloat
    {
        let width=UIScreen.main.bounds.size.width
        return full ? width : self.screenWidth()
    }
    
    //获取当前屏幕的高度
    open class func screenHeight(_ full:Bool) -> CGFloat
    {
        let height=UIScreen.main.bounds.size.height
        return full ? height+(os8() ? 20:0) : self.screenHeight()
    }
    
    //获取当前屏幕的尺寸
    open class func screenSize(_ full:Bool) -> CGSize
    {
        return CGSize(width: screenWidth(full),height: screenHeight(full))
    }
    
    //获取当前翻转模式下屏幕的宽度
    open class func screenCurrentWidth(_ full:Bool) -> CGFloat
    {
        return UIDevice.current.orientation.isLandscape ? screenHeight(full) : screenWidth(full)
    }
    
    //获取当前翻转模式下屏幕的高度
    open class func screenCurrentHeight(_ full:Bool) -> CGFloat
    {
        return UIDevice.current.orientation.isLandscape ? screenWidth(full) : screenHeight(full)
    }
    
    //获取当前翻转模式下屏幕的尺寸
    open class func screenCurrentSize(_ full:Bool) -> CGSize
    {
        return CGSize(width: screenCurrentWidth(full),height: screenCurrentHeight(full))
    }
    
    //度数转化为弧度
    open class func toRadians(_ degrees:Double) -> Double
    {
        return (M_PI * (degrees))/180.0
    }
    
    //获取一个随机整数((int)((from)+(arc4random()%((to)–(from)+1)))))
    open class func toRandom(_ from:UInt32,to:UInt32) -> UInt32
    {
        return from + (arc4random() % (to - from + 1))
    }
    
    //获取整数颜色值对应的颜色设置值
    open class func toColor(_ color:Float) -> Float
    {
        return color/0xff
    }
    
    //获取指定日期类型的时间描述
    open class func stringFromDate() -> String
    {
        return stringFromDate(Date(), format: "yyyy-MM-dd HH:mm:ss")
    }
    open class func stringFromDate(_ useDescription:Bool) -> String
    {
        return stringFromDate(Date(), format: "yyyy-MM-dd HH:mm:ss")
    }
    open class func stringFromDate(_ date:Date) -> String
    {
        return stringFromDate(date, format: "yyyy-MM-dd HH:mm:ss",useDescription: true)
    }
    open class func stringFromDate(_ date:Date,useDescription:Bool) -> String
    {
        return stringFromDate(date, format: "yyyy-MM-dd HH:mm:ss",useDescription: true)
    }
    open class func stringFromDate(_ format:String) -> String
    {
        return stringFromDate(Date(), format: format,useDescription: true)
    }
    open class func stringFromDate(_ format:String,useDescription:Bool) -> String
    {
        return stringFromDate(Date(), format: format,useDescription: useDescription)
    }
    open class func stringFromDate(_ date:Date,format:String) -> String
    {
        return stringFromDate(date, format: format, useDescription: true)
    }
    open class func stringFromDate(_ date:Date,format:String,useDescription:Bool) -> String
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
    open class func stringFromDate(_ timestamp:Int64,format:String) -> String
    {
        let formatter=DateFormatter()
        formatter.dateFormat=format
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
}
