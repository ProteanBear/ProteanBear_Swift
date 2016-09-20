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
    
    //绿色（Green）
    static let standardGreenColor:Array<UInt32>=[
        0xd0f8ce,0xa3e9a4,0x72d572,0x42bd41,0x2baf2b,
        0x259b24,0x0a8f08,0x0a7e07,0x056f00,0x0d5302,
        0xa2f78d,0x5af158,0x14e715,0x12c700
    ]
    //浅绿色（Light Green）
    static let standardGreenLightColor:Array<UInt32>=[
        0xf1f8e9,0xdcedc8,0xc5e1a5,0xaed581,0x9ccc65,
        0x8bc34a,0x7cb342,0x689f38,0x558b2f,0x33691e,
        0xccff90,0xb2ff59,0x76ff03,0x64dd17
    ]
    //绿黄色（Lime）
    static let standardLimeColor:Array<UInt32>=[
        0xf9fbe7,0xf0f4c3,0xe6ee9c,0xdce775,0xd4e157,
        0xcddc39,0xc0ca33,0xafb42b,0x9ead24,0x827717,
        0xf4ff81,0xeeff41,0xc6ff00,0xaeea00
    ]
    
    //黄色（Yellow）
    static let standardYellowColor:Array<UInt32>=[
        0xfffde7,0xfff9c4,0xfff59d,0xfff176,0xffee58,
        0xffeb3b,0xfdd835,0xfbc02d,0xf9a825,0xf57f17,
        0xffff8d,0xffff00,0xffea00,0xffd600
    ]
    //琥珀色（Amber）
    static let standardAmberColor:Array<UInt32>=[
        0xfff8e1,0xffecb3,0xffe082,0xffd54f,0xffca28,
        0xffc107,0xffb300,0xffa000,0xff8f00,0xff6f00,
        0xffe57f,0xffd740,0xffc400,0xffab00
    ]
    //橙色（Orange）
    static let standardOrangeColor:Array<UInt32>=[
        0xfff3e0,0xffe0b2,0xffcc80,0xffb74d,0xffa726,
        0xff9800,0xfb8c00,0xf57c00,0xef6c00,0xe65100,
        0xffd180,0xffab40,0xff9100,0xff6d00
    ]
    
    //深橙色（Deep Orange）
    static let standardOrangeDeepColor:Array<UInt32>=[
        0xfbe9e7,0xffccbc,0xffab91,0xff8a65,0xff7043,
        0xff5722,0xf4511e,0xe64a19,0xd84315,0xbf360c,
        0xff9e80,0xff6e40,0xff3d00,0xdd2c00
    ]
    //棕色（Brown）
    static let standardBrownColor:Array<UInt32>=[
        0xefebe9,0xd7ccc8,0xbcaaa4,0xa1887f,0x8d6e63,
        0x795548,0x6d4c41,0x5d4037,0x4e342e,0x3e2723
    ]
    //灰色（Grey）
    static let standardGreyColor:Array<UInt32>=[
        0xfafafa,0xf5f5f5,0xeeeeee,0xe0e0e0,0xbdbdbd,
        0x9e9e9e,0x757575,0x616161,0x424242,0x212121
    ]
    //蓝灰色（Blue Grey）
    static let standardGreyBlueColor:Array<UInt32>=[
        0xeceff1,0xcfd8dc,0xb0bec5,0x90a4ae,0x78909c,
        0x607d8b,0x546e7a,0x455a64,0x37474f,0x263238
    ]
    
    //获取RGB值
    class func pbUInt32ToFloatRed(_ value:UInt32) -> CGFloat
    {
        return CGFloat(Double((value & 0xFF0000) >> 16) / Double(0xff))
    }
    class func pbUInt32ToFloatGreen(_ value:UInt32) -> CGFloat
    {
        return CGFloat(Double((value & 0x00FF00) >> 8) / Double(0xff))
    }
    class func pbUInt32ToFloatBlue(_ value:UInt32) -> CGFloat
    {
        return CGFloat(Double(value & 0x0000FF) / Double(0xff))
    }
}

