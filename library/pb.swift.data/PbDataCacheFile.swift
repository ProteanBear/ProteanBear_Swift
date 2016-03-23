//
//  PbDataCacheFile.swift
//  swiftPbTest
//  本地文件缓存管理器
//  Created by Maqiang on 15/6/19.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

public class PbDataCacheFile
{
    //fileManager:文件管理器
    let fileManager:NSFileManager=NSFileManager.defaultManager()
    
    //rootPath:文件根目录
    var rootPath:String=""
    
    //cachePath:记录缓存目录
    var cachePath:String=""
    
    //expireTime:缓存过期时间
    var expireTime:NSTimeInterval=0
    
    /*init:
     *初始化
     */
    public init(cachePathName:String)
    {
        //获取用户缓存目录
        let paths:Array=NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask,true) as Array
        rootPath=paths[0] 
        
        //指定的缓存目录不存在则创建目录
        self.cachePath=NSString(string:rootPath).stringByAppendingPathComponent(cachePathName)
        if(!fileManager.fileExistsAtPath(cachePath))
        {
            do {
                try fileManager.createDirectoryAtPath(cachePath, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
            }
        }
    }
    
    /*createSubCachePath:
     *  创建缓存子目录
     */
    public func createSubCachePath(subCacheName:String)
    {
        let subCache=NSString(string:cachePath).stringByAppendingPathComponent(subCacheName)
        if(!fileManager.fileExistsAtPath(subCache))
        {
            do {
                try fileManager.createDirectoryAtPath(subCache, withIntermediateDirectories: false, attributes: nil)
            } catch _ {
            }
        }
    }
    
    /*dataForKey:
     *  获取指定标示对应的本地数据
     */
    public func dataForKey(key:String,subPath:String) -> NSData?
    {
        var path=NSString(string:cachePath).stringByAppendingPathComponent(subPath)
        path=NSString(string:path).stringByAppendingPathComponent(key)
        var result:NSData?=nil
        
        if(fileManager.fileExistsAtPath(path))
        {
            let attrs:NSDictionary=try! fileManager.attributesOfItemAtPath(path)
            let date:NSDate=attrs.objectForKey(NSFileModificationDate) as! NSDate
            
            if(expireTime==0 || date.timeIntervalSinceNow<expireTime)
            {
                result=NSData(contentsOfFile: path)
            }
            else
            {
                do {
                    try fileManager.removeItemAtPath(path)
                } catch _ {
                }
            }
        }
        
        return result
    }
    
    /*setData:
     *  存入本地数据
     */
    public func setData(data:NSData,key:String,subPath:String)
    {
        let path=self.removeDataForKey(key, subPath: subPath)
        data.writeToFile(path, atomically: true)
    }
    
    /*removeDataForKey:
     *  删除本地数据
     */
    public func removeDataForKey(key:String,subPath:String) -> String
    {
        var path=NSString(string:cachePath).stringByAppendingPathComponent(subPath)
        path=NSString(string:path).stringByAppendingPathComponent(key)
        
        if(fileManager.fileExistsAtPath(path))
        {
            do {
                try fileManager.removeItemAtPath(path)
            } catch _ {
            }
        }
        
        return path
    }
    
    /*clearDataForSubPath:
     *  清除子目录数据
     */
    public func clearDataForSubPath(subPath:String)
    {
        let path=NSString(string:cachePath).stringByAppendingPathComponent(subPath)
        do {
            try fileManager.removeItemAtPath(path)
        } catch _ {
        }
        do {
            try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil)
        } catch _ {
        }
    }
    
    /*sizeOfSubPath:
     *  获取子目录的数据大小
     */
    public func sizeOfSubPath(subPath:String) -> UInt64
    {
        var result:UInt64=0
        let path=NSString(string:cachePath).stringByAppendingPathComponent(subPath)
        
        let fileArray:NSArray?=try? fileManager.contentsOfDirectoryAtPath(path)
        if((fileArray) != nil)
        {
            var filePath=""
            for i in 0 ..< fileArray!.count
            {
                filePath=NSString(string:path).stringByAppendingPathComponent(fileArray!.objectAtIndex(i) as! String)
                
                var isDict:ObjCBool=false
                if(fileManager.fileExistsAtPath(filePath,isDirectory:&isDict)&&isDict)
                {
                    result+=self.sizeOfSubPath(filePath)
                }
                else
                {
                    let attrs:NSDictionary=try! fileManager.attributesOfItemAtPath(path)
                    result+=attrs.fileSize()
                }
            }
        }
        
        return result
    }
}
