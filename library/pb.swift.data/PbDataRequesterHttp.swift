//
//  PbDataRequesterHttp.swift
//  swiftPbTest
//
//  Created by Maqiang on 15/6/18.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

class PbDataRequesterHttp:PbDataRequester
{
    //boundary:自定义上传数据体时的分隔符
    let boundary="AaB03x"

    //isGet:请求方式（Get或Post，Get方式为true，默认为Post）
    var isGet:Bool=true
    
    //init:初始化
    init(){}
    
    //init:初始化
    init(isGet:Bool)
    {
        self.isGet=isGet
    }
    
    //request:发送请求,默认为非上传资源
    internal func request(address:String,data:NSDictionary,callback:(data:NSData!,response:AnyObject!,error:NSError!) -> Void)
    {
        self.request(address, data: data, callback: callback, isMultipart: false)
    }
    
    //request:发送请求，设置是否上传资源数据
    internal func request(address:String,data:NSDictionary,callback:(data:NSData!,response:AnyObject!,error:NSError!) -> Void,isMultipart:Bool)
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
    internal func requestForResource(address:String,callback:(data:NSData!,response:AnyObject!,error:NSError!) -> Void)
    {
        //创建Session
        let session = NSURLSession.sharedSession()
        
        //创建请求对象
        let request = NSMutableURLRequest(URL: NSURL(string:address)!)
        request.HTTPMethod = "GET"
        
        //异步请求
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            //判断是在主线程还是子线程
            if NSThread.isMainThread()
            {
                callback(data: data, response: response , error: error)
            }
            else
            {
                dispatch_async(dispatch_get_main_queue())
                    {
                        callback(data: data, response: response , error: error)
                }
            }
        })
        task.resume()
    }
    
    //paramsString:获取当前请求参数的字符串格式
    internal func paramString(params:NSDictionary?)->String
    {
        if((params) == nil){return ""}
        
        var result:String=""
        let keys:NSArray=params!.allKeys
        
        for(var i=0;i<keys.count;i++)
        {
            let key: AnyObject=keys.objectAtIndex(i)
            let value: AnyObject?=params?.objectForKey(key)
            if(value == nil){continue}
            
            //数组型参数处理
            if(value!.isKindOfClass(NSArray))
            {
                let array:NSArray=value as! NSArray
                for(var j=0;j<array.count;j++)
                {
                    result+=("&"+key.description+"="+array.objectAtIndex(j).description)
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
    private func get(address:String,data:NSDictionary,callback:(data:NSData!,response:AnyObject!,error:NSError!) -> Void)
    {
        //创建Session
        let session = NSURLSession.sharedSession()
        
        //重设GET传参的URL
        let url=address+"?"+self.paramString(data)
        
        //创建请求对象
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        
        //异步请求
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            //判断是在主线程还是子线程
            if NSThread.isMainThread()
            {
                callback(data: data, response: response , error: error)
            }
            else
            {
                dispatch_async(dispatch_get_main_queue())
                    {
                        callback(data: data, response: response , error: error)
                }
            }
        })
        task.resume()
    }
    
    //post:创建POST方式请求
    private func post(address:String,data:NSDictionary,callback:(data:NSData!,response:AnyObject!,error:NSError!) -> Void)
    {
        //创建Session
        let session = NSURLSession.sharedSession()
        
        //创建请求对象
        let request = NSMutableURLRequest(URL: NSURL(string: address)!)
        request.HTTPMethod = "POST"
        
        //设置POST请求的内容体
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = self.paramString(data).dataUsingEncoding(NSUTF8StringEncoding)
        
        //异步请求
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            //判断是在主线程还是子线程
            if NSThread.isMainThread()
            {
                callback(data: data, response: response , error: error)
            }
            else
            {
                dispatch_async(dispatch_get_main_queue())
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
        --PitayaUGl0YXlh Content-Disposition: form-data; name="field1" John Lui 
    
        --PitayaUGl0YXlh Content-Disposition: form-data; name="text"; filename="file1.txt" ···[file1.txt 的数据]··· 
    
        --PitayaUGl0YXlh--
    // HTTP Body 结束*/
    private func upload(address:String,data:NSDictionary,callback:(data:NSData!,response:AnyObject!,error:NSError!) -> Void)
    {
        //创建Session
        let session = NSURLSession.sharedSession()
        
        //创建请求对象
        let request = NSMutableURLRequest(URL: NSURL(string: address)!)
        request.HTTPMethod = "POST"
        
        //设置POST请求的格式
        request.addValue("multipart/form-data; boundary=" + self.boundary, forHTTPHeaderField: "Content-Type")
        //设置传输的内容体
        let bodyData = NSMutableData()
        let keys:NSArray=data.allKeys
        
        for(var i=0;i<keys.count;i++)
        {
            let key: AnyObject=keys.objectAtIndex(i)
            let value: AnyObject?=data.objectForKey(key)
            if(value == nil){continue}
            
            //图片类型数据
            if(value!.isKindOfClass(UIImage))
            {
                let image:UIImage=value as! UIImage
                bodyData.appendData("--\(self.boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                bodyData.appendData("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key)\".png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                bodyData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                bodyData.appendData(UIImagePNGRepresentation(image)!)
                bodyData.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            }
            //文件类型数据
            else if(value!.isKindOfClass(PbObjectFile))
            {
                let file:PbObjectFile=value as! PbObjectFile
                bodyData.appendData("--\(self.boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                bodyData.appendData("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(NSString(string:file.url.description).lastPathComponent)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                if let a = NSData(contentsOfURL: file.url)
                {
                    bodyData.appendData(a)
                    bodyData.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                }
            }
            //普通参数
            else
            {
                bodyData.appendData("--\(self.boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                bodyData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                bodyData.appendData("\(value)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            }
        }
        request.HTTPBody = bodyData
        
        //异步请求
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            
            //判断是在主线程还是子线程
            if NSThread.isMainThread()
            {
                callback(data: data, response: response , error: error)
            }
            else
            {
                dispatch_async(dispatch_get_main_queue())
                    {
                        callback(data: data, response: response , error: error)
                }
            }
            
        })
        task.resume()
    }
}