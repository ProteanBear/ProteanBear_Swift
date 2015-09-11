//
//  ExtensionUIColor.swift
//  pb.swift.basic
//  扩展系统设定颜色值
//  Created by Maqiang on 15/7/15.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

//扩展标准颜色值
extension UIColor
{
    //红色（Red）
    static let standardRedColor:Array<UInt32>=[
        0xfde0dc,0xf9bdbb,0xf69988,0xf36c60,0xe84e40,
        0xe51c23,0xdd191d,0xd01716,0xc41411,0xb0120a,
        0xff7997,0xff5177,0xff2d6f,0xe00032
    ]
    //粉色（Pink）
    static let standardPinkColor:Array<UInt32>=[
        0xfce4ec,0xf8bbd0,0xf48fb1,0xf06292,0xec407a,
        0xe91e63,0xd81b60,0xc2185b,0xad1457,0x880e4f,
        0xff80ab,0xff4081,0xf50057,0xc51162
    ]
    //紫色（Purple）
    static let standardPurpleColor:Array<UInt32>=[
        0xf3e5f5,0xe1bee7,0xce93d8,0xba68c8,0xab47bc,
        0x9c27b0,0x8e24aa,0x7b1fa2,0x6a1b9a,0x4a148c,
        0xea80fc,0xe040fb,0xd500f9,0xaa00ff
    ]
    
    //深紫色（Deep Purple）
    static let standardPurpleDeepColor:Array<UInt32>=[
        0xede7f6,0xd1c4e9,0xb39ddb,0x9575cd,0x7e57c2,
        0x673ab7,0x5e35b1,0x512da8,0x4527a0,0x311b92,
        0xb388ff,0x7c4dff,0x651fff,0x6200ea
    ]
    //靛蓝色（Indigo）
    static let standardIndigoColor:Array<UInt32>=[
        0xe8eaf6,0xc5cae9,0x9fa8da,0x7986cb,0x5c6bc0,
        0x3f51b5,0x3949ab,0x303f9f,0x283593,0x1a237e,
        0x8c9eff,0x526dfe,0x3d5afe,0x304ffe
    ]
    //蓝色（Blue）
    static let standardBlueColor:Array<UInt32>=[
        0xe7e9fd,0xd0d9ff,0xafbfff,0x91a7ff,0x738ffe,
        0x5677fc,0x4e6cef,0x455ede,0x3b50ce,0x2a36b1,
        0xa6baff,0x6889ff,0x4d73ff,0x4d69ff
    ]
    
    //浅蓝色（Light Blue）
    static let standardBlueLightColor:Array<UInt32>=[
        0xe1f5fe,0xb3e5fc,0x81d4fa,0x4fc3f7,0x29b6f6,
        0x03a9f4,0x039be5,0x0288d1,0x0277bd,0x01579b,
        0x80d8ff,0x40c4ff,0x00b0ff,0x0091ea
    ]
    //青色（Cyan）
    static let standardCyanColor:Array<UInt32>=[
        0xe0f7fa,0xb2ebf2,0x80deea,0x4dd0e1,0x26c6da,
        0x00bcd4,0x00acc1,0x0097a7,0x00838f,0x006064,
        0x84ffff,0x18ffff,0x00e5ff,0x00b8d4
    ]
    //蓝绿色（Teal）
    static let standardTealColor:Array<UInt32>=[
        0xe0f2f1,0xb2dfdb,0x80cbc4,0x4db6ac,0x26a69a,
        0x009688,0x00897b,0x00796b,0x00695c,0x004d40,
        0xa7ffeb,0x64ffda,0x1de9b6,0x00bfa5
    ]
    
    //获取RGB值
    class func pbUInt32ToFloatRed(value:UInt32) -> CGFloat
    {
        return CGFloat(Double((value & 0xFF0000) >> 16) / Double(0xff))
    }
    class func pbUInt32ToFloatGreen(value:UInt32) -> CGFloat
    {
        return CGFloat(Double((value & 0x00FF00) >> 8) / Double(0xff))
    }
    class func pbUInt32ToFloatBlue(value:UInt32) -> CGFloat
    {
        return CGFloat(Double(value & 0x0000FF) / Double(0xff))
    }
}

