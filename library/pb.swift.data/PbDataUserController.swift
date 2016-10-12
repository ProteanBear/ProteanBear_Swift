
//
//  PbDataUserController.swift
//  Pods
//
//  Created by Maqiang on 16/2/23.
//
//

import Foundation

open class PbDataUserController:NSObject
{
    /*-----------------------开始：静态方法，实现单例模式*/
    
    open class var instance:PbDataUserController{
        return Inner.instance;
    }
    
    struct Inner
    {
        static let instance:PbDataUserController=PbDataUserController();
    }
    
    /*-----------------------结束：静态方法，实现单例模式*/
    
    /*-----------------------开始：公共方法*/
    /// 返回用户是否第一次打开应用
    open var isFirstLaunch:Bool{
        return self.userDefaults.bool(forKey: PbDataUserController.keyFirstLaunch)
    }
    
    /// 保存用户信息
    open func saveUserData()
    {
        self.userData?.setValue(self.userFavorite,forKey:"userFavorite")
        self.userDefaults.set(self.userData, forKey: PbDataUserController.keyUserData)
        self.userDefaults.synchronize()
    }
    
    /// 是否已经收藏
    /// - parameter id:收藏的主键标识
    open func isFavorite(_ id:String) ->Bool
    {
        return self.userFavorite?.value(forKey: id) != nil
    }
    
    /// 增加收藏
    /// - parameter data:收藏数据
    /// - parameter id:收藏的主键标识
    open func addFavorite(_ data:AnyObject,id:String)
    {
        self.userFavorite?.setObject(data, forKey: id as NSCopying)
        self.saveUserData()
    }
    
    /// 移除收藏
    /// - parameter id:收藏的主键标识
    open func removeFavorite(_ id:String)
    {
        self.userFavorite?.removeObject(forKey: id)
        self.saveUserData()
    }
    /// 移除收藏
    /// - parameter idArray:收藏的主键数组
    open func removeFavoritesWithArray(_ idArray:NSArray)
    {
        self.userFavorite?.removeObjects(forKeys: idArray as [AnyObject])
        self.saveUserData()
    }
    /// 移除收藏
    /// - parameter ids:收藏的主键数组
    open func removeFavorites(_ ids:[String])
    {
        self.userFavorite?.removeObjects(forKeys: ids)
        self.saveUserData()
    }
    
    /// 检查用户数据中，指定的键是否存在
    /// - parameter forKey:键值
    open func contains(_ forKey:String) ->Bool
    {
        return self.userData!.value(forKey: forKey) != nil
    }
    
    /// 设置或者增加键值
    /// - parameter value:内容
    /// - parameter key:键
    open func setObject(_ value: AnyObject?, for key: String)
    {
        self.userData?.setValue(value,forKey:key)
        self.saveUserData()
    }
    
    /// 获取键对应的内容
    /// - parameter key:键
    open func valueForKey(for key: String) -> AnyObject?
    {
        return self.userData?.value(forKey: key) as AnyObject?
    }
    
    /// 删除键值
    /// - parameter key:键
    open func removeValueForKey(for key: String)
    {
        self.userData?.removeObject(forKey: key)
        self.saveUserData()
    }
    /*-----------------------结束：公共方法*/
    
    /*-----------------------开始：声明属性*/
    
    //静态属性
    fileprivate static let keyUserData="userData"
    open static let keyEverLaunch="everLaunched"
    open static let keyFirstLaunch="firstLaunch"
    
    //调试定位信息
    fileprivate let logPre="PbDataUserController:";
    
    //用户设置信息
    fileprivate let userDefaults=UserDefaults.standard
    //用户数据
    fileprivate var userData:NSMutableDictionary?
    
    /// 用户标识
    open var userId:String?{
        didSet{
            self.userData?.setValue(self.userId, forKey: "userId")
        }
    }
    /// 用户名称
    open var userName:String?{
        didSet{
            self.userData?.setValue(self.userName, forKey: "userName")
        }
    }
    /// 用户密码
    open var userPass:String?{
        didSet{
            self.userData?.setValue(self.userPass, forKey: "userPass")
        }
    }
    /// 用户头像
    open var userHead:String?{
        didSet{
            self.userData?.setValue(self.userHead, forKey: "userHead")
        }
    }
    /// 用户文本字体
    open var userFontSize:Int?{
        didSet{
            self.userData?.setValue(self.userFontSize, forKey: "userFontSize")
        }
    }
    /// 用户文本行高
    open var userLineHeight:Float?{
        didSet{
            self.userData?.setValue(self.userLineHeight, forKey: "userLineHeight")
        }
    }
    /// 用户收藏
    open var userFavorite:NSMutableDictionary?
    
