
//
//  PbDataUserController.swift
//  Pods
//
//  Created by Maqiang on 16/2/23.
//
//

import Foundation

public class PbDataUserController:NSObject
{
    /*-----------------------开始：静态方法，实现单例模式*/
    
    public class var getInstance:PbDataUserController
    {
        return Inner.instance;
    }
    
    struct Inner
    {
        static let instance:PbDataUserController=PbDataUserController();
    }
    
    /*-----------------------结束：静态方法，实现单例模式*/
    
    /*-----------------------开始：声明属性*/
    
    //静态属性
    private let keyUserData="userData"
    
    //调试定位信息
    private let logPre="PbDataUserController:";
    
    //用户设置信息
    let userDefaults=NSUserDefaults.standardUserDefaults()
    //用户数据
    public var userData:([String:AnyObject])?
    
    /*-----------------------结束：声明私有属性*/
    
    /*-----------------------开始：对象初始化相关方法*/
    
    /*initWithPlistName:
     *  使用配置文件初始化应用数据控制器，读取相应的URL访问及数据存储相关配置
     */
    public func initWithPlistName(plistName:String)
    {
        self.reloadByPlistName(plistName)
    }
    
    /*reloadByPlistName:
     *  重新载入配置文件并重新初始化内部处理器对象
     */
    public func reloadByPlistName(plistName:String)
    {
        /*载入plist配置文件*/
        self.loadPlist(plistName)
        
        /*读取配置信息*/
        self.readConfig()
    }
    
    /*loadPlist:
     *  载入指定的PList文件
     */
    private func loadPlist(plistName:String)
    {
        //调试信息前缀
        let logPre=self.logPre+"loadPlist:"
        
        //如果用户设置存在，直接读取用户设置
        if let data=self.userDefaults.dictionaryForKey(self.keyUserData)
        {
            PbSystem.
        }
    }
    
    /*readConfig:
    *  读取相应的配置信息
    */
    private func readConfig()
    {
        //调试信息前缀
        let logPre=self.logPre+"readConfig:"
        
        /*读取配置信息*/
        PbLog.debug(logPre+"开始读取配置信息")
        let keys:NSArray=self.config.allKeys
        let count:Int=self.config.count
        for(var i=0;i<count;i++)
        {
            let key:String=keys.objectAtIndex(i) as! String
            let value:AnyObject=self.config.objectForKey(key)!;
            
            //服务地址(server)
            if(key=="server")
            {
                server=value as! String
                PbLog.debug(logPre+"服务地址:"+server)
            }
            //备用服务地址(alterServer)
            if(key=="alterServer")
            {
                alterServer=value as! String
                PbLog.debug(logPre+"备用服务地址:"+alterServer)
            }
            //全局参数字典(global)
            if(key=="global")
            {
                global=value as? NSDictionary
                PbLog.debug(logPre+"全局参数:总数("+global!.count.description+")")
            }
            
            //通讯协议(communication)
            if(key=="communication")
            {
                let communication:NSDictionary=value as! NSDictionary
                //访问协议(netProtocol)
                netProtocol=communication.objectForKey("protocol") as! String
                PbLog.debug(logPre+"访问协议:"+netProtocol)
                //请求方式(method)
                method=communication.objectForKey("method") as! String
                PbLog.debug(logPre+"请求方式:"+method)
                //返回类型(responseType)
                responseType=communication.objectForKey("responseType") as! String
                PbLog.debug(logPre+"返回类型:"+responseType)
                //超时时间(timeOut)
                timeOut=communication.objectForKey("timeOut") as! Int;
                PbLog.debug(logPre+"超时时间:"+timeOut.description)
                //是否使用Cookie-Session处理
            }
            
            //文件缓存(localCache)
            if(key=="localCache")
            {
                let localCache:NSDictionary=value as! NSDictionary
                //是否激活(isActiveLocalCache)
                isActiveLocalCache=localCache.objectForKey("isActive") as! Bool
                PbLog.debug(logPre+"文件缓存:是否激活:"+isActiveLocalCache.description)
                //本地目录(cachePath)
                cachePath=localCache.objectForKey("cachePath") as! String
                PbLog.debug(logPre+"文件缓存:本地目录:"+cachePath)
                //资源子目录(resourceSubPath)
                resourceSubPath=localCache.objectForKey("subResourcePath") as! String
                PbLog.debug(logPre+"文件缓存:资源目录:"+resourceSubPath)
                //数据子目录(dataSubPath)
                dataSubPath=localCache.objectForKey("subDataPath") as! String
                PbLog.debug(logPre+"文件缓存:数据目录:"+dataSubPath)
                //超时时间(expireTime)
                expireTime=localCache.objectForKey("expireTime") as! Int;
                PbLog.debug(logPre+"文件缓存:超时时间:"+expireTime.description)
            }
            
            //数据接口(interface)
            if(key=="interface")
            {
                interface=value as? NSDictionary
                PbLog.debug(logPre+"数据接口:总数("+interface!.count.description+")")
            }
            
            //本地菜单(localMenu)
            //            if(key=="localMenu")
            //            {
            //                localMenu=value as? NSDictionary
            //                PbLog.debug(logPre+"本地菜单:总数("+localMenu!.count.description+")")
            //            }
        }
        
        PbLog.debug(logPre+"结束配置信息读取")
    }
    
    /*-----------------------结束：对象初始化相关方法*/
}