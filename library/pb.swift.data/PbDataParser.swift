//
//  PbDataParser.swift
//  swiftPbTest
//  通用接口-数据解析器
//  Created by Maqiang on 15/6/18.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation

/// 数据解析器实现的协议
public protocol PbDataParser
{
    /// 通过数据获取数据字典对象
    /// - parameter data:解析的数据
    mutating func dictionaryByData(_ data:Data?) -> NSMutableDictionary?
}
