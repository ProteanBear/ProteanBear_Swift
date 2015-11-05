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
    //pbSetLeftPadding:设置左侧边距
    public func pbSetLeftPadding(width:CGFloat)
    {
        var rect=self.frame
        rect.size.width = width
        self.leftViewMode = .Always
        self.leftView=UIView(frame:rect)
    }
    
    //pbSetRightPadding:设置右侧边距
    public func pbSetRightPadding(width:CGFloat)
    {
        var rect=self.frame
        rect.size.width = width
        self.rightViewMode = .Always
        self.rightView=UIView(frame:rect)
    }
}