//PbUIColorLevel:颜色级别
public enum PbUIColorLevel:Int
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
    
    //绿色（Green）
    var greenColor:UIColor{
        let color=UIColor.standardGreenColor[self.rawValue]
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha: 1)
    }
    //浅绿色（Light Green）
    var greenLightColor:UIColor{
        let color=UIColor.standardGreenLightColor[self.rawValue]
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha: 1)
    }
    //绿黄色（Lime）
    var limeColor:UIColor{
        let color=UIColor.standardLimeColor[self.rawValue]
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha: 1)
    }
    
    //黄色（Yellow）
    var yellowColor:UIColor{
        let color=UIColor.standardYellowColor[self.rawValue]
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha: 1)
    }
    //琥珀色（Amber）
    var amberColor:UIColor{
        let color=UIColor.standardAmberColor[self.rawValue]
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha: 1)
    }
    //橙色（Orange）
    var orangeColor:UIColor{
        let color=UIColor.standardOrangeColor[self.rawValue]
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha: 1)
    }
    
    //深橙色（Deep Orange）
    var orangeDeepColor:UIColor{
        let color=UIColor.standardOrangeDeepColor[self.rawValue]
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha: 1)
    }
    //棕色（Brown）
    var brownColor:UIColor{
        let index=(self.rawValue > UIColor.standardBrownColor.count-1) ? 4 : self.rawValue
        let color=UIColor.standardBrownColor[index]
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha: 1)
    }
    //灰色（Grey）
    var greyColor:UIColor{
        let index=(self.rawValue > UIColor.standardGreyColor.count-1) ? 4 : self.rawValue
        let color=UIColor.standardGreyColor[index]
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha: 1)
    }
    //蓝灰色（Blue Grey）
    var greyBlueColor:UIColor{
        let index=(self.rawValue > UIColor.standardGreyBlueColor.count-1) ? 4 : self.rawValue
        let color=UIColor.standardGreyBlueColor[index]
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha: 1)
    }
    
    //获取颜色值的描述
    func colorDescription(_ standardColor:Array<UInt32>) -> String
    {
        let index=(self.rawValue > standardColor.count-1) ? 4 : self.rawValue
        return String(format:"#%06x",standardColor[index])
    }
}

extension UIColor
{
    //-----------------------开始：Design标准颜色值
    //levelName:获取级别名称
    public class func pbLevelName(_ levelRaw:Int) -> String
    {
        return String(describing: PbUIColorLevel(rawValue: levelRaw))
    }
    //pbUIColor:自定义颜色（直接使用16进制值）
    public class func pbUIColor(_ color:UInt32) -> UIColor
    {
        return pbUIColor(color, alpha: 1)
    }
    public class func pbUIColor(_ color:UInt32,alpha:CGFloat) -> UIColor
    {
        return UIColor(red: UIColor.pbUInt32ToFloatRed(color), green: UIColor.pbUInt32ToFloatGreen(color), blue: UIColor.pbUInt32ToFloatBlue(color), alpha:alpha)
    }
    
    //红色Red
    public class func pbRedColor(_ levelRaw:Int) -> UIColor
    {
        return pbRedColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbRedColor(_ level:PbUIColorLevel) -> UIColor
    {
        return level.redColor
    }
    public class func pbRedColorValue(_ levelRaw:Int) -> String
    {
        return pbRedColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbRedColorValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardRedColor)
    }
    
    //粉色Pink
    public class func pbPinkColor(_ levelRaw:Int) -> UIColor
    {
        return pbPinkColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbPinkColor(_ level:PbUIColorLevel) -> UIColor
    {
        return level.pinkColor
    }
    public class func pbPinkColorValue(_ levelRaw:Int) -> String
    {
        return pbPinkColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbPinkColorValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardPinkColor)
    }
    
    //紫色Purple
    public class func pbPurpleColor(_ levelRaw:Int) -> UIColor
    {
        return pbPurpleColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbPurpleColor(_ level:PbUIColorLevel) -> UIColor
    {
        return level.purpleColor
    }
    public class func pbPurpleColorValue(_ levelRaw:Int) -> String
    {
        return pbPurpleColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbPurpleColorValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardPurpleColor)
    }
    
