//
//  PbLog.swift
//  pb.swift.basic
//  日志输出对象
//  Created by Maqiang on 15/6/19.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation

open class PbLog
{
    static let isDebug=true
    
    open class func debug(_ infor:String)
    {
        if(isDebug)
        {
            print("[DEBUG]\(infor)")
        }
    }
    
    open class func error(_ error:String)
    {
        print("[ERROR]\(error)")
    }
}
