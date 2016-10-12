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
    /// 默认加重字体（黑体）
    open static let fontMedium="STHeitiSC-Medium"
    /// 默认正常字体（黑体）
    open static let fontLight="STHeitiSC-Light"
    
    //默认配置文件名称
    /// 默认通讯配置资源文件名称
    open static let configData="DataConfig"
    /// 默认用户数据配置资源文件名称
    open static let configUser="UserData"
    
    //尺寸配置
    /// 底部TabBar高度
    open static let sizeBottomTabBarHeight=49
    /// 底部ToolBar高度
    open static let sizeBottomToolBarHeight=44
    /// 顶部状态栏高度
    open static let sizeTopStatusBarHeight=20
    /// 顶部标题栏高度
    open static let sizeTopTitleBarHeight=44
    /// 顶部菜单切换栏高度
    open static let sizeTopMenuBarHeight=34
    /// iPhone4 屏幕宽度（px）
    open static let sizeiPhone4Width=320
    /// iPhone4 屏幕高度（px）
    open static let sizeiPhone4Height=480
    /// iPhone5 屏幕宽度（px）
    open static let sizeiPhone5Width=320
    /// iPhone5 屏幕高度（px）
    open static let sizeiPhone5Height=568
    /// iPhone6 屏幕宽度（px）
    open static let sizeiPhone6Width=375
    /// iPhone6 屏幕高度（px）
    open static let sizeiPhone6Height=667
    /// iPhone6p 屏幕宽度（px）
    open static let sizeiPhone6pWidth=414
    /// iPhone6p 屏幕高度（px）
    open static let sizeiPhone6pHeight=736
    /// iPad横向 屏幕宽度（px）
    open static let sizeiPadWidth=1024
    /// iPad横向 屏幕高度（px）
    open static let sizeiPadHeight=768
    /// 表格下拉更新组件的高度
    open static let sizeUpdateViewHeight=64
    
    /// 设备是否为手机端
    open static var isPhone:Bool{
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    /// 设备是否为iPhone5
    open static var isPhone5:Bool{
        return UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? (CGSize(width: CGFloat(sizeiPhone5Width*2),height: CGFloat(sizeiPhone5Height*2)).equalTo(UIScreen.main.currentMode!.size)) : false
    }
    /// 设备是否为iPhone6
    open static var isPhone6:Bool{
        return UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? (CGSize(width: CGFloat(sizeiPhone6Width*2),height: CGFloat(sizeiPhone6Height*2)).equalTo(UIScreen.main.currentMode!.size)) : false
    }
    /// 设备是否为iPhone6p
    open static var isPhone6p:Bool{
        return UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? (CGSize(width: 1242,height: 2208).equalTo(UIScreen.main.currentMode!.size)||CGSize(width: 1125,height: 2001).equalTo(UIScreen.main.currentMode!.size)) : false
    }
    
    /// 当前系统版本号（转为浮点数）
    open static var osVersion:Float{
        return (NSString(string:UIDevice.current.systemVersion)).floatValue
    }
    /// 当前系统是否为6.0以上、7.0以下
    open static var os6:Bool{return osVersion>6.0&&osVersion<7.0}
    /// 当前系统是否为7.0以上、8.0以下
    open static var os7:Bool{return osVersion>7.0&&osVersion<8.0}
    /// 当前系统是否为8.0以上、9.0以下
    open static var os8:Bool{return osVersion>8.0&&osVersion<9.0}
    /// 当前系统是否为9.0以上、10.0以下
    open static var os9:Bool{return osVersion>9.0&&osVersion<10.0}
    /// 当前系统是否为8.0以上版本
    open static var osUp8:Bool{return osVersion>8.0}
    /// 当前系统是否为9.0以上版本
    open static var osUp9:Bool{return osVersion>9.0}
    /// 当前系统是否为10.0以上版本
    open static var osUp10:Bool{return osVersion>10.0}
    
    /// 屏幕的宽度
    open static var screenWidth:CGFloat{
        return UIScreen.main.bounds.size.width
    }
    /// 屏幕的高度
    open static var screenHeight:CGFloat{
        return UIScreen.main.bounds.size.height
    }
    /// 屏幕的尺寸
    open static var screenSize:CGSize{
        return CGSize(width: screenWidth,height: screenHeight)
    }
    /// 当前翻转模式下屏幕的宽度
    open static var screenCurrentWidth:CGFloat
    {
        return UIDevice.current.orientation.isLandscape ? screenHeight : screenWidth
    }
    /// 当前翻转模式下屏幕的高度
    open static var screenCurrentHeight:CGFloat{
        return UIDevice.current.orientation.isLandscape ? screenWidth : screenHeight
    }
    
    /// 当前翻转模式下屏幕的尺寸
    open static var screenCurrentSize:CGSize{
        return CGSize(width: screenCurrentWidth,height: screenCurrentHeight)
    }
}