//PbUIColorLevel:颜色级别
enum PbUIColorLevel:Int
{
    //枚举值
    case level50,level100,level200,level300,level400,level500,level600,level700,level800,level900,levelA100,levelA200,levelA400,levelA700
    //描述
    var description:String{
        switch self{
            case .level50:return "50"
            case .level100:return "100"
            case .level200:return "200"
            case .level300:return "300"
            case .level400:return "400"
            case .level500:return "500"
            case .level600:return "600"
            case .level700:return "700"
            case .level800:return "800"
            case .level900:return "900"
            case .levelA100:return "A100"
            case .levelA200:return "A200"
            case .levelA400:return "A400"
            case .levelA700:return "A700"
            default:return "0"
        }
    }
    
    //标准颜色值
    //红色（Red）
    var redColor:UIColor{
        let color=UIColor.standardRedColor[self.rawValue]
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha: 1)
    }
    //粉色（Pink）
    var pinkColor:UIColor{
        let color=UIColor.standardPinkColor[self.rawValue]
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha: 1)
    }
    //紫色（Purple）
    var purpleColor:UIColor{
        let color=UIColor.standardPurpleColor[self.rawValue]
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha: 1)
    }
    
    //深紫色（Deep Purple）
    var purpleDeepColor:UIColor{
        let color=UIColor.standardPurpleDeepColor[self.rawValue]
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha: 1)
    }
    //靛蓝色（Indigo）
    var indigoColor:UIColor{
        let color=UIColor.standardIndigoColor[self.rawValue]
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha: 1)
    }
    //蓝色（Blue）
    var blueColor:UIColor{
        let color=UIColor.standardBlueColor[self.rawValue]
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha: 1)
    }
    
    //浅蓝色（Light Blue）
    var blueLightColor:UIColor{
        let color=UIColor.standardBlueLightColor[self.rawValue]
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha: 1)
    }
    //青色（Cyan）
    var cyanColor:UIColor{
        let color=UIColor.standardCyanColor[self.rawValue]
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha: 1)
    }
    //蓝绿色（Teal）
    var tealColor:UIColor{
        let color=UIColor.standardTealColor[self.rawValue]
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha: 1)
    }
    
    //获取颜色值的描述
    func colorDescription(standardColor:Array<UInt32>) -> String
    {
        return String(format:"#%06x",standardColor[self.rawValue])
    }
}

extension UIColor
{
    //-----------------------开始：Design标准颜色值
    //levelName:获取级别名称
    class func pbLevelName(levelRaw:Int) -> String
    {
        return PbUIColorLevel(rawValue: levelRaw)!.description
    }
    
    //红色Red
    class func pbRedColor(levelRaw:Int) -> UIColor
    {
        return pbRedColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    class func pbRedColor(level:PbUIColorLevel) -> UIColor
    {
        return level.redColor
    }
    class func pbRedColorValue(levelRaw:Int) -> String
    {
        return pbRedColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    class func pbRedColorValue(level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardRedColor)
    }
    
    //粉色Pink
    class func pbPinkColor(levelRaw:Int) -> UIColor
    {
        return pbPinkColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    class func pbPinkColor(level:PbUIColorLevel) -> UIColor
    {
        return level.pinkColor
    }
    class func pbPinkColorValue(levelRaw:Int) -> String
    {
        return pbPinkColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    class func pbPinkColorValue(level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardPinkColor)
    }
    
    //紫色Purple
    class func pbPurpleColor(levelRaw:Int) -> UIColor
    {
        return pbPurpleColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    class func pbPurpleColor(level:PbUIColorLevel) -> UIColor
    {
        return level.purpleColor
    }
    class func pbPurpleColorValue(levelRaw:Int) -> String
    {
        return pbPurpleColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    class func pbPurpleColorValue(level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardPurpleColor)
    }
    