    //深紫色DeepPurple
    public class func pbPurpleDeepColor(_ levelRaw:Int) -> UIColor
    {
        return pbPurpleDeepColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbPurpleDeepColor(_ level:PbUIColorLevel) -> UIColor
    {
        return level.purpleDeepColor
    }
    public class func pbPurpleDeepColorValue(_ levelRaw:Int) -> String
    {
        return pbPurpleDeepColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbPurpleDeepColorValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardPurpleDeepColor)
    }
    
    //靛蓝色Indigo
    public class func pbIndigoColor(_ levelRaw:Int) -> UIColor
    {
        return pbIndigoColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbIndigoColor(_ level:PbUIColorLevel) -> UIColor
    {
        return level.indigoColor
    }
    public class func pbIndigoColorValue(_ levelRaw:Int) -> String
    {
        return pbIndigoColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbIndigoColorValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardIndigoColor)
    }
    
    //蓝色Blue
    public class func pbBlueColor(_ levelRaw:Int) -> UIColor
    {
        return pbBlueColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbBlueColor(_ level:PbUIColorLevel) -> UIColor
    {
        return level.blueColor
    }
    public class func pbBlueColorValue(_ levelRaw:Int) -> String
    {
        return pbBlueColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbBlueColorValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardBlueColor)
    }
    
    //浅蓝色LightBlue
    public class func pbBlueLightColor(_ levelRaw:Int) -> UIColor
    {
        return pbBlueLightColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbBlueLightColor(_ level:PbUIColorLevel) -> UIColor
    {
        return level.blueLightColor
    }
    public class func pbBlueLightColorValue(_ levelRaw:Int) -> String
    {
        return pbBlueLightColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbBlueLightColorValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardBlueLightColor)
    }
    
    //青色Cyan
    public class func pbCyanColor(_ levelRaw:Int) -> UIColor
    {
        return pbCyanColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbCyanColor(_ level:PbUIColorLevel) -> UIColor
    {
        return level.cyanColor
    }
    public class func pbCyanColorValue(_ levelRaw:Int) -> String
    {
        return pbCyanColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbCyanColorValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardCyanColor)
    }
    
    //蓝绿色Teal
    public class func pbTealColor(_ levelRaw:Int) -> UIColor
    {
        return pbTealColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbTealColor(_ level:PbUIColorLevel) -> UIColor
    {
        return level.tealColor
    }
    public class func pbTealColorValue(_ levelRaw:Int) -> String
    {
        return pbTealColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbTealColorValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardTealColor)
    }
    
    //绿色Green
    public class func pbGreenColor(_ levelRaw:Int) -> UIColor
    {
        return pbGreenColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbGreenColor(_ level:PbUIColorLevel) -> UIColor
    {
        return level.greenColor
    }
    public class func pbGreenColorValue(_ levelRaw:Int) -> String
    {
        return pbGreenColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbGreenColorValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardGreenColor)
    }
    
    //浅绿色Light Green
    public class func pbGreenLightColor(_ levelRaw:Int) -> UIColor
    {
        return pbGreenLightColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbGreenLightColor(_ level:PbUIColorLevel) -> UIColor
    {
        return level.greenLightColor
    }
    public class func pbGreenLightColorValue(_ levelRaw:Int) -> String
    {
        return pbGreenLightColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbGreenLightColorValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardGreenLightColor)
    }
    
    //黄绿色Lime
    public class func pbLimeColor(_ levelRaw:Int) -> UIColor
    {
        return pbLimeColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbLimeColor(_ level:PbUIColorLevel) -> UIColor
    {
        return level.limeColor
    }
    public class func pbLimeColorValue(_ levelRaw:Int) -> String
    {
        return pbLimeColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbLimeColorValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardLimeColor)
    }
    
