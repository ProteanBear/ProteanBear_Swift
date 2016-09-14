//
//  PbDataRequester.swift
//  swiftPbTest
//  通用接口-数据请求器
//  Created by Maqiang on 15/6/18.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation

public protocol PbDataRequester
{
    //request:发送请求，并返回数据
    mutating func request(_ address:String,data:NSDictionary,callback:(_ data:Data?,_ response:AnyObject?,_ error:NSError?) -> Void)
    
    //request:发送请求上传资源数据，并返回数据
    mutating func request(_ address:String,data:NSDictionary,callback:(_ data:Data?,_ response:AnyObject?,_ error:NSError?) -> Void,isMultipart:Bool)
    
    //requestForResource:发送请求，获取资源数据
    mutating func requestForResource(_ address:String,callback:(_ data:Data?,_ response:AnyObject?,_ error:NSError?) -> Void)
    
    //paramsString:获取当前请求参数的字符串格式
    mutating func paramString(_ params:NSDictionary?)->String
}
