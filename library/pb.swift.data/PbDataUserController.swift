
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
    
    /*-----------------------开始：公共方法*/
    /*isFirstLaunch:
     *  返回用户是否第一次打开应用
     */
    public func isFirstLaunch() -> Bool
    {
        return self.userDefaults.boolForKey(PbDataUserController.keyFirstLaunch)
    }
    
    /*saveUserData
     *  保存用户信息
     */
    public func saveUserData()
    {
        self.userData?.setValue(self.userFavorite,forKey:"userFavorite")
        self.userDefaults.setObject(self.userData, forKey: PbDataUserController.keyUserData)
        self.userDefaults.synchronize()
    }
    
    /*isFavorite:
     *  是否已经收藏
     */
    public func isFavorite(id:String) ->Bool
    {
        return self.userFavorite?.valueForKey(id) != nil
    }
    
    /*addFavorite:
     *  增加收藏
     */
    public func addFavorite(data:AnyObject,id:String)
    {
        self.userFavorite?.setObject(data, forKey: id)
        self.saveUserData()
    }
    
    /*removeFavorite:
     *  移除收藏
     */
    public func removeFavorite(id:String)
    {
        self.userFavorite?.removeObjectForKey(id)
        self.saveUserData()
    }
    public func removeFavoritesWithArray(idArray:NSArray)
    {
        self.userFavorite?.removeObjectsForKeys(idArray as [AnyObject])
        self.saveUserData()
    }
    public func removeFavorites(ids:[String])
    {
        self.userFavorite?.removeObjectsForKeys(ids)
        self.saveUserData()
    }
    
    /*contains:
     *  检查键是否存在
     */
    public func contains(forKey:String) ->Bool
    {
        return self.userData!.valueForKey(forKey) != nil
    }
    
    /*setValue:
     *  设置或者增加键值
     */
    public func setObject(value: AnyObject?, forKey key: String)
    {
        self.userData?.setValue(value,forKey:key)
        self.saveUserData()
    }
    
    /*valueForKey:
     *  设置或者增加键值
     */
    public func valueForKey(forKey key: String) -> AnyObject?
    {
        return self.userData?.valueForKey(key)
    }
    
    /*removeValueForKey:
     *  删除键值
     */
    public func removeValueForKey(forKey key: String)
    {
        self.userData?.removeObjectForKey(key)
        self.saveUserData()
    }
    /*-----------------------结束：公共方法*/
    
    /*-----------------------开始：声明属性*/
    
    //静态属性
    private static let keyUserData="userData"
    public static let keyEverLaunch="everLaunched"
    public static let keyFirstLaunch="firstLaunch"
    
    //调试定位信息
    private let logPre="PbDataUserController:";
    
    //用户设置信息
    private let userDefaults=NSUserDefaults.standardUserDefaults()
    //用户数据
    private var userData:NSMutableDictionary?
    public var userId:String?{
        didSet{
            self.userData?.setValue(self.userId, forKey: "userId")
        }
    }
    public var userName:String?{
        didSet{
            self.userData?.setValue(self.userName, forKey: "userName")
        }
    }
    public var userPass:String?{
        didSet{
            self.userData?.setValue(self.userPass, forKey: "userPass")
        }
    }
    public var userFontSize:Int?{
        didSet{
            self.userData?.setValue(self.userFontSize, forKey: "userFontSize")
        }
    }
    public var userLineHeight:Float?{
        didSet{
            self.userData?.setValue(self.userLineHeight, forKey: "userLineHeight")
        }
    }
    public var userFavorite:NSMutableDictionary?
    
    /*-----------------------结束：声明属性*/
    
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
        if let data=self.userDefaults.dictionaryForKey(PbDataUserController.keyUserData)
        {
            PbLog.debug(logPre+":开始读取用户设置(UserDefaults)")
            self.userData=NSMutableDictionary(dictionary:data)
        }
        //否则读取初始文件
        else
        {
            //查找Plist对应的资源路径,载入资源
            if let path:String?=NSBundle.mainBundle().pathForResource(plistName,ofType:"plist")
            {
                PbLog.debug(logPre+"开始读取Plist资源（Path:"+path!+"）")
                self.userData=NSMutableDictionary(contentsOfFile:path!)
            }
        }
        
        PbLog.debug(logPre+"读取完成")
    }
    
    /*readConfig:
    *  读取相应的配置信息
    */
    private func readConfig()
    {
        //调试信息前缀
        let logPre=self.logPre+"readConfig:"
        PbLog.debug(logPre+"开始读取用户数据信息")
        
        //用户标识
        let userId=self.userData?.objectForKey("userId")?.description
        self.userId=(userId==nil || userId=="") ? "":userId
        PbLog.debug(logPre+"userId:"+self.userId!)
        //用户昵称
        let userName=self.userData?.objectForKey("userName")?.description
        self.userName=(userName==nil || userName=="") ? "":userName
        PbLog.debug(logPre+"userName:"+self.userName!)
        //用户密钥
        let userPass=self.userData?.objectForKey("userPass")?.description
        self.userPass=(userPass==nil || userPass=="") ? "":userPass
        PbLog.debug(logPre+"userPass:"+self.userPass!)
        
        //显示字体
        let userFontSize=self.userData?.objectForKey("userFontSize")?.integerValue
        self.userFontSize=(userFontSize==nil) ? 16:userFontSize
        PbLog.debug(logPre+"userFontSize:"+self.userFontSize!.description)
        //显示行距
        let userLineHeight=self.userData?.objectForKey("userLineHeight")?.floatValue
        self.userLineHeight=(userLineHeight==nil) ? 1.4:userLineHeight
        PbLog.debug(logPre+"userLineHeight:"+self.userLineHeight!.description)
        
        //用户收藏
        if let favorite=self.userData?.objectForKey("userFavorite")
        {
            self.userFavorite=NSMutableDictionary(dictionary:(favorite as! NSDictionary))
        }
        else
        {
            self.userFavorite=NSMutableDictionary()
        }
        
        //当用户设置不存在时同步数据到用户设置中
        if(self.userDefaults.dictionaryForKey(PbDataUserController.keyUserData) == nil)
        {
            self.saveUserData()
        }
        
        //处理用户是否为第一次打开应用
        if(!self.userDefaults.boolForKey(PbDataUserController.keyEverLaunch))
        {
            self.userDefaults.setBool(true, forKey:PbDataUserController.keyEverLaunch)
            self.userDefaults.setBool(true, forKey:PbDataUserController.keyFirstLaunch)
        }
        else
        {
            self.userDefaults.setBool(false, forKey:PbDataUserController.keyFirstLaunch)
        }
        
        PbLog.debug(logPre+"结束配置信息读取")
    }
    
    /*-----------------------结束：对象初始化相关方法*/
}