//
//  PbDataAppController.swift
//  swiftPbTest
//  Description：应用数据层控制器
//  Created by Maqiang on 15/6/15.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

import CoreLocation
import ReachabilitySwift

/*PbDataUpdateMode:
*  枚举类型，数据更新模式
*/
enum PbDataUpdateMode:Int
{
    case First,Update,NextPage
}

/*PbDataGetMode:
 *  枚举类型，数据获取模式
 */
enum PbDataGetMode:Int
{
    case FromNet,FromLocalOrNet,FromLocal
}

/*PbDataLocationMode:
*  枚举类型，定位获取模式
*/
enum PbDataLocationMode:Int
{
    case None,InUse,Always
}

//应用数据层控制器
class PbDataAppController:NSObject,CLLocationManagerDelegate
{
    /*-----------------------开始：静态常量*/
    //KEY_RESPONSE:控制器返回内容
    static let KEY_RESPONSE="PbDataResponse"
    //KEY_NETWORK:控制器返回内容-网络状态
    static let KEY_NETWORK="network"
    //KEY_SUCCESS:控制器返回内容-请求状态
    static let KEY_SUCCESS="success"
    /*-----------------------结束：静态常量*/
    
    /*-----------------------开始：静态方法，实现单例模式*/
    
    class var getInstance:PbDataAppController
    {
        return Inner.instance;
    }
    
    struct Inner
    {
        static let instance:PbDataAppController=PbDataAppController();
    }
    
    /*-----------------------结束：静态方法，实现单例模式*/
    
    /*-----------------------开始：声明属性*/
    
    //调试定位信息
    private let logPre="PbDataAppController:";
    
    //config:Plist保存的相关URL访问及数据存储的配置
    var config=NSDictionary()
    //服务地址(server)
    var server=""
    //备用服务地址(alterServer)
    var alterServer=""
    //全局参数字典(global)
    var global:NSDictionary?=NSDictionary()
    //访问协议(netProtocol)
    var netProtocol="HTTP"
    //请求方式(method)
    var method="POST"
    //返回类型(responseType)
    var responseType="JSON"
    //超时时间(timeOut,单位为秒)
    var timeOut=10
    //是否启用本地缓存(isActiveLocalCache)
    var isActiveLocalCache=true
    //本地目录(cachePath)
    var cachePath="localCache"
    //资源子目录(resourceSubPath)
    var resourceSubPath="resources"
    //数据子目录(dataSubPath)
    var dataSubPath="localData"
    //超时时间(expireTime)
    var expireTime=0
    //请求接口(interface)
    var interface:NSDictionary?
    //本地菜单(localMenu)
//    var localMenu:NSDictionary?
    
    /*网络情况记录*/
    //reachability:网络连接测试对象
    var reachability:Reachability!
    //networkStatus:网络连接状态
    var networkStatus=Reachability.NetworkStatus.NotReachable{didSet{PbLog.debug(logPre+"NetworkStatus:网络状态:"+self.networkStatus.description)}}
    
    /*当前设备相关信息*/
    //reachability:设备相关信息
    var deviceParams:Dictionary<String,String>=Dictionary()
    
    /*应用处理器*/
    //requester:请求处理器对象
    var requester:PbDataRequester?
    //parser:结果解析器对象
    var parser:PbDataParser?
    //cacheManager:缓存管理器对象
    var cacheManager:PbDataCacheFile?
    
    /*定位相关*/
    //locationManager:定位管理器对象
    var locationManager:CLLocationManager?
    //lastLocation:最新定位地址
    var lastLocation:CLLocation?
    
    /*-----------------------结束：声明私有属性*/
    
    /*-----------------------开始：对象初始化相关方法*/
    
    /*initWithPlistName:
     *  使用配置文件初始化应用数据控制器，读取相应的URL访问及数据存储相关配置
     */
    func initWithPlistName(plistName:String)
    {
        self.initWithPlistName(plistName, initLocationManager:PbDataLocationMode.InUse)
    }
    
    /*initWithPlistName:
     *  使用配置文件初始化应用数据控制器，读取相应的URL访问及数据存储相关配置
     */
    func initWithPlistName(plistName:String,initLocationManager:PbDataLocationMode)
    {
        /*载入plist配置文件*/
        self.loadPlist(plistName)
        
        /*读取配置信息*/
        self.readConfig()
    
        /*判断当前网络连接情况*/
        self.loadNetworkStatus()
        
        /*根据配置信息初始化当前的处理对象*/
        self.createProcessObjects()
        
        /*读取相关设备信息*/
        self.loadDeviceInfo()
        
        /*创建定位管理器*/
        self.createLocationManager(initLocationManager)
    }
    
