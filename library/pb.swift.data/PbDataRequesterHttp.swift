//
//  PbDataRequesterHttp.swift
//  swiftPbTest
//
//  Created by Maqiang on 15/6/18.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

open class PbDataRequesterHttp:PbDataRequester
{
    //boundary:自定义上传数据体时的分隔符
    let boundary="AaB03x"

    //isGet:请求方式（Get或Post，Get方式为true，默认为Post）
    var isGet:Bool=true
    
    //init:初始化
    public init(){}
    
    //init:初始化
    public init(isGet:Bool)
    {
        self.isGet=isGet
    }
    
    //request:发送请求,默认为非上传资源
    open func request(_ address:String,data:NSDictionary,callback:@escaping (_ data:Data?,_ response:AnyObject?,_ error:NSError?) -> Void)
    {
        self.request(address, data: data, callback: callback, isMultipart: false)
    }
    
    //request:发送请求，设置是否上传资源数据
    open func request(_ address:String,data:NSDictionary,callback:@escaping (_ data:Data?,_ response:AnyObject?,_ error:NSError?) -> Void,isMultipart:Bool)
    {
        if(isMultipart)
        {
            self.upload(address, data: data, callback: callback)
        }
        else
        {
            if(self.isGet)
            {
                self.get(address, data: data, callback: callback)
            }
            else
            {
                self.post(address, data: data, callback: callback)
            }
        }
    }
    
