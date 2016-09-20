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
    public class func pbAlert(_ message:String) ->UIAlertController
    {
        return UIAlertController.pbAlert("系统提示", message: message)
    }
    public class func pbAlert(_ title:String,message:String) ->UIAlertController
    {
        return UIAlertController.pbAlert(title, message: message,handler:nil)
    }
    public class func pbAlert(_ title:String,message:String,handler:((UIAlertAction) -> Void)?) ->UIAlertController
    {
        return UIAlertController.pbAlert(title, message: message,handler:handler,closeLabel:"关闭")
    }
    public class func pbAlert(_ title:String,message:String,handler:((UIAlertAction) -> Void)?,closeLabel:String) ->UIAlertController
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: closeLabel, style: .default, handler: handler)
        alertController.addAction(okAction)
        return alertController
    }
    
    //中间弹框-确认
    public class func pbConfirm(_ message:String,confirm:((UIAlertAction) -> Void)?) ->UIAlertController
    {
        return UIAlertController.pbConfirm("系统提示", message: message, confirm: confirm)
    }
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
    public class func pbSheet(_ title:String,actions:[UIAlertAction]) ->UIAlertController
    {
        return UIAlertController.pbSheet(title, cancelLabel:"取消", actions: actions)
    }
    public class func pbSheet(_ title:String,cancelLabel:String,actions:[UIAlertAction]) ->UIAlertController
    {
        return UIAlertController.pbSheet(title, message: "",cancelLabel:cancelLabel, actions: actions)
    }
    public class func pbSheet(_ title:String,message:String,cancelLabel:String,actions:[UIAlertAction]) ->UIAlertController
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelLabel, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        for action in actions
        {
            alertController.addAction(action)
        }
        
        return alertController
    }
}
