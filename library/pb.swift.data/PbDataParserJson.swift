//
//  PbDataParserJson.swift
//  swiftPbTest
//
//  Created by Maqiang on 15/6/18.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation

open class PbDataParserJson: PbDataParser
{
    //dictionaryByData:通过数据获取数据字典对象
    open func dictionaryByData(_ data:Data?) -> NSMutableDictionary?
    {
        //调试信息前缀
        let logPrex:String="PbDataParserJson:dictionaryByData:"
        
        /*解析信息数据*/
        let result=NSMutableDictionary()
        if data != nil
        {
            PbLog.debug(logPrex+"返回信息:"+String(NSString(data:data!,encoding: String.Encoding.utf8.rawValue)!))
            do {
                let jsonResult:NSDictionary?=try JSONSerialization.jsonObject(with: data!,options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary
                if(jsonResult != nil)
                {
                    result.addEntries(from: jsonResult! as! [AnyHashable: Any])
                }
            } catch _ {
            }
        }
        else
        {
            PbLog.debug(logPrex+"返回数据为空")
            return nil
        }
        
        return result;
    }
}
