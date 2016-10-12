//
//  ExtensionUIAlertController.swift
//  pb.swift.ui
//  扩展弹窗控制器，增加简单的弹出方法
//  Created by Maqiang on 16/9/20.
//  Copyright © 2016年 ProteanBear. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController
{
    //中间弹框-提示
    /// 生成提示式中间弹框（默认标题“系统提示”，关闭按钮为“关闭”）
    /// - parameter message:消息内容
    public class func pbAlert(_ message:String) ->UIAlertController
    {
        return UIAlertController.pbAlert("系统提示", message: message)
    }
    /// 生成提示式中间弹框（默认关闭按钮为“关闭”）
    /// - parameter title   :显示标题
    /// - parameter message :消息内容
    public class func pbAlert(_ title:String,message:String) ->UIAlertController
    {
        return UIAlertController.pbAlert(title, message: message,handler:nil)
    }
    /// 生成提示式中间弹框（默认关闭按钮为“关闭”）
    /// - parameter title   :显示标题
    /// - parameter message :消息内容
    /// - parameter handler :关闭时的执行方法
    public class func pbAlert(_ title:String,message:String,handler:((UIAlertAction) -> Void)?) ->UIAlertController
    {
        return UIAlertController.pbAlert(title, message: message,handler:handler,closeLabel:"关闭")
    }
    /// 生成提示式中间弹框
    /// - parameter title       :显示标题
    /// - parameter message     :消息内容
    /// - parameter handler     :关闭时的执行方法
    /// - parameter closeLabel  :关闭按钮显示
    public class func pbAlert(_ title:String,message:String,handler:((UIAlertAction) -> Void)?,closeLabel:String) ->UIAlertController
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: closeLabel, style: .default, handler: handler)
        alertController.addAction(okAction)
        return alertController
    }
    
    //中间弹框-确认
    /// 生成确认式中间弹框
    /// - parameter message     :消息内容
    /// - parameter confirm     :确定时的执行方法
    public class func pbConfirm(_ message:String,confirm:((UIAlertAction) -> Void)?) ->UIAlertController
    {
        return UIAlertController.pbConfirm("系统提示", message: message, confirm: confirm)
    }
    /// 生成确定式中间弹框
    /// - parameter title       :显示标题
    /// - parameter message     :消息内容
    /// - parameter confirm     :确定时的执行方法
    public class func pbConfirm(_ title:String,message:String,confirm:((UIAlertAction) -> Void)?) ->UIAlertController
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: confirm)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        return alertController
    }
    
    //底部弹框
    /// 生成底部弹框
    /// - parameter title       :显示标题
    /// - parameter actions     :按钮数组
    public class func pbSheet(_ title:String,actions:[UIAlertAction]) ->UIAlertController
    {
        return UIAlertController.pbSheet(title, cancelLabel:"取消", actions: actions)
    }
    /// 生成底部弹框
    /// - parameter title       :显示标题
    /// - parameter cancelLabel :取消按钮标题
    /// - parameter actions     :按钮数组
    public class func pbSheet(_ title:String,cancelLabel:String,actions:[UIAlertAction]) ->UIAlertController
    {
        return UIAlertController.pbSheet(title, message: nil,cancelLabel:cancelLabel, actions: actions)
    }
    /// 生成底部弹框
    /// - parameter title       :显示标题
    /// - parameter message     :显示内容
    /// - parameter cancelLabel :取消按钮标题
    /// - parameter actions     :按钮数组
    public class func pbSheet(_ title:String,message:String?,cancelLabel:String,actions:[UIAlertAction]) ->UIAlertController
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: cancelLabel, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        for action in actions
        {
            alertController.addAction(action)
        }
        
        return alertController
    }
}
