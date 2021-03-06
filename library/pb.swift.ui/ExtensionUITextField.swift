//
//  ExtensionUITextField.swift
//  PbSwiftDemo
//
//  Created by Maqiang on 15/9/22.
//  Copyright © 2015年 ProteanBear. All rights reserved.
//

import Foundation
import UIKit

extension UITextField
{
    /// 设置左侧边距
    /// - parameter width:边距宽度
    public func pbSetLeftPadding(_ width:CGFloat)
    {
        var rect=self.frame
        rect.size.width = width
        self.leftViewMode = .always
        self.leftView=UIView(frame:rect)
    }
    
    /// 设置右侧边距
    /// - parameter width:边距宽度
    public func pbSetRightPadding(_ width:CGFloat)
    {
        var rect=self.frame
        rect.size.width = width
        self.rightViewMode = .always
        self.rightView=UIView(frame:rect)
    }
}