    /*reloadByPlistName:
     *  重新载入配置文件并重新初始化内部处理器对象
     */
    func reloadByPlistName(plistName:String)
    {
    }
    
    /*loadPlist:
     *  载入指定的PList文件
     */
    private func loadPlist(plistName:String)
    {
        //调试信息前缀
        let logPre=self.logPre+"loadPlist:"
        
        /*读取Plist*/
        let path:String?=NSBundle.mainBundle().pathForResource(plistName,ofType:"plist")
        if((path) != nil)
        {
            PbLog.debug(logPre+"开始读取Plist资源（Path:"+path!+"）")
            self.config=NSDictionary(contentsOfFile:path!)!
            PbLog.debug(logPre+"读取完成")
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
    
    /*loadNetworkStatus:
     *  判断当前的网络状态
     */
    func loadNetworkStatus()
    {
        //调试信息前缀
        let logPre=self.logPre+"loadNetworkStatus:"
        
        do
        {
            self.reachability = try Reachability.reachabilityForInternetConnection()
            self.networkStatus=reachability.currentReachabilityStatus
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "doWhenNetworkStatusChange:", name: ReachabilityChangedNotification, object: reachability)
            try reachability.startNotifier()
        }
        catch
        {
            PbLog.error(logPre+"创建Reachability或启动监听（startNotifier）失败！")
            self.networkStatus=Reachability.NetworkStatus.NotReachable
        }
        
    }
    
    /*doWhenNetworkStatusChange:
     *  网络状态变化时记录当前的状态
     */
    func doWhenNetworkStatusChange(note:NSNotification)
    {
        self.networkStatus=reachability.currentReachabilityStatus
    }
    
    /*createProcessObjects:
     *  根据配置信息初始化当前的处理对象
     */
    func createProcessObjects()
    {
        /*根据配置信息初始化远程服务请求处理对象*/
        //http协议
        if(netProtocol=="HTTP")
        {
            self.requester=PbDataRequesterHttp(isGet: method=="GET")
            PbLog.debug(logPre+"createProcessObjects:应用处理器:"+"HTTP请求处理器")
        }
        
        /*根据配置信息初始化远程服务结果处理对象*/
        //JSON数据格式
        if(responseType=="JSON")
        {
            self.parser=PbDataParserJson()
            PbLog.debug(logPre+"createProcessObjects:应用处理器:"+"JSON返回解析器")
        }
        
        /*根据配置信息初始化本地缓存处理对象*/
        self.cacheManager=PbDataCacheFile(cachePathName:cachePath)
        PbLog.debug(logPre+"createProcessObjects:应用处理器:"+"本地缓存管理器")
        if(isActiveLocalCache)
        {
            cacheManager?.createSubCachePath(resourceSubPath)
            cacheManager?.createSubCachePath(dataSubPath)
            PbLog.debug(logPre+"createProcessObjects:应用处理器:"+"本地缓存管理器激活（创建子目录-"+resourceSubPath+"和"+dataSubPath)
        }
        else
        {
            cacheManager?.clearDataForSubPath(resourceSubPath)
            cacheManager?.clearDataForSubPath(dataSubPath)
            PbLog.debug(logPre+"createProcessObjects:应用处理器:"+"未激活本地缓存管理器,清空缓存目录-"+cachePath)
        }
    }
    
    /*loadDeviceInfo
     *  载入设备相关信息
     */
    func loadDeviceInfo()
    {
        //获取当前设备
        let device=(UIDevice.currentDevice())
        //获取当前屏幕
        let screen=(UIScreen.mainScreen())
        
        //设置设备参数
        self.deviceParams["deviceName"]=device.model
        self.deviceParams["deviceSystem"]=device.systemName
        self.deviceParams["deviceVersion"]=device.systemVersion
        self.deviceParams["deviceWidth"]=(NSString(string:screen.applicationFrame.width.description).intValue).description
        self.deviceParams["deviceHeight"]=(NSString(string:screen.applicationFrame.height.description).intValue).description
        self.deviceParams["deviceUuid"]=device.identifierForVendor!.UUIDString.md5()
        self.deviceParams["appVersion"]=(((NSBundle.mainBundle().infoDictionary)! as NSDictionary).objectForKey(kCFBundleVersionKey))?.description
        
        //输出当前设备信息
        PbLog.debug(logPre+"loadDeviceInfo:设备名称:"+self.deviceParams["deviceName"]!)
        PbLog.debug(logPre+"loadDeviceInfo:系统名称:"+self.deviceParams["deviceSystem"]!)
        PbLog.debug(logPre+"loadDeviceInfo:系统版本:"+self.deviceParams["deviceVersion"]!)
        PbLog.debug(logPre+"loadDeviceInfo:屏幕宽度:"+self.deviceParams["deviceWidth"]!)
        PbLog.debug(logPre+"loadDeviceInfo:屏幕高度:"+self.deviceParams["deviceHeight"]!)
        PbLog.debug(logPre+"loadDeviceInfo:唯一标识:"+self.deviceParams["deviceUuid"]!)
        PbLog.debug(logPre+"loadDeviceInfo:应用版本:"+self.deviceParams["appVersion"]!)
    }
    
    /*createLocationManager
     *  创建并配置定位管理器对象
     */
    func createLocationManager(locationMode:PbDataLocationMode)
    {
        if((locationManager) == nil&&locationMode != PbDataLocationMode.None)
        {
            locationManager=CLLocationManager()
            locationManager?.delegate=self
            locationManager?.desiredAccuracy=kCLLocationAccuracyBest
            locationManager?.distanceFilter=1000
            lastLocation=nil
            
            PbLog.debug(logPre+"createLocationManager:创建定位管理器")
            
            //iOS8下询问用户
            if(PbSystem.osUp8())
            {
                if(locationMode == PbDataLocationMode.Always)
                {
                    locationManager?.requestAlwaysAuthorization()
                }
                if(locationMode == PbDataLocationMode.InUse)
                {
                    locationManager?.requestWhenInUseAuthorization()
                }
            }
            
            locationManager?.startUpdatingLocation()
        }
    }
    
    /*-----------------------结束：对象初始化相关方法*/
    
    /*-----------------------开始：业务处理相关方法*/
    
    /*isNetworkConnected:
     *  是否连接网络
     */
    func isNetworkConnected() -> Bool
    {
        return networkStatus != Reachability.NetworkStatus.NotReachable
    }
    
    /*isNetworkConnected:
     *  是否连接网络
     */
    func isNetworkConnected(statusDescription:String) -> Bool
    {
        return statusDescription != Reachability.NetworkStatus.NotReachable.description
    }
    
    /*deviceUuid:
     *  获取指定的设备唯一编号
     */
    func deviceUuid() -> String
    {
        return deviceParams["uuid"]!
    }
    
    /*requestWithKey:
     *  通过指定接口标识，获取对应的数据信息
     * @params key       接口标识
     * @params params    传递参数
     * @params callback  回调方法
     * @params getMode   请求模式，包括网络、本地缓存或网络、本地
     */
    func requestWithKey(key:String,params:NSDictionary,callback:(data:NSDictionary!,error:NSError?,property:NSDictionary?) -> Void,getMode:PbDataGetMode)
    {
        requestWithKey(key, params: params, callback: callback, getMode: getMode, property: nil,useAlterServer:false,dataType:false)
    }
    
    /*requestWithKey:
     *  通过指定接口标识，获取对应的数据信息
     * @params key       接口标识
     * @params params    传递参数
     * @params callback  回调方法
     * @params getMode   请求模式，包括网络、本地缓存或网络、本地
     * @params property  回传属性
     */
    func requestWithKey(key:String,params:NSDictionary,callback:(data:NSDictionary!,error:NSError?,property:NSDictionary?) -> Void,getMode:PbDataGetMode,property:NSDictionary?)
    {
        requestWithKey(key, params: params, callback: callback, getMode: getMode, property: property,useAlterServer:false,dataType:false)
    }
    
    /*requestWithKey:
     *  通过指定接口标识，获取对应的数据信息
     * @params key              接口标识
     * @params params           传递参数
     * @params callback         回调方法
     * @params getMode          请求模式，包括网络、本地缓存或网络、本地
     * @params property         回传属性
     * @params useAlterServer   是否使用备用服务地址
     */
    func requestWithKey(key:String,params:NSDictionary,callback:(data:NSDictionary!,error:NSError?,property:NSDictionary?) -> Void,getMode:PbDataGetMode,property:NSDictionary?,useAlterServer:Bool)
    {
        requestWithKey(key, params: params, callback: callback, getMode: getMode, property: property,useAlterServer:useAlterServer,dataType:false)
    }
    
    /*requestWithKey:
     *  通过指定接口标识，获取对应的数据信息
     * @params key              接口标识
     * @params params           传递参数
     * @params callback         回调方法
     * @params getMode          请求模式，包括网络、本地缓存或网络、本地
     * @params sourceType       是否数据上传类型
     */
    func requestWithKey(key:String,params:NSDictionary,callback:(data:NSDictionary!,error:NSError?,property:NSDictionary?) -> Void,getMode:PbDataGetMode,dataType:Bool)
    {
        requestWithKey(key, params: params, callback: callback, getMode: getMode, property: nil,useAlterServer:false,dataType:dataType)
    }
    
    /*requestWithKey:
     *  通过指定接口标识，获取对应的数据信息
     * @params key              接口标识
     * @params params           传递参数
     * @params callback         回调方法
     * @params getMode          请求模式，包括网络、本地缓存或网络、本地
     * @params property         回传属性
     * @params sourceType       是否数据上传类型
     */
    func requestWithKey(key:String,params:NSDictionary,callback:(data:NSDictionary!,error:NSError?,property:NSDictionary?) -> Void,getMode:PbDataGetMode,property:NSDictionary?,dataType:Bool)
    {
        requestWithKey(key, params: params, callback: callback, getMode: getMode, property: property,useAlterServer:false,dataType:dataType)
    }
    
    /*requestWithKey:
     *  通过指定接口标识，获取对应的数据信息
     * @params key              接口标识
     * @params params           传递参数
     * @params callback         回调方法
     * @params getMode          请求模式，包括网络、本地缓存或网络、本地
     * @params property         回传属性
     * @params useAlterServer   是否使用备用服务地址
     * @params sourceType       是否数据上传类型
     */
    func requestWithKey(key:String,params:NSDictionary,callback:(data:NSDictionary!,error:NSError?,property:NSDictionary?) -> Void,getMode:PbDataGetMode,property:NSDictionary?,useAlterServer:Bool,dataType:Bool)
    {
        //调试信息前缀
        let curLogPre=logPre+"requestWithKey:"
        
        //根据指定的接口标示获取接口信息
        let attributes=interface?.objectForKey(key) as! NSDictionary
        
        //获取远程接口链接地址
        let url:String=((!alterServer.isEmpty&&useAlterServer) ?alterServer:server)+attributes.objectForKey("url")!.description
        PbLog.debug(curLogPre+"请求地址:"+url)
        
        //获取请求参数
        let configParams=attributes.objectForKey("params") as! NSDictionary
        let sendParams=NSMutableDictionary(dictionary: configParams)
        sendParams.setValuesForKeysWithDictionary(params as! [String : AnyObject])
        sendParams.setValuesForKeysWithDictionary(global as! [String : AnyObject])
        PbLog.debug(curLogPre+"请求参数:"+requester!.paramString(sendParams))
        
        //记录本地资源是否存在
        var isExist=false
        //记录返回数据信息
        //let resCount:Int=((property) == nil) ?1:(property!.count+1)
        //记录返回数据
        var resData:NSData?=nil
        //记录文件缓存对应的文件名
        let fileKey=String(url+"?"+requester!.paramString(sendParams)).md5()
        
        //非纯网络模式，先读取本地缓存数据
        if(getMode != PbDataGetMode.FromNet && isActiveLocalCache)
        {
            PbLog.debug(curLogPre+"缓存文件:"+fileKey)
            resData=cacheManager?.dataForKey(fileKey, subPath: dataSubPath)
            isExist=(resData != nil)
        }
        
        //非纯本地模式，并本地数据不存在，请求网络
        if(!isExist && getMode != PbDataGetMode.FromLocal && self.isNetworkConnected())
        {
            //添加设备信息参数
            sendParams.setValuesForKeysWithDictionary(deviceParams)
            //添加定位信息参数
            if(lastLocation != nil)
            {
                sendParams.setValue(lastLocation!.coordinate.longitude.description,
                    forKey:"longitude")
                sendParams.setValue(lastLocation!.coordinate.latitude.description,
                    forKey:"latitude")
            }
            PbLog.debug(curLogPre+"请求内容:"+requester!.paramString(sendParams))
            
            //发送请求
            requester?.request(url, data: sendParams,callback: {
                (data, response, error) -> Void in
                
                //返回数据存在则存入缓存
                if(self.isActiveLocalCache)
                {
                    if(data != nil)
                    {
                        resData=data
                        self.cacheManager?.setData(data, key: fileKey, subPath: self.dataSubPath)
                    }
                    //如果网络请求数据不存在，则临时读取缓存数据
                    else
                    {
                        resData=self.cacheManager?.dataForKey(fileKey, subPath: self.dataSubPath)
                    }
                }
                self.handleResponse(resData, callback: callback, error: error, property: property)
            },isMultipart:dataType)
        }
        //非请求网络则直接处理返回数据
        else
        {
            self.handleResponse(resData, callback: callback, error: nil, property: property)
        }
    }
    
    /*-----------------------结束：业务处理相关方法*/
    
    /*-----------------------开始：业务处理相关私有方法*/
    
    /*handleResponse
     *  处理返回数据内容
     */
    private func handleResponse(data:NSData?,callback:(data:NSDictionary!,error:NSError?,property:NSDictionary?) -> Void,error:NSError?,property:NSDictionary?)
    {
        var response:NSMutableDictionary? = parser?.dictionaryByData(data)
        let success=(response != nil)
        response=(response == nil) ? NSMutableDictionary():response
        
        //为结果数据添加控制器相关回复值
        response!.setValue([PbDataAppController.KEY_NETWORK:networkStatus.description,PbDataAppController.KEY_SUCCESS:success.description],forKey: PbDataAppController.KEY_RESPONSE)
        
        //回调反馈方法
        callback(data:response,error:error,property:property)
    }
    
    /*imageInLocalCache:
     *  读取本地缓存的图片
     */
    func imageInLocalCache(imageUrl:String) -> UIImage?
    {
        let data=cacheManager?.dataForKey(imageUrl.md5(),subPath:resourceSubPath)
        return (data == nil) ? nil : UIImage(data:data!)
    }
    
    /*saveImageIntoLocalCache:
     *  写入图片到本地缓存中
     */
    func saveImageIntoLocalCache(imageData:NSData,forUrl:String)
    {
        if(isActiveLocalCache)
        {
            cacheManager?.setData(imageData, key: forUrl.md5(), subPath: resourceSubPath)
        }
    }
    
    /*sizeOfCacheDataInLocal:
     *  获取本地缓存数据大小
     */
    func sizeOfCacheDataInLocal() -> String
    {
        var size:UInt64=0
        
        //计算缓存文件夹的大小
        size+=cacheManager!.sizeOfSubPath(dataSubPath)
        size+=cacheManager!.sizeOfSubPath(resourceSubPath)
        let sizef:Float64=Float64(size)
        
        //转换为文字描述
        var result=""
        if(size>1024*1024*1024)
        {
            result=NSString(format:"%.2f GB",sizef/(1024*1024*1024)) as String
        }
        else if(size>1024*1024)
        {
            result=NSString(format:"%.2f MB",sizef/(1024*1024)) as String
        }
        else if(size>1024)
        {
            result=NSString(format:"%.2f KB",sizef/(1024)) as String
        }
        else
        {
            result=NSString(format:"%.0f byte",sizef) as String
        }
        
        return result
    }
    
    /*clearCacheDataInLocal:
     *  清理缓存数据
     */
    func clearCacheDataInLocal() -> String
    {
        cacheManager?.clearDataForSubPath(dataSubPath)
        cacheManager?.clearDataForSubPath(resourceSubPath)
        return self.sizeOfCacheDataInLocal()
    }
    /*-----------------------结束：业务处理相关私有方法*/
    
    /*-----------------------开始：实现CLLocationManagerDelegate委托*/
    
    /*locationManager:didUpdateToLocation:fromLocation:
     *  更新到最新的位置
     */
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation)
    {
        lastLocation=newLocation
        PbLog.debug(logPre+"locationManager:最新定位:"+"经度("+newLocation.coordinate.longitude.description+"),纬度("+newLocation.coordinate.latitude.description+")")
    }
    
    /*-----------------------结束：实现CLLocationManagerDelegate委托*/
}