    //黄色（Yellow）
    public class func pbYellowColor(_ levelRaw:Int) -> UIColor
    {
        return pbYellowColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbYellowColor(_ level:PbUIColorLevel) -> UIColor
    {
        return level.yellowColor
    }
    public class func pbYellowColorValue(_ levelRaw:Int) -> String
    {
        return pbYellowColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbYellowColorValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardYellowColor)
    }
    
    //琥珀色（Amber）
    public class func pbAmberColor(_ levelRaw:Int) -> UIColor
    {
        return pbAmberColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbAmberColor(_ level:PbUIColorLevel) -> UIColor
    {
        return level.amberColor
    }
    public class func pbAmberColorValue(_ levelRaw:Int) -> String
    {
        return pbAmberColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbAmberColorValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardAmberColor)
    }
    
    //橙色（Orange）
    public class func pbOrangeColor(_ levelRaw:Int) -> UIColor
    {
        return pbOrangeColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbOrangeColor(_ level:PbUIColorLevel) -> UIColor
    {
        return level.orangeColor
    }
    public class func pbOrangeColorValue(_ levelRaw:Int) -> String
    {
        return pbOrangeColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbOrangeColorValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardOrangeColor)
    }
    
    //深橙色（Deep Orange）
    public class func pbOrangeDeepColor(_ levelRaw:Int) -> UIColor
    {
        return pbOrangeDeepColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbOrangeDeepColor(_ level:PbUIColorLevel) -> UIColor
    {
        return level.orangeDeepColor
    }
    public class func pbOrangeDeepColorValue(_ levelRaw:Int) -> String
    {
        return pbOrangeDeepColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbOrangeDeepColorValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardOrangeDeepColor)
    }
    
    //棕色（Brown）
    public class func pbBrownColor(_ levelRaw:Int) -> UIColor
    {
        return pbBrownColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbBrownColor(_ level:PbUIColorLevel) -> UIColor
    {
        return level.brownColor
    }
    public class func pbBrownColorValue(_ levelRaw:Int) -> String
    {
        return pbBrownColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbBrownColorValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardBrownColor)
    }
    
    //灰色（Grey）
    public class func pbGreyColor(_ levelRaw:Int) -> UIColor
    {
        return pbGreyColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbGreyColor(_ level:PbUIColorLevel) -> UIColor
    {
        return level.greyColor
    }
    public class func pbGreyColorValue(_ levelRaw:Int) -> String
    {
        return pbGreyColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbGreyColorValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardGreyColor)
    }
    
    //蓝灰色（Blue Grey）
    public class func pbGreyBlueColor(_ levelRaw:Int) -> UIColor
    {
        return pbGreyBlueColor(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbGreyBlueColor(_ level:PbUIColorLevel) -> UIColor
    {
        return level.greyBlueColor
    }
    public class func pbGreyBlueColorValue(_ levelRaw:Int) -> String
    {
        return pbGreyBlueColorValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbGreyBlueColorValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardGreyBlueColor)
    }
    //-----------------------结束：Design标准颜色值
    
    //-----------------------开始：iOS常用颜色值
    //黑灰色系
    //象牙黑（#292421）
    public class func pbIvoryBlackColor() -> UIColor
    {
        return UIColor(red: 0x29/0xff, green: 0x24/0xff, blue: 0x21/0xff, alpha: 1)
    }
    //冷灰（#808A87）
    public class func pbColdGrayColor() -> UIColor
    {
        return UIColor(red: 0x80/0xff, green: 0x8a/0xff, blue: 0x87/0xff, alpha: 1)
    }
    //石板灰（#708069）
    public class func pbSlateGrayColor() -> UIColor
    {
        return UIColor(red: 0x70/0xff, green: 0x80/0xff, blue: 0x69/0xff, alpha: 1)
    }
    //暖灰色（#808069）
    public class func pbWarmGrayColor() -> UIColor
    {
        return UIColor(red: 0x80/0xff, green: 0x80/0xff, blue: 0x69/0xff, alpha: 1)
    }
    
