//
//  PbDataCacheFile.swift
//  swiftPbTest
//  本地文件缓存管理器
//  Created by Maqiang on 15/6/19.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

open class PbDataCacheFile
{
    //fileManager:文件管理器
    let fileManager:FileManager=FileManager.default
    
    //rootPath:文件根目录
    var rootPath:String=""
    
    //cachePath:记录缓存目录
    var cachePath:String=""
    
    //expireTime:缓存过期时间
    var expireTime:TimeInterval=0
    
    /*init:
     *初始化
     */
    public init(cachePathName:String)
    {
        //获取用户缓存目录
        let paths:Array=NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask,true) as Array
        rootPath=paths[0] 
        
        //指定的缓存目录不存在则创建目录
        self.cachePath=NSString(string:rootPath).appendingPathComponent(cachePathName)
        if(!fileManager.fileExists(atPath: cachePath))
        {
            do {
                try fileManager.createDirectory(atPath: cachePath, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
            }
        }
    }
    
    /*createSubCachePath:
     *  创建缓存子目录
     */
    open func createSubCachePath(_ subCacheName:String)
    {
        let subCache=NSString(string:cachePath).appendingPathComponent(subCacheName)
        if(!fileManager.fileExists(atPath: subCache))
        {
            do {
                try fileManager.createDirectory(atPath: subCache, withIntermediateDirectories: false, attributes: nil)
            } catch _ {
            }
        }
    }
    
    /*dataForKey:
     *  获取指定标示对应的本地数据
     */
    open func dataForKey(_ key:String,subPath:String) -> Data?
    {
        var path=NSString(string:cachePath).appendingPathComponent(subPath)
        path=NSString(string:path).appendingPathComponent(key)
        var result:Data?=nil
        
        if(fileManager.fileExists(atPath: path))
        {
            let attrs:NSDictionary=try! fileManager.attributesOfItem(atPath: path) as NSDictionary
            let date:Date=attrs.object(forKey: FileAttributeKey.modificationDate) as! Date
            
            if(expireTime==0 || date.timeIntervalSinceNow<expireTime)
            {
                result=try? Data(contentsOf: URL(fileURLWithPath: path))
            }
            else
            {
                do {
                    try fileManager.removeItem(atPath: path)
                } catch _ {
                }
            }
        }
        
        return result
    }
    
    /*setData:
     *  存入本地数据
     */
    open func setData(_ data:Data,key:String,subPath:String)
    {
        let path=self.removeDataForKey(key, subPath: subPath)
        try? data.write(to: URL(fileURLWithPath: path), options: [.atomic])
    }
    
    /*removeDataForKey:
     *  删除本地数据
     */
    open func removeDataForKey(_ key:String,subPath:String) -> String
    {
        var path=NSString(string:cachePath).appendingPathComponent(subPath)
        path=NSString(string:path).appendingPathComponent(key)
        
        if(fileManager.fileExists(atPath: path))
        {
            do {
                try fileManager.removeItem(atPath: path)
            } catch _ {
            }
        }
        
        return path
    }
    
    /*clearDataForSubPath:
     *  清除子目录数据
     */
    open func clearDataForSubPath(_ subPath:String)
    {
        let path=NSString(string:cachePath).appendingPathComponent(subPath)
        do {
            try fileManager.removeItem(atPath: path)
        } catch _ {
        }
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
        } catch _ {
        }
    }
    
    /*sizeOfSubPath:
     *  获取子目录的数据大小
     */
    open func sizeOfSubPath(_ subPath:String) -> UInt64
    {
        var result:UInt64=0
        let path=NSString(string:cachePath).appendingPathComponent(subPath)
        
        let fileArray:NSArray?=try! fileManager.contentsOfDirectory(atPath: path) as NSArray?
        if((fileArray) != nil)
        {
            var filePath=""
            for i in 0 ..< fileArray!.count
            {
                filePath=NSString(string:path).appendingPathComponent(fileArray!.object(at: i) as! String)
                
                var isDict:ObjCBool=false
                let isDictPointer:UnsafeMutablePointer<ObjCBool>=UnsafeMutablePointer(&isDict);
                if(fileManager.fileExists(atPath: filePath,isDirectory:isDictPointer) && isDict.boolValue)
                {
                    result+=self.sizeOfSubPath(filePath)
                }
                else
                {
                    let attrs:NSDictionary=try! fileManager.attributesOfItem(atPath: path) as NSDictionary
                    result+=attrs.fileSize()
                }
            }
        }
        
        return result
    }
}
