//
//  AppDelegate.swift
//  swiftPbTest
//
//  Created by Maqiang on 15/6/15.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?

    /*application:didFinishLaunchingWithOptions:
     *  启动画面结束后调用
     */
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        /*初始化数据应用控制器单实例对象*/
        PbDataAppController.getInstance.initWithPlistName("DataConfig",initLocationManager:PbDataLocationMode.InUse)
        //PbDataAppController.getInstance.clearCacheDataInLocal()
        
        /*注册消息推送*/
//        if(PbDataAppController.getInstance.isNetworkConnected())
//        {
//            if(PbSystem.osUp8())
//            {
//                application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes:UIUserNotificationType.Alert|UIUserNotificationType.Badge|UIUserNotificationType.Sound, categories: nil))
//            }
//            else
//            {
//                application.registerForRemoteNotificationTypes(UIRemoteNotificationType.Alert|UIRemoteNotificationType.Badge|UIRemoteNotificationType.Sound)
//            }
//        }
//        else
//        {
//        }
        //*/
        
        return true
    }

    /*applicationWillResignActive:
     *  应用将释放活动状态时调用
     */
    func applicationWillResignActive(application: UIApplication)
    {
    }

    /*applicationDidEnterBackground:
     *  应用进入后台运行时调用
     */
    func applicationDidEnterBackground(application: UIApplication)
    {
    }

    /*applicationWillEnterForeground:
     *  应用进入前台运行时调用
     */
    func applicationWillEnterForeground(application: UIApplication)
    {
    }

    /*applicationDidBecomeActive:
     *  应用进入前台激活状态时调用
     */
    func applicationDidBecomeActive(application: UIApplication)
    {
    }

    /*applicationWillTerminate:
     *  应用将要退出时调用
     */
    func applicationWillTerminate(application: UIApplication)
    {
    }
    
    //---------------------开始:消息推送相关处理*/
    
    /*application:didRegisterForRemoteNotificationsWithDeviceToken:
     *  注册推送成功时调用
     */
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        //解析Token
        var token=deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString:"<>"))
        token=token.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.allZeros, range: nil)
        PbLog.debug("application:didRegisterForRemoteNotificationsWithDeviceToken:得到Token:"+token)
        
        //用户登录
        PbDataAppController.getInstance.requestWithKey("userLogin", params: NSDictionary(objects:["moru_test_1@test.com",NSString(string:"123456".md5()).substringFromIndex(16)],forKeys:["account","pwd"]), callback: { (data, error, property) -> Void in
            
                if(data != nil)
                {
                    var status:Int?=data.objectForKey("status") as? Int
                    if(status != nil)
                    {
                        if(status==0)
                        {
                            //发送推送设置到服务器
                            PbDataAppController.getInstance.requestWithKey("updateToken", params: NSDictionary(objects:[token],forKeys:["apnToken"]), callback: { (data, error, property) -> Void in
                                
                                
                                
                                }, getMode: PbDataGetMode.FromNet)
                        }
                    }
                }
            
            }, getMode: PbDataGetMode.FromNet)
    }
    
    /*application:didFailToRegisterForRemoteNotificationsWithError:
     *  注册推送失败时调用
     */
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    {
        PbLog.error("application:didFailToRegisterForRemoteNotificationsWithError:注册推送失败:"+error.description)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings)
    {
        application.registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        PbLog.debug(userInfo.description)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
    {
        PbLog.debug(userInfo.description)
    }
    
    //---------------------结束:消息推送相关处理*/
}