    /*-----------------------结束：声明属性*/
    
    /*-----------------------开始：对象初始化相关方法*/
    
    /// 使用配置文件初始化应用数据控制器，读取相应的URL访问及数据存储相关配置
    /// - parameter plistName:配置文件资源名称
    open func initWithPlistName(_ plistName:String)
    {
        self.reloadByPlistName(plistName)
    }
    
    /// 重新载入配置文件并重新初始化内部处理器对象
    /// - parameter plistName:配置文件资源名称
    open func reloadByPlistName(_ plistName:String)
    {
        /*载入plist配置文件*/
        self.loadPlist(plistName)
        
        /*读取配置信息*/
        self.readConfig()
    }
    
    /// 载入指定的PList文件
    /// - parameter plistName:配置文件资源名称
    fileprivate func loadPlist(_ plistName:String)
    {
        //调试信息前缀
        let logPre=self.logPre+"loadPlist:"
        
        //如果用户设置存在，直接读取用户设置
        if let data=self.userDefaults.dictionary(forKey: PbDataUserController.keyUserData)
        {
            PbLog.debug(logPre+":开始读取用户设置(UserDefaults)")
            self.userData=NSMutableDictionary(dictionary:data)
        }
        //否则读取初始文件
        else
        {
            //查找Plist对应的资源路径,载入资源
            if let path:String=Bundle.main.path(forResource: plistName,ofType:"plist")
            {
                PbLog.debug(logPre+"开始读取Plist资源（Path:"+path+"）")
                self.userData=NSMutableDictionary(contentsOfFile:path)
            }
        }
        
        PbLog.debug(logPre+"读取完成")
    }
    
    /// 读取相应的配置信息
    fileprivate func readConfig()
    {
        //调试信息前缀
        let logPre=self.logPre+"readConfig:"
        PbLog.debug(logPre+"开始读取用户数据信息")
        
        //用户标识
        let userId=self.userData?.object(forKey: "userId") as? String
        self.userId=(userId==nil || userId=="") ? "":userId
        PbLog.debug(logPre+"userId:"+self.userId!)
        //用户昵称
        let userName=self.userData?.object(forKey: "userName") as? String
        self.userName=(userName==nil || userName=="") ? "":userName
        PbLog.debug(logPre+"userName:"+self.userName!)
        //用户密钥
        let userPass=self.userData?.object(forKey: "userPass") as? String
        self.userPass=(userPass==nil || userPass=="") ? "":userPass
        PbLog.debug(logPre+"userPass:"+self.userPass!)
        //用户头像
        let userHead=self.userData?.object(forKey: "userHead") as? String
        self.userHead=(userHead==nil || userHead=="") ? "":userHead
        PbLog.debug(logPre+"userHead:"+self.userHead!)
        
        //显示字体
        let userFontSize=self.userData?.object(forKey: "userFontSize")
        self.userFontSize=(userFontSize==nil) ? 16:(userFontSize as! NSNumber).intValue
        PbLog.debug(logPre+"userFontSize:"+self.userFontSize!.description)
        //显示行距
        let userLineHeight=self.userData?.object(forKey: "userLineHeight") as? String
        self.userLineHeight=(userLineHeight==nil) ? 1.4:Float(userLineHeight!)
        PbLog.debug(logPre+"userLineHeight:"+self.userLineHeight!.description)
        
        //用户收藏
        if let favorite=self.userData?.object(forKey: "userFavorite")
        {
            self.userFavorite=NSMutableDictionary(dictionary:(favorite as! NSDictionary))
        }
        else
        {
            self.userFavorite=NSMutableDictionary()
        }
        
        //当用户设置不存在时同步数据到用户设置中
        if(self.userDefaults.dictionary(forKey: PbDataUserController.keyUserData) == nil)
        {
            self.saveUserData()
        }
        
        //处理用户是否为第一次打开应用
        if(!self.userDefaults.bool(forKey: PbDataUserController.keyEverLaunch))
        {
            self.userDefaults.set(true, forKey:PbDataUserController.keyEverLaunch)
            self.userDefaults.set(true, forKey:PbDataUserController.keyFirstLaunch)
        }
        else
        {
            self.userDefaults.set(false, forKey:PbDataUserController.keyFirstLaunch)
        }
        
        PbLog.debug(logPre+"结束配置信息读取")
    }
    
    /*-----------------------结束：对象初始化相关方法*/
}
