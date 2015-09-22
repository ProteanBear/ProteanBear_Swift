//
//  PbDataParserJson.swift
//  swiftPbTest
//
//  Created by Maqiang on 15/6/18.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation

class PbDataParserJson: PbDataParser
{
    //parserError:记录解析的错误信息
    var parseError:NSErrorPointer=NSErrorPointer()
    
    //dictionaryByData:通过数据获取数据字典对象
    func dictionaryByData(data:NSData?) -> NSMutableDictionary
    {
        //调试信息前缀
        let logPrex:String="PbDataParserJson:dictionaryByData:"
        
        /*解析信息数据*/
        let result=NSMutableDictionary()
        if data != nil
        {
            PbLog.debug(logPrex+"返回信息:"+String(NSString(data:data!,encoding: NSUTF8StringEncoding)!))
            do {
                let jsonResult:NSDictionary?=try NSJSONSerialization.JSONObjectWithData(data!,options: NSJSONReadingOptions.MutableLeaves) as? NSDictionary
                if(jsonResult != nil)
                {
                    result.addEntriesFromDictionary(jsonResult! as [NSObject : AnyObject])
                }
            } catch _ {
            }
        }
        else
        {
            PbLog.debug(logPrex+"返回数据为空")
        }
        
        return result;
    }
}