    //requestForResource:发送请求，获取资源数据
    open func requestForResource(_ address:String,callback:@escaping (_ data:Data?,_ response:AnyObject?,_ error:NSError?) -> Void)
    {
        //创建Session
        let session = URLSession.shared
        
        //创建请求对象
        let request = NSMutableURLRequest(url: URL(string:address)!)
        request.httpMethod = "GET"
        
        //异步请求
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            //判断是在主线程还是子线程
            if Thread.isMainThread
            {
                callback(data: data, response: response , error: error)
            }
            else
            {
                DispatchQueue.main.async
                    {
                        callback(data: data, response: response , error: error)
                }
            }
        })
        task.resume()
    }
    
    //paramsString:获取当前请求参数的字符串格式
    open func paramString(_ params:NSDictionary?)->String
    {
        if((params) == nil){return ""}
        
        var result:String=""
        let keys:NSArray=params!.allKeys as NSArray
        
        for i in 0 ..< keys.count
        {
            let key: AnyObject=keys.object(at: i) as AnyObject
            let value: AnyObject?=params?.object(forKey: key) as AnyObject?
            if(value == nil){continue}
            
            //数组型参数处理
            if(value!.isKind(of: NSArray))
            {
                let array:NSArray=value as! NSArray
                for j in 0 ..< array.count 
                {
                    result+=("&"+key.description+"="+(array.object(at: j) as AnyObject).description)
                }
            }
            //其他类型参数
            else
            {
               result+=("&"+key.description+"="+value!.description)
            }
        }
        
        return result;
    }
    
    //get:创建GET方式请求
    fileprivate func get(_ address:String,data:NSDictionary,callback:@escaping (_ data:Data?,_ response:AnyObject?,_ error:NSError?) -> Void)
    {
        //创建Session
        let session = URLSession.shared
        
        //重设GET传参的URL
        let url=address+"?"+self.paramString(data)
        
        //创建请求对象
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        //异步请求
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            //判断是在主线程还是子线程
            if Thread.isMainThread
            {
                callback(data: data, response: response , error: error)
            }
            else
            {
                DispatchQueue.main.async
                    {
                        callback(data: data, response: response , error: error)
                }
            }
        })
        task.resume()
    }
    
    //post:创建POST方式请求
    fileprivate func post(_ address:String,data:NSDictionary,callback:@escaping (_ data:Data?,_ response:AnyObject?,_ error:NSError?) -> Void)
    {
        //创建Session
        let session = URLSession.shared
        
        //创建请求对象
        let request = NSMutableURLRequest(url: URL(string: address)!)
        request.httpMethod = "POST"
        
        //设置POST请求的内容体
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = self.paramString(data).data(using: String.Encoding.utf8)
        
        //异步请求
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            //判断是在主线程还是子线程
            if Thread.isMainThread
            {
                callback(data: data, response: response , error: error)
            }
            else
            {
                DispatchQueue.main.async
                    {
                        callback(data: data, response: response , error: error)
                }
            }
        })
        task.resume()
    }
    
    //upload:创建POST方式请求，上传文件内容
    // HTTP 头 开始 Content-Type: multipart/form-data; boundary=PitayaUGl0YXlh 
    // HTTP 头 结束 
    /* HTTP Body 开始
     格式示例：
     Content-type: multipart/form-data, boundary=AaB03x
     
     --AaB03x
     
     content-disposition: form-data; name="field1"
     
     Hello Boris!
     
     --AaB03x
     
     content-disposition: form-data; name="pic"; filename="boris.png"
     
     Content-Type: image/png
     
     ... contents of boris.png ...
     
     --AaB03x--
    // HTTP Body 结束*/
    fileprivate func upload(_ address:String,data:NSDictionary,callback:@escaping (_ data:Data?,_ response:AnyObject?,_ error:NSError?) -> Void)
    {
        //创建Session
        let session = URLSession.shared
        
        //创建请求对象
        let request = NSMutableURLRequest(url: URL(string: address)!)
        request.httpMethod = "POST"
        
        //设置POST请求的格式
        request.addValue("multipart/form-data; boundary=" + self.boundary, forHTTPHeaderField: "Content-Type")
        //设置传输的内容体
        let bodyData = NSMutableData()
        let keys:NSArray=data.allKeys as NSArray
        let dictionary = NSMutableDictionary()
        //增加普通参数
        for i in 0 ..< keys.count
        {
            let key: AnyObject=keys.object(at: i) as AnyObject
            let value: AnyObject?=data.object(forKey: key) as AnyObject?
            if(value == nil){continue}
            
            //图片类型数据
            if(value!.isKind(of: UIImage))
            {
                let image:UIImage=value as! UIImage
                dictionary.setObject(image, forKey: key.description as NSCopying)
            }
            //文件类型数据
            else if(value!.isKind(of: PbObjectFile))
            {
                let file:PbObjectFile=value as! PbObjectFile
                dictionary.setObject(file, forKey: key.description as NSCopying)
            }
            //普通参数
            else
            {
                bodyData.append("--\(self.boundary)\r\n".data(using: String.Encoding.utf8)!)
                bodyData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                PbLog.debug("test:"+value!.description)
                bodyData.append("\(value!.description)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        //增加数据参数
        for key in dictionary.keyEnumerator()
        {
            let value=dictionary.object(forKey: key)
            
            //图片类型数据
            if((value! as AnyObject).isKind(of: UIImage))
            {
                let image:UIImage=value as! UIImage
                bodyData.append("--\(self.boundary)\r\n".data(using: String.Encoding.utf8)!)
                bodyData.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key)\".png\r\n\r\n".data(using: String.Encoding.utf8)!)
                bodyData.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
                bodyData.append(UIImagePNGRepresentation(image)!)
                bodyData.append("\r\n".data(using: String.Encoding.utf8)!)
            }
            //文件类型数据
            else if((value! as AnyObject).isKind(of: PbObjectFile))
            {
                let file:PbObjectFile=value as! PbObjectFile
                bodyData.append("--\(self.boundary)\r\n".data(using: String.Encoding.utf8)!)
                bodyData.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(NSString(string:file.url.description).lastPathComponent)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                if let a = try? Data(contentsOf: file.url as URL)
                {
                    bodyData.append(a)
                    bodyData.append("\r\n".data(using: String.Encoding.utf8)!)
                }
            }
        }
        bodyData.append("--\(self.boundary)--".data(using: String.Encoding.utf8)!)
        request.addValue(bodyData.length.description, forHTTPHeaderField: "Content-Length")
        request.httpBody = bodyData as Data
        
        //异步请求
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            //判断是在主线程还是子线程
            if Thread.isMainThread
            {
                callback(data: data, response: response , error: error)
            }
            else
            {
                DispatchQueue.main.async
                    {
                        callback(data: data, response: response , error: error)
                }
            }
            
        })
        task.resume()
    }
}
