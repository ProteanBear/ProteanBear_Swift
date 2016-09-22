//
//  PbObjectFile.swift
//  pb.swift.basic
//  记录文件的基本属性
//  Created by Maqiang on 15/6/18.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation

open class PbObjectFile:AnyObject
{
    let name: String!
    let url: URL!
    public init(name: String, url: URL)
    {
        self.name = name
        self.url = url
    }
}
