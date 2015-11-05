//
//  PbLog.swift
//  pb.swift.basic
//  日志输出对象
//  Created by Maqiang on 15/6/19.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation

public class PbLog
{
    static let isDebug=true
    
    class func debug(infor:String)
    {
        if(isDebug)
        {
            print("[DEBUG]"+infor)
        }
    }
    
    class func error(error:String)
    {
        print("[ERROR]"+error)
    }
}