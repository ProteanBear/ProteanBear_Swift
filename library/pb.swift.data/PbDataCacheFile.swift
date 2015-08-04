//
//  PbDataCacheFile.swift
//  swiftPbTest
//  本地文件缓存管理器
//  Created by Maqiang on 15/6/19.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

class PbDataCacheFile
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
    init(cachePathName:String)
    {
        //获取用户缓存目录
        let paths:Array=NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask,true) as Array
        rootPath=paths[0] as! String
        
        //指定的缓存目录不存在则创建目录
        self.cachePath=rootPath.stringByAppendingPathComponent(cachePathName)
        if(!fileManager.fileExistsAtPath(cachePath))
        {
            fileManager.createDirectoryAtPath(cachePath, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
    }
    
    /*createSubCachePath:
     *  创建缓存子目录
     */
    func createSubCachePath(subCacheName:String)
    {
        var subCache=cachePath.stringByAppendingPathComponent(subCacheName)
        if(!fileManager.fileExistsAtPath(subCache))
        {
            fileManager.createDirectoryAtPath(subCache, withIntermediateDirectories: false, attributes: nil, error: nil)
        }
    }
    
    /*dataForKey:
     *  获取指定标示对应的本地数据
     */
    func dataForKey(key:String,subPath:String) -> NSData?
    {
        var path=cachePath.stringByAppendingPathComponent(subPath)
        path=path.stringByAppendingPathComponent(key)
        var result:NSData?=nil
        
        if(fileManager.fileExistsAtPath(path))
        {
            var attrs:NSDictionary=fileManager.attributesOfItemAtPath(path, error: nil)!
            var date:NSDate=attrs.objectForKey(NSFileModificationDate) as! NSDate
            
            if(expireTime==0 || date.timeIntervalSinceNow<expireTime)
            {
                result=NSData(contentsOfFile: path)
            }
            else
            {
                fileManager.removeItemAtPath(path, error: nil)
            }
        }
        
        return result
    }
    
    /*setData:
     *  存入本地数据
     */
    func setData(data:NSData,key:String,subPath:String)
    {
        var path=self.removeDataForKey(key, subPath: subPath)
        data.writeToFile(path, atomically: true)
    }
    
    /*removeDataForKey:
     *  删除本地数据
     */
    func removeDataForKey(key:String,subPath:String) -> String
    {
        var path=cachePath.stringByAppendingPathComponent(subPath)
        path=path.stringByAppendingPathComponent(key)
        
        if(fileManager.fileExistsAtPath(path))
        {
            fileManager.removeItemAtPath(path, error: nil)
        }
        
        return path
    }
    
    /*clearDataForSubPath:
     *  清除子目录数据
     */
    func clearDataForSubPath(subPath:String)
    {
        var path=cachePath.stringByAppendingPathComponent(subPath)
        fileManager.removeItemAtPath(path, error: nil)
        fileManager.createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil, error: nil)
    }
    
    /*sizeOfSubPath:
     *  获取子目录的数据大小
     */
    func sizeOfSubPath(subPath:String) -> UInt64
    {
        var result:UInt64=0
        var path=cachePath.stringByAppendingPathComponent(subPath)
        
        var fileArray:NSArray?=fileManager.contentsOfDirectoryAtPath(path, error: nil)
        if((fileArray) != nil)
        {
            var filePath=""
            for(var i=0;i<fileArray!.count;i++)
            {
                filePath=path.stringByAppendingPathComponent(fileArray!.objectAtIndex(i) as! String)
                
                var isDict:ObjCBool=false
                if(fileManager.fileExistsAtPath(filePath,isDirectory:&isDict)&&isDict)
                {
                    result+=self.sizeOfSubPath(filePath)
                }
                else
                {
                    let attrs:NSDictionary=fileManager.attributesOfItemAtPath(path, error: nil)!
                    result+=attrs.fileSize()
                }
            }
        }
        
        return result
    }
}
