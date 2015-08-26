//
//  ExtensionString.swift
//  pb.swift.basic
//  扩展String对象
//  Created by Maqiang on 15/6/17.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation

extension String
{
    //增加字符串的MD5编码
    func md5() ->String!
    {
//        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
//        let strLen = CUnsignedInt(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
//        CC_MD5(str!, strLen, result)
//        var hash = NSMutableString()
//        for i in 0 ..< digestLen
//        {
//            hash.appendFormat("%02x", result[i])
//        }
//        result.destroy()
//        return String(format: hash as String)
        return ""
    }
}