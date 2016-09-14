//
//  PbDataParser.swift
//  swiftPbTest
//  通用接口-数据解析器
//  Created by Maqiang on 15/6/18.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation

public protocol PbDataParser
{
    //dictionaryByData:通过数据获取数据字典对象
    mutating func dictionaryByData(_ data:Data?) -> NSMutableDictionary?
}