    //深紫色DeepPurple
    class func pbPurpleDeepColor(levelRaw:Int) -> UIColor
    {
        return pbPurpleDeepColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    class func pbPurpleDeepColor(level:PbUIColorLevel) -> UIColor
    {
        return level.purpleDeepColor
    }
    class func pbPurpleDeepColorValue(levelRaw:Int) -> String
    {
        return pbPurpleDeepColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    class func pbPurpleDeepColorValue(level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardPurpleDeepColor)
    }
    
    //靛蓝色Indigo
    class func pbIndigoColor(levelRaw:Int) -> UIColor
    {
        return pbIndigoColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    class func pbIndigoColor(level:PbUIColorLevel) -> UIColor
    {
        return level.indigoColor
    }
    class func pbIndigoColorValue(levelRaw:Int) -> String
    {
        return pbIndigoColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    class func pbIndigoColorValue(level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardIndigoColor)
    }
    
    //蓝色Blue
    class func pbBlueColor(levelRaw:Int) -> UIColor
    {
        return pbBlueColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    class func pbBlueColor(level:PbUIColorLevel) -> UIColor
    {
        return level.blueColor
    }
    class func pbBlueColorValue(levelRaw:Int) -> String
    {
        return pbBlueColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    class func pbBlueColorValue(level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardBlueColor)
    }
    
    //浅蓝色LightBlue
    class func pbBlueLightColor(levelRaw:Int) -> UIColor
    {
        return pbBlueLightColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    class func pbBlueLightColor(level:PbUIColorLevel) -> UIColor
    {
        return level.blueLightColor
    }
    class func pbBlueLightColorValue(levelRaw:Int) -> String
    {
        return pbBlueLightColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    class func pbBlueLightColorValue(level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardBlueLightColor)
    }
    
    //青色Cyan
    class func pbCyanColor(levelRaw:Int) -> UIColor
    {
        return pbCyanColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    class func pbCyanColor(level:PbUIColorLevel) -> UIColor
    {
        return level.cyanColor
    }
    class func pbCyanColorValue(levelRaw:Int) -> String
    {
        return pbCyanColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    class func pbCyanColorValue(level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardCyanColor)
    }
    
    //蓝绿色Teal
    class func pbTealColor(levelRaw:Int) -> UIColor
    {
        return pbTealColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    class func pbTealColor(level:PbUIColorLevel) -> UIColor
    {
        return level.tealColor
    }
    class func pbTealColorValue(levelRaw:Int) -> String
    {
        return pbTealColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    class func pbTealColorValue(level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardTealColor)
    }
    //-----------------------结束：Design标准颜色值
    
    //-----------------------开始：iOS常用颜色值
    //黑灰色系
    //象牙黑（#292421）
    class func pbIvoryBlackColor() -> UIColor
    {
        return UIColor(red: 0x29/0xff, green: 0x24/0xff, blue: 0x21/0xff, alpha: 1)
    }
    //冷灰（#808A87）
    class func pbColdGrayColor() -> UIColor
    {
        return UIColor(red: 0x80/0xff, green: 0x8a/0xff, blue: 0x87/0xff, alpha: 1)
    }
    //石板灰（#708069）
    class func pbSlateGrayColor() -> UIColor
    {
        return UIColor(red: 0x70/0xff, green: 0x80/0xff, blue: 0x69/0xff, alpha: 1)
    }
    //暖灰色（#808069）
    class func pbWarmGrayColor() -> UIColor
    {
        return UIColor(red: 0x80/0xff, green: 0x80/0xff, blue: 0x69/0xff, alpha: 1)
    }
    
