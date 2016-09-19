
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
    
    open class var getInstance:PbDataUserController
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
    open func isFirstLaunch() -> Bool
    {
        return self.userDefaults.bool(forKey: PbDataUserController.keyFirstLaunch)
    }
    
    /*saveUserData
     *  保存用户信息
     */
    open func saveUserData()
    {
        self.userData?.setValue(self.userFavorite,forKey:"userFavorite")
        self.userDefaults.set(self.userData, forKey: PbDataUserController.keyUserData)
        self.userDefaults.synchronize()
    }
    
    /*isFavorite:
     *  是否已经收藏
     */
    open func isFavorite(_ id:String) ->Bool
    {
        return self.userFavorite?.value(forKey: id) != nil
    }
    
    /*addFavorite:
     *  增加收藏
     */
    open func addFavorite(_ data:AnyObject,id:String)
    {
        self.userFavorite?.setObject(data, forKey: id as NSCopying)
        self.saveUserData()
    }
    
    /*removeFavorite:
     *  移除收藏
     */
    open func removeFavorite(_ id:String)
    {
        self.userFavorite?.removeObject(forKey: id)
        self.saveUserData()
    }
    open func removeFavoritesWithArray(_ idArray:NSArray)
    {
        self.userFavorite?.removeObjects(forKeys: idArray as [AnyObject])
        self.saveUserData()
    }
    open func removeFavorites(_ ids:[String])
    {
        self.userFavorite?.removeObjects(forKeys: ids)
        self.saveUserData()
    }
    
    /*contains:
     *  检查键是否存在
     */
    open func contains(_ forKey:String) ->Bool
    {
        return self.userData!.value(forKey: forKey) != nil
    }
    
    /*setValue:
     *  设置或者增加键值
     */
    open func setObject(_ value: AnyObject?, forKey key: String)
    {
        self.userData?.setValue(value,forKey:key)
        self.saveUserData()
    }
    
    /*valueForKey:
     *  设置或者增加键值
     */
    open func valueForKey(forKey key: String) -> AnyObject?
    {
        return self.userData?.value(forKey: key) as AnyObject?
    }
    
    /*removeValueForKey:
     *  删除键值
     */
    open func removeValueForKey(forKey key: String)
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
    open var userId:String?{
        didSet{
            self.userData?.setValue(self.userId, forKey: "userId")
        }
    }
    open var userName:String?{
        didSet{
            self.userData?.setValue(self.userName, forKey: "userName")
        }
    }
    open var userPass:String?{
        didSet{
            self.userData?.setValue(self.userPass, forKey: "userPass")
        }
    }
    open var userHead:String?{
        didSet{
            self.userData?.setValue(self.userHead, forKey: "userHead")
        }
    }
    open var userFontSize:Int?{
        didSet{
            self.userData?.setValue(self.userFontSize, forKey: "userFontSize")
        }
    }
    open var userLineHeight:Float?{
        didSet{
            self.userData?.setValue(self.userLineHeight, forKey: "userLineHeight")
        }
    }
    open var userFavorite:NSMutableDictionary?
    
    /*-----------------------结束：声明属性*/
    
    /*-----------------------开始：对象初始化相关方法*/
    
    /*initWithPlistName:
     *  使用配置文件初始化应用数据控制器，读取相应的URL访问及数据存储相关配置
     */
    open func initWithPlistName(_ plistName:String)
    {
        self.reloadByPlistName(plistName)
    }
    
    /*reloadByPlistName:
     *  重新载入配置文件并重新初始化内部处理器对象
     */
    open func reloadByPlistName(_ plistName:String)
    {
        /*载入plist配置文件*/
        self.loadPlist(plistName)
        
        /*读取配置信息*/
        self.readConfig()
    }
    
    /*loadPlist:
     *  载入指定的PList文件
     */
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
    
    /*readConfig:
    *  读取相应的配置信息
    */
    fileprivate func readConfig()
    {
        //调试信息前缀
        let logPre=self.logPre+"readConfig:"
        PbLog.debug(logPre+"开始读取用户数据信息")
        
        //用户标识
        let userId=(self.userData?.object(forKey: "userId") as AnyObject).description
        self.userId=(userId==nil || userId=="") ? "":userId
        PbLog.debug(logPre+"userId:"+self.userId!)
        //用户昵称
        let userName=(self.userData?.object(forKey: "userName") as AnyObject).description
        self.userName=(userName==nil || userName=="") ? "":userName
        PbLog.debug(logPre+"userName:"+self.userName!)
        //用户密钥
        let userPass=(self.userData?.object(forKey: "userPass") as AnyObject).description
        self.userPass=(userPass==nil || userPass=="") ? "":userPass
        PbLog.debug(logPre+"userPass:"+self.userPass!)
        //用户头像
        let userHead=(self.userData?.object(forKey: "userHead") as AnyObject).description
        self.userHead=(userHead==nil || userHead=="") ? "":userHead
        PbLog.debug(logPre+"userHead:"+self.userHead!)
        
        //显示字体
        let userFontSize=self.userData?.object(forKey: "userFontSize")
        self.userFontSize=(userFontSize==nil) ? 16:Int(userFontSize.debugDescription)
        PbLog.debug(logPre+"userFontSize:"+self.userFontSize!.description)
        //显示行距
        let userLineHeight=(self.userData?.object(forKey: "userLineHeight") as AnyObject).floatValue
        self.userLineHeight=(userLineHeight==nil) ? 1.4:userLineHeight
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
