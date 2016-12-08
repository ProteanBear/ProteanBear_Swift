//
//  PbDataRequesterHttp.swift
//  swiftPbTest
//
//  Created by Maqiang on 15/6/18.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

open class PbDataRequesterHttp:NSObject,PbDataRequester,URLSessionDelegate
{
    ///自定义上传数据体时的分隔符
    let boundary="AaB03x"

    ///请求方式（Get或Post，Get方式为true，默认为Post）
    var isGet:Bool=true
    
    ///https协议下使用的服务端证书
    var certNameOfServer=""
    ///https协议下使用的客户端证书
    var certNameOfClient=""
    ///https协议下使用的客户端证书访问密码
    var certPassOfClient=""
    
    ///init:初始化
    public override init(){}
    
    ///init:初始化
    /// - parameter isGet:是否Get方式发送请求
    public init(isGet:Bool)
    {
        self.isGet=isGet
    }
    
    ///init:初始化
    /// - parameter isGet:              是否Get方式发送请求
    /// - parameter certNameOfServer:   https双向认证中服务端证书的名称（不包含.cer）
    /// - parameter certNameOfClient:   https双向认证中客户端证书的名称（不包含.p12）
    public init(isGet:Bool,certNameOfServer:String,certNameOfClient:String,certPassOfClient:String)
    {
        self.isGet=isGet
        self.certNameOfServer=certNameOfServer
        self.certNameOfClient=certNameOfClient
        self.certPassOfClient=certPassOfClient
    }
    
    /// 发送请求，并返回数据
    /// - parameter address :请求地址
    /// - parameter data :请求数据
    /// - parameter callback :请求后的返回处理
    open func request(_ address:String,data:NSDictionary,callback:@escaping (_ data:Data?,_ response:AnyObject?,_ error:NSError?) -> Void)
    {
        self.request(address, data: data, callback: callback, isMultipart: false)
    }
    
    /// 发送请求上传资源数据，并返回数据
    /// - parameter address :请求地址
    /// - parameter data :请求数据
    /// - parameter callback :请求后的返回处理
    /// - parameter isMultipart:是否为数据上传模式
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
    
