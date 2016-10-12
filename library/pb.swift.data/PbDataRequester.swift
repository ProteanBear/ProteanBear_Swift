//
//  PbDataRequester.swift
//  swiftPbTest
//  通用接口-数据请求器
//  Created by Maqiang on 15/6/18.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation

/// 数据请求器协议
public protocol PbDataRequester
{
    /// 发送请求，并返回数据
    /// - parameter address :请求地址
    /// - parameter data :请求数据
    /// - parameter callback :请求后的返回处理
    mutating func request(_ address:String,data:NSDictionary,callback:@escaping (_ data:Data?,_ response:AnyObject?,_ error:NSError?) -> Void)
    
    /// 发送请求上传资源数据，并返回数据
    /// - parameter address :请求地址
    /// - parameter data :请求数据
    /// - parameter callback :请求后的返回处理
    /// - parameter isMultipart:是否为数据上传模式
    mutating func request(_ address:String,data:NSDictionary,callback:@escaping (_ data:Data?,_ response:AnyObject?,_ error:NSError?) -> Void,isMultipart:Bool)
    
    /// 发送请求，获取资源数据
    /// - parameter address :请求地址
    /// - parameter callback :请求后的返回处理
    mutating func requestForResource(_ address:String,callback:@escaping (_ data:Data?,_ response:AnyObject?,_ error:NSError?) -> Void)
    
    /// 获取当前请求参数的字符串格式
    /// - parameter params :请求参数
    mutating func paramString(_ params:NSDictionary?)->String
}
