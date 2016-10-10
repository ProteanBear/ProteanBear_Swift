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
    static let standardRed:Array<UInt32>=[
        0xfde0dc,0xf9bdbb,0xf69988,0xf36c60,0xe84e40,
        0xe51c23,0xdd191d,0xd01716,0xc41411,0xb0120a,
        0xff7997,0xff5177,0xff2d6f,0xe00032
    ]
    //粉色（Pink）
    static let standardPink:Array<UInt32>=[
        0xfce4ec,0xf8bbd0,0xf48fb1,0xf06292,0xec407a,
        0xe91e63,0xd81b60,0xc2185b,0xad1457,0x880e4f,
        0xff80ab,0xff4081,0xf50057,0xc51162
    ]
    //紫色（Purple）
    static let standardPurple:Array<UInt32>=[
        0xf3e5f5,0xe1bee7,0xce93d8,0xba68c8,0xab47bc,
        0x9c27b0,0x8e24aa,0x7b1fa2,0x6a1b9a,0x4a148c,
        0xea80fc,0xe040fb,0xd500f9,0xaa00ff
    ]
    
    //深紫色（Deep Purple）
    static let standardPurpleDeep:Array<UInt32>=[
        0xede7f6,0xd1c4e9,0xb39ddb,0x9575cd,0x7e57c2,
        0x673ab7,0x5e35b1,0x512da8,0x4527a0,0x311b92,
        0xb388ff,0x7c4dff,0x651fff,0x6200ea
    ]
    //靛蓝色（Indigo）
    static let standardIndigo:Array<UInt32>=[
        0xe8eaf6,0xc5cae9,0x9fa8da,0x7986cb,0x5c6bc0,
        0x3f51b5,0x3949ab,0x303f9f,0x283593,0x1a237e,
        0x8c9eff,0x526dfe,0x3d5afe,0x304ffe
    ]
    //蓝色（Blue）
    static let standardBlue:Array<UInt32>=[
        0xe7e9fd,0xd0d9ff,0xafbfff,0x91a7ff,0x738ffe,
        0x5677fc,0x4e6cef,0x455ede,0x3b50ce,0x2a36b1,
        0xa6baff,0x6889ff,0x4d73ff,0x4d69ff
    ]
    
    //浅蓝色（Light Blue）
    static let standardBlueLight:Array<UInt32>=[
        0xe1f5fe,0xb3e5fc,0x81d4fa,0x4fc3f7,0x29b6f6,
        0x03a9f4,0x039be5,0x0288d1,0x0277bd,0x01579b,
        0x80d8ff,0x40c4ff,0x00b0ff,0x0091ea
    ]
    //青色（Cyan）
    static let standardCyan:Array<UInt32>=[
        0xe0f7fa,0xb2ebf2,0x80deea,0x4dd0e1,0x26c6da,
        0x00bcd4,0x00acc1,0x0097a7,0x00838f,0x006064,
        0x84ffff,0x18ffff,0x00e5ff,0x00b8d4
    ]
    //蓝绿色（Teal）
    static let standardTeal:Array<UInt32>=[
        0xe0f2f1,0xb2dfdb,0x80cbc4,0x4db6ac,0x26a69a,
        0x009688,0x00897b,0x00796b,0x00695c,0x004d40,
        0xa7ffeb,0x64ffda,0x1de9b6,0x00bfa5
    ]
    
    //绿色（Green）
    static let standardGreen:Array<UInt32>=[
        0xd0f8ce,0xa3e9a4,0x72d572,0x42bd41,0x2baf2b,
        0x259b24,0x0a8f08,0x0a7e07,0x056f00,0x0d5302,
        0xa2f78d,0x5af158,0x14e715,0x12c700
    ]
    //浅绿色（Light Green）
    static let standardGreenLight:Array<UInt32>=[
        0xf1f8e9,0xdcedc8,0xc5e1a5,0xaed581,0x9ccc65,
        0x8bc34a,0x7cb342,0x689f38,0x558b2f,0x33691e,
        0xccff90,0xb2ff59,0x76ff03,0x64dd17
    ]
    //绿黄色（Lime）
    static let standardLime:Array<UInt32>=[
        0xf9fbe7,0xf0f4c3,0xe6ee9c,0xdce775,0xd4e157,
        0xcddc39,0xc0ca33,0xafb42b,0x9ead24,0x827717,
        0xf4ff81,0xeeff41,0xc6ff00,0xaeea00
    ]
    
    //黄色（Yellow）
    static let standardYellow:Array<UInt32>=[
        0xfffde7,0xfff9c4,0xfff59d,0xfff176,0xffee58,
        0xffeb3b,0xfdd835,0xfbc02d,0xf9a825,0xf57f17,
        0xffff8d,0xffff00,0xffea00,0xffd600
    ]
    //琥珀色（Amber）
    static let standardAmber:Array<UInt32>=[
        0xfff8e1,0xffecb3,0xffe082,0xffd54f,0xffca28,
        0xffc107,0xffb300,0xffa000,0xff8f00,0xff6f00,
        0xffe57f,0xffd740,0xffc400,0xffab00
    ]
    //橙色（Orange）
    static let standardOrange:Array<UInt32>=[
        0xfff3e0,0xffe0b2,0xffcc80,0xffb74d,0xffa726,
        0xff9800,0xfb8c00,0xf57c00,0xef6c00,0xe65100,
        0xffd180,0xffab40,0xff9100,0xff6d00
    ]
    
    //深橙色（Deep Orange）
    static let standardOrangeDeep:Array<UInt32>=[
        0xfbe9e7,0xffccbc,0xffab91,0xff8a65,0xff7043,
        0xff5722,0xf4511e,0xe64a19,0xd84315,0xbf360c,
        0xff9e80,0xff6e40,0xff3d00,0xdd2c00
    ]
    //棕色（Brown）
    static let standardBrown:Array<UInt32>=[
        0xefebe9,0xd7ccc8,0xbcaaa4,0xa1887f,0x8d6e63,
        0x795548,0x6d4c41,0x5d4037,0x4e342e,0x3e2723
    ]
    //灰色（Grey）
    static let standardGrey:Array<UInt32>=[
        0xfafafa,0xf5f5f5,0xeeeeee,0xe0e0e0,0xbdbdbd,
        0x9e9e9e,0x757575,0x616161,0x424242,0x212121
    ]
    //蓝灰色（Blue Grey）
    static let standardGreyBlue:Array<UInt32>=[
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
    
    //获取指定的颜色值的颜色对象
    class func pbUInt32ToUIColor(_ value:UInt32,alpha:CGFloat) -> UIColor
    {
        let red=UIColor.pbUInt32ToFloatRed(value)
        let green=UIColor.pbUInt32ToFloatGreen(value)
        let blue=UIColor.pbUInt32ToFloatBlue(value)
        if #available(iOS 10.0, *)
        {
            return UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
        }
        else
        {
            return UIColor(red:red,green:green,blue:blue,alpha:alpha)
        }
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
    var red:UIColor{
        return UIColor.pbUInt32ToUIColor(UIColor.standardRed[self.rawValue],alpha: 1)
    }
    //粉色（Pink）
    var pink:UIColor{
        return UIColor.pbUInt32ToUIColor(UIColor.standardPink[self.rawValue],alpha: 1)
    }
    //紫色（Purple）
    var purple:UIColor{
        return UIColor.pbUInt32ToUIColor(UIColor.standardPurple[self.rawValue],alpha: 1)
    }
    
    //深紫色（Deep Purple）
    var purpleDeep:UIColor{
        return UIColor.pbUInt32ToUIColor(UIColor.standardPurpleDeep[self.rawValue],alpha: 1)
    }
    //靛蓝色（Indigo）
    var indigo:UIColor{
        return UIColor.pbUInt32ToUIColor(UIColor.standardIndigo[self.rawValue],alpha: 1)
    }
    //蓝色（Blue）
    var blue:UIColor{
        return UIColor.pbUInt32ToUIColor(UIColor.standardBlue[self.rawValue],alpha: 1)
    }
    
    //浅蓝色（Light Blue）
    var blueLight:UIColor{
        return UIColor.pbUInt32ToUIColor(UIColor.standardBlueLight[self.rawValue],alpha: 1)
    }
    //青色（Cyan）
    var cyan:UIColor{
        return UIColor.pbUInt32ToUIColor(UIColor.standardCyan[self.rawValue],alpha: 1)
    }
    //蓝绿色（Teal）
    var teal:UIColor{
        return UIColor.pbUInt32ToUIColor(UIColor.standardTeal[self.rawValue],alpha: 1)
    }
    
    //绿色（Green）
    var green:UIColor{
        return UIColor.pbUInt32ToUIColor(UIColor.standardGreen[self.rawValue],alpha: 1)
    }
    //浅绿色（Light Green）
    var greenLight:UIColor{
        return UIColor.pbUInt32ToUIColor(UIColor.standardGreenLight[self.rawValue],alpha: 1)
    }
    //绿黄色（Lime）
    var lime:UIColor{
        return UIColor.pbUInt32ToUIColor(UIColor.standardLime[self.rawValue],alpha: 1)
    }
    
    //黄色（Yellow）
    var yellow:UIColor{
        return UIColor.pbUInt32ToUIColor(UIColor.standardYellow[self.rawValue],alpha: 1)
    }
    //琥珀色（Amber）
    var amber:UIColor{
        return UIColor.pbUInt32ToUIColor(UIColor.standardAmber[self.rawValue],alpha: 1)
    }
    //橙色（Orange）
    var orange:UIColor{
        return UIColor.pbUInt32ToUIColor(UIColor.standardOrange[self.rawValue],alpha: 1)
    }
    
    //深橙色（Deep Orange）
    var orangeDeep:UIColor{
        return UIColor.pbUInt32ToUIColor(UIColor.standardOrangeDeep[self.rawValue],alpha: 1)
    }
    //棕色（Brown）
    var brown:UIColor{
        let index=(self.rawValue > UIColor.standardBrown.count-1) ? 4 : self.rawValue
        return UIColor.pbUInt32ToUIColor(UIColor.standardBrown[index],alpha: 1)
    }
    //灰色（Grey）
    var grey:UIColor{
        let index=(self.rawValue > UIColor.standardGrey.count-1) ? 4 : self.rawValue
        return UIColor.pbUInt32ToUIColor(UIColor.standardGrey[index],alpha: 1)
    }
    //蓝灰色（Blue Grey）
    var greyBlue:UIColor{
        let index=(self.rawValue > UIColor.standardGreyBlue.count-1) ? 4 : self.rawValue
        return UIColor.pbUInt32ToUIColor(UIColor.standardGreyBlue[index],alpha: 1)
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
        return UIColor.pbUInt32ToUIColor(color, alpha: alpha)
    }
    
    //红色Red
    public class func pbRed(_ levelRaw:Int) -> UIColor
    {
        return pbRed(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbRed(_ level:PbUIColorLevel) -> UIColor
    {
        return level.red
    }
    public class func pbRedValue(_ levelRaw:Int) -> String
    {
        return pbRedValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbRedValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardRed)
    }
    
    //粉色Pink
    public class func pbPink(_ levelRaw:Int) -> UIColor
    {
        return pbPink(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbPink(_ level:PbUIColorLevel) -> UIColor
    {
        return level.pink
    }
    public class func pbPinkValue(_ levelRaw:Int) -> String
    {
        return pbPinkValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbPinkValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardPink)
    }
    
    //紫色Purple
    public class func pbPurple(_ levelRaw:Int) -> UIColor
    {
        return pbPurple(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbPurple(_ level:PbUIColorLevel) -> UIColor
    {
        return level.purple
    }
    public class func pbPurpleValue(_ levelRaw:Int) -> String
    {
        return pbPurpleValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbPurpleValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardPurple)
    }
    
    //深紫色DeepPurple
    public class func pbPurpleDeep(_ levelRaw:Int) -> UIColor
    {
        return pbPurpleDeep(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbPurpleDeep(_ level:PbUIColorLevel) -> UIColor
    {
        return level.purpleDeep
    }
    public class func pbPurpleDeepValue(_ levelRaw:Int) -> String
    {
        return pbPurpleDeepValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbPurpleDeepValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardPurpleDeep)
    }
    
    //靛蓝色Indigo
    public class func pbIndigo(_ levelRaw:Int) -> UIColor
    {
        return pbIndigo(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbIndigo(_ level:PbUIColorLevel) -> UIColor
    {
        return level.indigo
    }
    public class func pbIndigoValue(_ levelRaw:Int) -> String
    {
        return pbIndigoValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbIndigoValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardIndigo)
    }
    
    //蓝色Blue
    public class func pbBlue(_ levelRaw:Int) -> UIColor
    {
        return pbBlue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbBlue(_ level:PbUIColorLevel) -> UIColor
    {
        return level.blue
    }
    public class func pbBlueValue(_ levelRaw:Int) -> String
    {
        return pbBlueValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbBlueValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardBlue)
    }
    
    //浅蓝色LightBlue
    public class func pbBlueLight(_ levelRaw:Int) -> UIColor
    {
        return pbBlueLight(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbBlueLight(_ level:PbUIColorLevel) -> UIColor
    {
        return level.blueLight
    }
    public class func pbBlueLightValue(_ levelRaw:Int) -> String
    {
        return pbBlueLightValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbBlueLightValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardBlueLight)
    }
    
    //青色Cyan
    public class func pbCyan(_ levelRaw:Int) -> UIColor
    {
        return pbCyan(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbCyan(_ level:PbUIColorLevel) -> UIColor
    {
        return level.cyan
    }
    public class func pbCyanValue(_ levelRaw:Int) -> String
    {
        return pbCyanValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbCyanValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardCyan)
    }
    
    //蓝绿色Teal
    public class func pbTeal(_ levelRaw:Int) -> UIColor
    {
        return pbTeal(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbTeal(_ level:PbUIColorLevel) -> UIColor
    {
        return level.teal
    }
    public class func pbTealValue(_ levelRaw:Int) -> String
    {
        return pbTealValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbTealValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardTeal)
    }
    
    //绿色Green
    public class func pbGreen(_ levelRaw:Int) -> UIColor
    {
        return pbGreen(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbGreen(_ level:PbUIColorLevel) -> UIColor
    {
        return level.green
    }
    public class func pbGreenValue(_ levelRaw:Int) -> String
    {
        return pbGreenValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbGreenValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardGreen)
    }
    
    //浅绿色Light Green
    public class func pbGreenLight(_ levelRaw:Int) -> UIColor
    {
        return pbGreenLight(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbGreenLight(_ level:PbUIColorLevel) -> UIColor
    {
        return level.greenLight
    }
    public class func pbGreenLightValue(_ levelRaw:Int) -> String
    {
        return pbGreenLightValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbGreenLightValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardGreenLight)
    }
    
    //黄绿色Lime
    public class func pbLime(_ levelRaw:Int) -> UIColor
    {
        return pbLime(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbLime(_ level:PbUIColorLevel) -> UIColor
    {
        return level.lime
    }
    public class func pbLimeValue(_ levelRaw:Int) -> String
    {
        return pbLimeValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbLimeValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardLime)
    }
    
    //黄色（Yellow）
    public class func pbYellow(_ levelRaw:Int) -> UIColor
    {
        return pbYellow(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbYellow(_ level:PbUIColorLevel) -> UIColor
    {
        return level.yellow
    }
    public class func pbYellowValue(_ levelRaw:Int) -> String
    {
        return pbYellowValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbYellowValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardYellow)
    }
    
    //琥珀色（Amber）
    public class func pbAmber(_ levelRaw:Int) -> UIColor
    {
        return pbAmber(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbAmber(_ level:PbUIColorLevel) -> UIColor
    {
        return level.amber
    }
    public class func pbAmberValue(_ levelRaw:Int) -> String
    {
        return pbAmberValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbAmberValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardAmber)
    }
    
    //橙色（Orange）
    public class func pbOrange(_ levelRaw:Int) -> UIColor
    {
        return pbOrange(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbOrange(_ level:PbUIColorLevel) -> UIColor
    {
        return level.orange
    }
    public class func pbOrangeValue(_ levelRaw:Int) -> String
    {
        return pbOrangeValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbOrangeValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardOrange)
    }
    
    //深橙色（Deep Orange）
    public class func pbOrangeDeep(_ levelRaw:Int) -> UIColor
    {
        return pbOrangeDeep(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbOrangeDeep(_ level:PbUIColorLevel) -> UIColor
    {
        return level.orangeDeep
    }
    public class func pbOrangeDeepValue(_ levelRaw:Int) -> String
    {
        return pbOrangeDeepValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbOrangeDeepValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardOrangeDeep)
    }
    
    //棕色（Brown）
    public class func pbBrown(_ levelRaw:Int) -> UIColor
    {
        return pbBrown(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbBrown(_ level:PbUIColorLevel) -> UIColor
    {
        return level.brown
    }
    public class func pbBrownValue(_ levelRaw:Int) -> String
    {
        return pbBrownValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbBrownValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardBrown)
    }
    
    //灰色（Grey）
    public class func pbGrey(_ levelRaw:Int) -> UIColor
    {
        return pbGrey(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbGrey(_ level:PbUIColorLevel) -> UIColor
    {
        return level.grey
    }
    public class func pbGreyValue(_ levelRaw:Int) -> String
    {
        return pbGreyValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbGreyValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardGrey)
    }
    
    //蓝灰色（Blue Grey）
    public class func pbGreyBlue(_ levelRaw:Int) -> UIColor
    {
        return pbGreyBlue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbGreyBlue(_ level:PbUIColorLevel) -> UIColor
    {
        return level.greyBlue
    }
    public class func pbGreyBlueValue(_ levelRaw:Int) -> String
    {
        return pbGreyBlueValue(PbUIColorLevel(rawValue:levelRaw)!)
    }
    public class func pbGreyBlueValue(_ level:PbUIColorLevel) -> String
    {
        return level.colorDescription(UIColor.standardGreyBlue)
    }
    //-----------------------结束：Design标准颜色值
    
    //-----------------------开始：iOS常用颜色值
    //黑灰色系
    //象牙黑（#292421）
    public static var pbIvoryBlack:UIColor{
        return UIColor.pbUInt32ToUIColor(0x292421, alpha: 1)
    }
    //冷灰（#808A87）
    public static var pbColdGray:UIColor{
        return UIColor.pbUInt32ToUIColor(0x808a87, alpha: 1)
    }
    //石板灰（#708069）
    public static var pbSlateGray:UIColor{
        return UIColor.pbUInt32ToUIColor(0x708069, alpha: 1)
    }
    //暖灰色（#808069）
    public static var pbWarmGray:UIColor{
        return UIColor.pbUInt32ToUIColor(0x808069, alpha: 1)
    }
    
    //白色系
    //古董白（#FAEBD7）
    public static var pbAntiqueWhite:UIColor{
        return UIColor.pbUInt32ToUIColor(0xfaebd7, alpha: 1)
    }
    //天蓝色（#F0FFFF）
    public static var pbSkyBlue:UIColor{
        return UIColor.pbUInt32ToUIColor(0xf0ffff, alpha: 1)
    }
    //白烟（#F5F5F5）
    public static var pbSmokeWhite:UIColor{
        return UIColor.pbUInt32ToUIColor(0xf5f5f5, alpha: 1)
    }
    //白杏仁（#FFFFCD）
    public static var pbAlmondWhite:UIColor{
        return UIColor.pbUInt32ToUIColor(0xffffcd, alpha: 1)
    }
    //cornsilk（#FFF8DC）
    public static var pbCornsilk:UIColor{
        return UIColor.pbUInt32ToUIColor(0xfff8dc, alpha: 1)
    }
    //蛋壳色（#FCE6C9）
    public static var pbYellowEgg:UIColor{
        return UIColor.pbUInt32ToUIColor(0xfce6c9, alpha: 1)
    }
    //花白（#FFFAF0）
    public static var pbFloralWhite:UIColor{
        return UIColor.pbUInt32ToUIColor(0xfffaf0, alpha: 1)
    }
    //gainsboro（#DCDCDC）
    public static var pbGainsboroColor:UIColor{
        return UIColor.pbUInt32ToUIColor(0xdcdcdc, alpha: 1)
    }
    //ghostWhite（#F8F8FF）
    public static var pbGhostWhite:UIColor{
        return UIColor.pbUInt32ToUIColor(0xf8f8ff, alpha: 1)
    }
    //蜜露橙（#F0FFF0）
    public static var pbHoneyDew:UIColor{
        return UIColor.pbUInt32ToUIColor(0xf0fff0, alpha: 1)
    }
    //象牙白（#FAFFF0）
    public static var pbIvoryWhite:UIColor{
        return UIColor.pbUInt32ToUIColor(0xfafff0, alpha: 1)
    }
    //亚麻色（#FAF0E6）
    public static var pbFlaxen:UIColor{
        return UIColor.pbUInt32ToUIColor(0xfaf0e6, alpha: 1)
    }
    //navajoWhite（#FFDEAD）
    public static var pbNavajoWhite:UIColor{
        return UIColor.pbUInt32ToUIColor(0xffdead, alpha: 1)
    }
    //oldLace（#FDF5E6）
    public static var pbOldLace:UIColor{
        return UIColor.pbUInt32ToUIColor(0xfdf5e6, alpha: 1)
    }
    //海贝壳色（#FFF5EE）
    public static var pbSeaShell:UIColor{
        return UIColor.pbUInt32ToUIColor(0xfff5ee, alpha: 1)
    }
    //雪白（#FFFAFA）
    public static var pbSnowWhite:UIColor{
        return UIColor.pbUInt32ToUIColor(0xfffafa, alpha: 1)
    }
    
    //红色系
    //砖红（#9C661F）
    public static var brickRed:UIColor{
        return UIColor.pbUInt32ToUIColor(0x9c661f, alpha: 1)
    }
    //-----------------------结束：iOS常用颜色值
}
