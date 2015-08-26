//
//  ExtensionUIViewController.swift
//  pb.swift.ui
//  扩展视图控制器，增加数据绑定载入处理方法
//  Created by Maqiang on 15/6/29.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    //pbLoadData:获取数据
    func pbLoadData(updateMode:PbDataUpdateMode,controller:PbUIViewControllerProtocol?)
    {
        PbDataAdapter(delegate:controller).loadData(updateMode)
    }
}