    /// 发送请求，获取资源数据
    /// - parameter address :请求地址
    /// - parameter callback :请求后的返回处理
    open func requestForResource(_ address:String,callback:@escaping (_ data:Data?,_ response:AnyObject?,_ error:NSError?) -> Void)
    {
        //创建Session
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        
        //创建请求对象
        var request = URLRequest(url: URL(string:address)!)
        request.httpMethod = "GET"
        
        //异步请求
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            //判断是在主线程还是子线程
            if Thread.isMainThread
            {
                callback(data, response , error as NSError?)
            }
            else
            {
                DispatchQueue.main.async
                    {
                        callback(data, response , error as NSError?)
                }
            }
        })
        task.resume()
    }
    
    /// 获取当前请求参数的字符串格式
    /// - parameter params :请求参数
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
            if(value!.isKind(of: NSArray.self))
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
    
    /// get:创建GET方式请求
    /// - parameter address :请求地址
    /// - parameter data :请求数据
    /// - parameter callback :请求后的返回处理
    fileprivate func get(_ address:String,data:NSDictionary,callback:@escaping (_ data:Data?,_ response:AnyObject?,_ error:NSError?) -> Void)
    {
        //创建Session
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        
        //重设GET传参的URL
        let url=address+"?"+self.paramString(data)
        
        //创建请求对象
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        //异步请求
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            //判断是在主线程还是子线程
            if Thread.isMainThread
            {
                callback(data, response , error as NSError?)
            }
            else
            {
                DispatchQueue.main.async
                    {
                        callback(data, response , error as NSError?)
                }
            }
        })
        task.resume()
    }
    
    /// post:创建POST方式请求
    /// - parameter address :请求地址
    /// - parameter data :请求数据
    /// - parameter callback :请求后的返回处理
    fileprivate func post(_ address:String,data:NSDictionary,callback:@escaping (_ data:Data?,_ response:AnyObject?,_ error:NSError?) -> Void)
    {
        //创建Session
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        
        //创建请求对象
        var request = URLRequest(url: URL(string: address)!)
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
                callback(data, response , error as NSError?)
            }
            else
            {
                DispatchQueue.main.async
                    {
                        callback(data, response , error as NSError?)
                }
            }
        })
        task.resume()
    }
    
    ///upload:创建POST方式请求，上传文件内容
    /// - parameter address :请求地址
    /// - parameter data :请求数据
    /// - parameter callback :请求后的返回处理
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
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        
        //创建请求对象
        var request = URLRequest(url: URL(string: address)!)
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
            if(value!.isKind(of: UIImage.self))
            {
                let image:UIImage=value as! UIImage
                dictionary.setObject(image, forKey: key.description as NSCopying)
            }
            //文件类型数据
            else if(value!.isKind(of: PbObjectFile.self))
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
            if((value! as AnyObject).isKind(of: UIImage.self))
            {
                let image:UIImage=value as! UIImage
                bodyData.append("--\(self.boundary)\r\n".data(using: String.Encoding.utf8)!)
                bodyData.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key)\".png\r\n\r\n".data(using: String.Encoding.utf8)!)
                bodyData.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
                bodyData.append(UIImagePNGRepresentation(image)!)
                bodyData.append("\r\n".data(using: String.Encoding.utf8)!)
            }
            //文件类型数据
            else if((value! as AnyObject).isKind(of: PbObjectFile.self))
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
                callback(data, response , error as NSError?)
            }
            else
            {
                DispatchQueue.main.async
                    {
                        callback(data, response , error as NSError?)
                }
            }
            
        })
        task.resume()
    }
    
    /// 处理https协议的证书
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        //认证服务端证书
        if(challenge.protectionSpace.authenticationMethod==NSURLAuthenticationMethodServerTrust)
        {
            let serverTrust:SecTrust = challenge.protectionSpace.serverTrust!
            let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)!
            let remoteCertificateData
                = CFBridgingRetain(SecCertificateCopyData(certificate))!
            let cerPath = Bundle.main.path(forResource: certNameOfServer,ofType: "cer")!
            let localCertificateData = NSData(contentsOfFile:cerPath)!
            
            if (remoteCertificateData.isEqual(localCertificateData as Data) == true) {
                let credential = URLCredential(trust: serverTrust)
                challenge.sender?.use(credential,for: challenge)
                completionHandler(.useCredential,URLCredential(trust: challenge.protectionSpace.serverTrust!))
                
            }
            else
            {
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        }
        //认证客户端证书
        else if(challenge.protectionSpace.authenticationMethod==NSURLAuthenticationMethodClientCertificate)
        {
            var securityError:OSStatus = errSecSuccess
            
            let path: String = Bundle.main.path(forResource: certNameOfClient, ofType: "p12")!
            let PKCS12Data = NSData(contentsOfFile:path)!
            let key : NSString = kSecImportExportPassphrase as NSString
            let options : NSDictionary = [key : certPassOfClient]
            
            var items : CFArray?
            securityError = SecPKCS12Import(PKCS12Data, options, &items)
            
            if securityError == errSecSuccess {
                let certItems:CFArray = items as CFArray!
                let certItemsArray:Array = certItems as Array
                let dict:AnyObject? = certItemsArray.first
                let secIdentityRef:SecIdentity
                let chainPointer:AnyObject?
                
                if let certEntry:Dictionary = dict as? Dictionary<String, AnyObject>
                {
                    let identityPointer:AnyObject? = certEntry["identity"]
                    secIdentityRef = identityPointer as! SecIdentity!
                    chainPointer = certEntry["chain"]
                    let urlCredential = URLCredential(
                        identity: secIdentityRef,
                        certificates: chainPointer as? [AnyObject],
                        persistence: URLCredential.Persistence.forSession)
                    completionHandler(.useCredential, urlCredential)
                }
                else
                {
                    completionHandler(.cancelAuthenticationChallenge,nil)
                }
            }
            else
            {
                completionHandler(.cancelAuthenticationChallenge,nil)
            }
        }
        //其他情况不接受认证
        else
        {
            completionHandler(.cancelAuthenticationChallenge,nil)
        }
    }
}
