//
//  ExtensionDouble.swift
//  PbSwiftLibrary
//
//  Created by Maqiang on 2016/10/11.
//  Copyright © 2016年 ProteanBear. All rights reserved.
//

import Foundation

extension Double
{
    /// 度数转化为弧度
    /// - parameter degrees:度数值
    public var toRadians:Double{
        return (M_PI * (self))/180.0
    }
}

extension UInt32
{
    /// 获取一个随机整数((int)((from)+(arc4random()%((to)–(from)+1)))))
    /// - parameter from:最小值
    /// - parameter to  :最大值
    public static func toRandom(_ from:UInt32,to:UInt32) -> UInt32
    {
        return from + (arc4random() % (to - from + 1))
    }
}