    //白色系
    //古董白（#FAEBD7）
    public class func pbAntiqueWhiteColor() -> UIColor
    {
        return UIColor(red: 0xfa/0xff, green: 0xeb/0xff, blue: 0xd7/0xff, alpha: 1)
    }
    //天蓝色（#F0FFFF）
    public class func pbSkyBlueColor() -> UIColor
    {
        return UIColor(red: 0xf0/0xff, green: 0xff/0xff, blue: 0xff/0xff, alpha: 1)
    }
    //白烟（#F5F5F5）
    public class func pbSmokeWhiteColor() -> UIColor
    {
        return UIColor(red: 0xf5/0xff, green: 0xf5/0xff, blue: 0xf5/0xff, alpha: 1)
    }
    //白杏仁（#FFFFCD）
    public class func pbAlmondWhiteColor() -> UIColor
    {
        return UIColor(red: 0xff/0xff, green: 0xff/0xff, blue: 0xcd/0xff, alpha: 1)
    }
    //cornsilk（#FFF8DC）
    public class func pbCornsilkColor() -> UIColor
    {
        return UIColor(red: 0xff/0xff, green: 0xf8/0xff, blue: 0xdc/0xff, alpha: 1)
    }
    //蛋壳色（#FCE6C9）
    public class func pbYellowEggColor() -> UIColor
    {
        return UIColor(red: 0xfc/0xff, green: 0xe6/0xff, blue: 0xc9/0xff, alpha: 1)
    }
    //花白（#FFFAF0）
    public class func pbFloralWhiteColor() -> UIColor
    {
        return UIColor(red: 0xff/0xff, green: 0xfa/0xff, blue: 0xf0/0xff, alpha: 1)
    }
    //gainsboro（#DCDCDC）
    public class func pbGainsboroColor() -> UIColor
    {
        return UIColor(red: 0xdc/0xff, green: 0xdc/0xff, blue: 0xdc/0xff, alpha: 1)
    }
    //ghostWhite（#F8F8FF）
    public class func pbGhostWhiteColor() -> UIColor
    {
        return UIColor(red: 0xf8/0xff, green: 0xf8/0xff, blue: 0xff/0xff, alpha: 1)
    }
    //蜜露橙（#F0FFF0）
    public class func pbHoneyDewColor() -> UIColor
    {
        return UIColor(red: 0xf0/0xff, green: 0xff/0xff, blue: 0xf0/0xff, alpha: 1)
    }
    //象牙白（#FAFFF0）
    public class func pbIvoryWhiteColor() -> UIColor
    {
        return UIColor(red: 0xfa/0xff, green: 0xff/0xff, blue: 0xf0/0xff, alpha: 1)
    }
    //亚麻色（#FAF0E6）
    public class func pbFlaxenColor() -> UIColor
    {
        return UIColor(red: 0xfa/0xff, green: 0xf0/0xff, blue: 0xe6/0xff, alpha: 1)
    }
    //navajoWhite（#FFDEAD）
    public class func pbNavajoWhiteColor() -> UIColor
    {
        return UIColor(red: 0xff/0xff, green: 0xde/0xff, blue: 0xad/0xff, alpha: 1)
    }
    //oldLace（#FDF5E6）
    public class func pbOldLaceColor() -> UIColor
    {
        return UIColor(red: 0xfd/0xff, green: 0xf5/0xff, blue: 0xe6/0xff, alpha: 1)
    }
    //海贝壳色（#FFF5EE）
    public class func pbSeaShellColor() -> UIColor
    {
        return UIColor(red: 0xff/0xff, green: 0xf5/0xff, blue: 0xee/0xff, alpha: 1)
    }
    //雪白（#FFFAFA）
    public class func pbSnowWhiteColor() -> UIColor
    {
        return UIColor(red: 0xff/0xff, green: 0xfa/0xff, blue: 0xfa/0xff, alpha: 1)
    }
    
    //红色系
    //砖红（#9C661F）
    public class func brickRedColor() -> UIColor
    {
        return UIColor(red: 0xff/0xff, green: 0xfa/0xff, blue: 0xfa/0xff, alpha: 1)
    }
    //-----------------------结束：iOS常用颜色值
}
