//
//  PbDataParser.swift
//  swiftPbTest
//  通用接口-数据解析器
//  Created by Maqiang on 15/6/18.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation

protocol PbDataParser
{
    //parserError:记录解析的错误信息
    var parseError:NSErrorPointer{get set}
    
    //dictionaryByData:通过数据获取数据字典对象
    mutating func dictionaryByData(data:NSData?) -> NSMutableDictionary
}