    //白色系
    //古董白（#FAEBD7）
    class func pbAntiqueWhiteColor() -> UIColor
    {
        return UIColor(red: 0xfa/0xff, green: 0xeb/0xff, blue: 0xd7/0xff, alpha: 1)
    }
    //天蓝色（#F0FFFF）
    class func pbSkyBlueColor() -> UIColor
    {
        return UIColor(red: 0xf0/0xff, green: 0xff/0xff, blue: 0xff/0xff, alpha: 1)
    }
    //白烟（#F5F5F5）
    class func pbSmokeWhiteColor() -> UIColor
    {
        return UIColor(red: 0xf5/0xff, green: 0xf5/0xff, blue: 0xf5/0xff, alpha: 1)
    }
    //白杏仁（#FFFFCD）
    class func pbAlmondWhiteColor() -> UIColor
    {
        return UIColor(red: 0xff/0xff, green: 0xff/0xff, blue: 0xcd/0xff, alpha: 1)
    }
    //cornsilk（#FFF8DC）
    class func pbCornsilkColor() -> UIColor
    {
        return UIColor(red: 0xff/0xff, green: 0xf8/0xff, blue: 0xdc/0xff, alpha: 1)
    }
    //蛋壳色（#FCE6C9）
    class func pbYellowEggColor() -> UIColor
    {
        return UIColor(red: 0xfc/0xff, green: 0xe6/0xff, blue: 0xc9/0xff, alpha: 1)
    }
    //花白（#FFFAF0）
    class func pbFloralWhiteColor() -> UIColor
    {
        return UIColor(red: 0xff/0xff, green: 0xfa/0xff, blue: 0xf0/0xff, alpha: 1)
    }
    //gainsboro（#DCDCDC）
    class func pbGainsboroColor() -> UIColor
    {
        return UIColor(red: 0xdc/0xff, green: 0xdc/0xff, blue: 0xdc/0xff, alpha: 1)
    }
    //ghostWhite（#F8F8FF）
    class func pbGhostWhiteColor() -> UIColor
    {
        return UIColor(red: 0xf8/0xff, green: 0xf8/0xff, blue: 0xff/0xff, alpha: 1)
    }
    //蜜露橙（#F0FFF0）
    class func pbHoneyDewColor() -> UIColor
    {
        return UIColor(red: 0xf0/0xff, green: 0xff/0xff, blue: 0xf0/0xff, alpha: 1)
    }
    //象牙白（#FAFFF0）
    class func pbIvoryWhiteColor() -> UIColor
    {
        return UIColor(red: 0xfa/0xff, green: 0xff/0xff, blue: 0xf0/0xff, alpha: 1)
    }
    //亚麻色（#FAF0E6）
    class func pbFlaxenColor() -> UIColor
    {
        return UIColor(red: 0xfa/0xff, green: 0xf0/0xff, blue: 0xe6/0xff, alpha: 1)
    }
    //navajoWhite（#FFDEAD）
    class func pbNavajoWhiteColor() -> UIColor
    {
        return UIColor(red: 0xff/0xff, green: 0xde/0xff, blue: 0xad/0xff, alpha: 1)
    }
    //oldLace（#FDF5E6）
    class func pbOldLaceColor() -> UIColor
    {
        return UIColor(red: 0xfd/0xff, green: 0xf5/0xff, blue: 0xe6/0xff, alpha: 1)
    }
    //海贝壳色（#FFF5EE）
    class func pbSeaShellColor() -> UIColor
    {
        return UIColor(red: 0xff/0xff, green: 0xf5/0xff, blue: 0xee/0xff, alpha: 1)
    }
    //雪白（#FFFAFA）
    class func pbSnowWhiteColor() -> UIColor
    {
        return UIColor(red: 0xff/0xff, green: 0xfa/0xff, blue: 0xfa/0xff, alpha: 1)
    }
    
    //红色系
    //砖红（#9C661F）
    class func brickRedColor() -> UIColor
    {
        return UIColor(red: 0xff/0xff, green: 0xfa/0xff, blue: 0xfa/0xff, alpha: 1)
    }
    //-----------------------结束：iOS常用颜色值
}
