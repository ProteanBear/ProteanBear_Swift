# PbSwiftLibrary



        使用Swift语言开发的用于开发iOS应用的轻量级框架库，包含了通用类方法扩展、网络数据访问以及扩展视图控制器等，方便应用快速开发。现在已经修改为Swift3.0语法。


### 目录索引

[使用方法](#使用方法)

[框架库说明](#框架库说明)

[使用手册](#使用手册)

— [使用手册之基本（Basic）](#基本basic)

—— [使用手册之基本（Basic）：扩展String](#扩展string)

—— [使用手册之基本（Basic）：扩展UIColor](#扩展uicolor)

—— [使用手册之基本（Basic）：扩展UIImage](#扩展uiimage)

—— [使用手册之基本（Basic）：系统信息（PbSystem）](#系统信息pbsystem)

— [使用手册之数据（Data）](#数据data)

—— [使用手册之数据（Data）：应用数据层控制器（PbDataAppController）](#应用数据层控制器pbdataappcontroller)

—— [使用手册之数据（Data）：用户数据控制器（PbDataUserController）](#用户数据控制器pbdatausercontroller)

— [使用手册之交互（UI）](#交互ui)

—— [使用手册之交互（UI）：扩展UIImageView](#扩展uiimageview)

—— [使用手册之交互（UI）：扩展UITextField](#扩展uitextfield)

—— [使用手册之交互（UI）：扩展UIViewController](#扩展uiviewcontroller)

—— [使用手册之交互（UI）：扩展UIAlertController](#扩展uialertcontroller)

—— [使用手册之交互（UI）：网格视图控制器（PbUICollectionViewController）](#网格视图控制器pbuicollectionviewcontroller)

—— [使用手册之交互（UI）：表格视图控制器（PbUITableViewController）](#表格视图控制器pbuitableviewcontroller)

[最强实例](#最强实例)

------

### 使用方法

        使用CocoaPods安装即可快速使用PbSwiftLibrary，如果还没有安装CocoaPods请参见本人博文【[部署：Mac环境部署之iOS](https://github.com/ProteanBear/PbBlog/blob/master/deploy/deploy_mac_6_iOS.md)】。

        目前CocoaPods上的PbSwiftLibrary的最新版本是0.9.5，Swift2.3语法编写（其实本人想提交Swift3.0语法的但是老是报错……，将错就错还能有个区分吧╮(╯_╰)╭，另外0.9.5版本中跟当前版本很多方法名字有些区别，所以建议还是用最新版本！）。

        Master分支上为最新版本1.0.1，Swift3.0语法。

###### Swift2.3 Podfile：

	pod 'PbSwiftLibrary'

###### Swift3.0 Podfile:

	pod 'PbSwiftLibrary',:git => "https://github.com/ProteanBear/ProteanBear_Swift", :branch => "master"
        如果你的项目需要用到网络通讯和用户数据处理模块，则下载配置文件的模板（[DataConfig.plist](./library/pb.swift.basic/DataConfig.plist)、[UseData.plist](./library/pb.swift.basic/UserData.plist)）并拖到你的项目下，在AppDelegate中引入PbSwiftLibrary，并且在didFinishLaunchingWithOptions方法中添加如下内容：

```swift
//初始化数据应用控制器单实例对象
PbDataAppController.instance.initWithPlistName("DataConfig",initLocationManager:.inUse)
        
//初始化数据用户控制器单实例对象
PbDataUserController.instance.initWithPlistName("UserData")
```



### 框架库说明

        这个库的开发目的就是提高开发效率。所以没有什么MVC、MVP、MVVM的架构模式，没有什么高深的底层技术，只是总结了日常的开发经验积累，将常用的开发方式融合封装到库中，走的就是简洁轻量的路线。需要的就是**快速上手**使用，让开发流程**更快**进行，**更快**的实现业务功能！

        当然还是结合了本人编程的风格特点，应该说比较适合小型、比较偏重展示类的应用。总结起来还是有几个特点的：

        1、**网络数据读取流程傻瓜化**

        使用.plist作为网络通讯器的配置文件，通过修改配置文件即可快速修改后台服务地址而重新运行时无需重新编译，不必像一些项目中使用头文件储存相关地址变量导致一次修改漫长的重编译等待。另外，配置文件中使用Dictionary的方式配置可访问的接口信息（url和静态参数等），请求访问调用方法时只需指定Key和动态的参数即可，请求时方法内部会自动组合**动态参数+配置文件中的静态参数+当前的系统信息**一起发送到服务端。

        2、**网络通讯可配置修改请求协议和返回格式**

        网络通讯器使用了单例模式，AppDelegate中调用创建方法时载入配置文件便可在整个应用中随地调用。通讯器中使用协议（Protocol）实现的方式来处理请求、解析处理时的不同格式，在.plist配置文件修改即可切换不同的请求器和解析器。（这只是初始的设计思想，其实现在只实现了**HTTP协议**的请求和**JSON格式**返回的解析处理，现在基本够用了，其他协议和格式支持估计要后面版本再来逐步添加。）

        3、**网络数据读取流程傻瓜化**

        Swift版本的网络通讯器直接使用的URLSession进行请求，全部异步访问。自定义了文件缓存请求返回数据，使用时只需指定访问类型即可区分从缓存中读取、从网络中读取或者先从缓存读取如果不存在再到网络读取，中间流程已经封装使用者无需考虑。另外，重新封装的表格视图控制器（UITableViewController）、网格视图控制器（UICollectionViewController）绑定了网络通讯器，只需覆盖实现几个方法配置访问的Key、请求参数、单元格显示设置以及使用哪些功能等，就可以完成一个实现了第一次载入显示载入指示器、下拉顶部刷新、上拉到底部自动加载、先从缓存载入显示列表再网络更新、后台任务异步载入单元格中的图片的列表。这些功能都已经在封装中实现了，使用者只需继承覆盖方法配置要用哪些功能，不用哪些功能，然后将注意力集中在界面展示上就好了。

        4、**丰富的扩展方法**

        根据开发者使用的经验累积，使用extension方式增加了很多实用的扩展方法，方便开发时即刻使用，如String中获取文字高度、UIImage中图片缩放和裁剪等。后面版本还会逐渐增加扩展。



### 使用手册



#### 基本（Basic）

        本来这里我放了几个需要的配置文件模板，不过CocoaPods引入后肯定是看不到的，这三个源代码里是有的：

* DataConfig.plist ：网络通讯使用的配置文件。
* UserData.plist ：用户数据的初始化文件。
* Common-Bridging-Header.h ：Swift和ObjC混编时的头文件，历史性产物而已，框架库里没啥作用。




###### 扩展String

        对String类进行扩展，增加了尺寸获取方法。方法内部是使用了NSString类的boundingRect方法获取的文字尺寸，扩展方法避免了每次使用时麻烦的构建方式。

1、 func **pbTextHeight**(_ **width**:CGFloat,**font**:UIFont) -> CGFloat

```swift
/// 计算当前文字的高度
/// - parameter width   :限制文字的宽度
/// - parameter font    :字体

//调用示例
let height="调用示例".pbTextHeight(32, font: UIFont.systemFont(ofSize: 12))
```

2、 func **pbTextSize**(_ **size**:CGSize,**font**:UIFont) -> CGSize

```swift
/// 计算当前文字的尺寸
/// - parameter size:尺寸（宽度为0获取高度；高度为0获取宽度）
/// - parameter font:字体
```

3、static func **date**() -> String

```swift
/// 获取当前时间的字符串描述，格式默认为 yyyy-MM-dd HH:mm:ss，默认为描述模式（转换为几分钟前）
```

4、static func **date**(_ **useDescription**:Bool) -> String

```swift
/// 获取当前时间的字符串描述，格式默认为 yyyy-MM-dd HH:mm:ss
/// - parameter useDescription:指定为true时使用描述模式，即转换成“几分钟前”之类的方式
```

5、static func **date**(_ **date**:Date) -> String

```swift
/// 获取指定时间的字符串描述，格式默认为 yyyy-MM-dd HH:mm:ss，默认为描述模式（转换为几分钟前）
/// - parameter date :指定时间
```

6、static func **date**(_ **date**:Date,**useDescription**:Bool) -> String

```swift
/// 获取指定时间的字符串描述，格式默认为 yyyy-MM-dd HH:mm:ss
/// - parameter date :指定时间
/// - parameter useDescription:指定为true时使用描述模式，即转换成“几分钟前”之类的方式
```

7、static func **date**(_ **format**:String) -> String

```swift
/// 获取当前时间的字符串描述并指定格式，默认为描述模式（转换为几分钟前）
/// - parameter format :指定格式
```

8、static func **date**(_ **format**:String,**useDescription**:Bool) -> String

```swift
/// 获取当前时间的字符串描述并指定格式
/// - parameter format :指定格式
/// - parameter useDescription:指定为true时使用描述模式，即转换成“几分钟前”之类的方式
```

9、static func **date**(_ **date**:Date,**format**:String) -> String

```swift
/// 获取指定时间的字符串描述并指定格式，默认为描述模式（转换为几分钟前）
/// - parameter date :指定时间
/// - parameter format :指定格式
```

10、static func **date**(_ **date**:Date,**format**:String,**useDescription**:Bool) -> String

```swift
/// 获取指定时间的字符串描述并指定格式
/// - parameter date :指定时间
/// - parameter format :指定格式
/// - parameter useDescription:指定为true时使用描述模式，即转换成“几分钟前”之类的方式
```

11、static func **date**(_ **timestamp**:Int64,format:**String**) -> String

```swift
/// 获取指定时间戳的字符串描述并指定格式
/// - parameter timestamp :时间戳
/// - parameter format :指定格式
```



###### 扩展UIColor

        对UIColor类进行了扩展，增加了Material Design的标准颜色和一些iOS常用的颜色值，另外主要是实现了给定16进制值（如0x000000）直接获取颜色的方法，避免每次创建自定义的颜色值的纠结了。调用方法如下：

```swift
//Material Design 的标准色，如红色
UIColor.pbRed(.level500)

//iOS 常用色，如天蓝色(0xf0ffff)
UIColor.pbSkyBlue

//自定义颜色，如0x121212
UIColor.pbUIColor(0x121212)
```

        Material Design对应的颜色来源于【[这里](http://wiki.jikexueyuan.com/project/material-design/style/color.html)】，方法名称同理在前面加上pb即可，但注意多词的颜色名称是倒过来的，如深紫色是Deep Purple，调用方法就是如下，参数里选择枚举中的对应级别就好可以了：

```swift
UIColor.pbPurpleDeep(.level500)
```



###### 扩展UIImage

        对UIImage类进行了扩展，增加了图片缩放裁剪等功能。

1、 class func **pbScale**(_ **image**:UIImage,**scale**:CGFloat) -> UIImage!

```swift
/// 缩放指定的图片,等比例缩放
/// - parameter image:指定图片
/// - parameter scale:指定图片的缩放比例，如缩小一半即为0.5
```

2、 class func **pbScale**(_ **image**:UIImage,**size**:CGSize) -> UIImage!

```swift
/// 缩放指定的图片,指定尺寸（注意比例，可能会变形）
/// - parameter image   :指定图片
/// - parameter size    :指定生成图片的最终尺寸
```

3、 class func **pbResize**(_ **image**:UIImage,to **size**:CGSize) -> UIImage!

```swift
/// 将指定图片剪裁为指定的大小
/// - parameter image   :指定图片
/// - parameter to size :指定生成图片的最终尺寸
```

4、 class func **pbGenerateBy**(_ **color**:UIColor,**size**:CGSize) -> UIImage

```swift
/// 根据颜色生成一张纯色的图片
/// - parameter color   :指定颜色
/// - parameter size    :指定生成图片的尺寸
```



###### 系统信息（PbSystem）

        系统信息类包括了系统一系列的静态属性，方便应用中获取调用。

| 属性                      | 说明                  |
| ----------------------- | ------------------- |
| fontMedium              | 默认加重字体（黑体）          |
| fontLight               | 默认正常字体（黑体）          |
|                         |                     |
| configData              | 默认通讯配置资源文件名称        |
| configUser              | 默认用户数据配置资源文件名称      |
|                         |                     |
| sizeBottomTabBarHeight  | 底部TabBar高度          |
| sizeBottomToolBarHeight | 底部ToolBar高度         |
| sizeTopStatusBarHeight  | 顶部状态栏高度             |
| sizeTopTitleBarHeight   | 顶部标题栏高度             |
| sizeTopMenuBarHeight    | 顶部菜单切换栏高度           |
| sizeiPhone4Width        | iPhone4 屏幕宽度（px）    |
| sizeiPhone4Height       | iPhone4 屏幕高度（px）    |
| sizeiPhone5Width        | iPhone5 屏幕宽度（px）    |
| sizeiPhone5Height       | iPhone5 屏幕高度（px）    |
| sizeiPhone6Width        | iPhone6 屏幕宽度（px）    |
| sizeiPhone6Height       | iPhone6 屏幕高度（px）    |
| sizeiPhone6pWidth       | iPhone6p 屏幕宽度（px）   |
| sizeiPhone6pHeight      | iPhone6p 屏幕高度（px）   |
| sizeiPadWidth           | iPad横向 屏幕宽度（px）     |
| sizeiPadHeight          | iPad横向 屏幕高度（px）     |
| sizeUpdateViewHeight    | 表格下拉更新组件的高度         |
|                         |                     |
| osVersion               | 当前系统版本号（转为浮点数）      |
| os6                     | 当前系统是否为6.0以上、7.0以下  |
| os7                     | 当前系统是否为7.0以上、8.0以下  |
| os8                     | 当前系统是否为8.0以上、9.0以下  |
| os9                     | 当前系统是否为9.0以上、10.0以下 |
| osUp8                   | 当前系统是否为8.0以上版本      |
| osUp9                   | 当前系统是否为9.0以上版本      |
| osUp10                  | 当前系统是否为10.0以上版本     |
|                         |                     |
| screenWidth             | 屏幕的宽度               |
| screenHeight            | 屏幕的高度               |
| screenSize              | 屏幕的尺寸               |
| screenCurrentWidth      | 当前翻转模式下屏幕的宽度        |
| screenCurrentHeight     | 当前翻转模式下屏幕的高度        |
| screenCurrentSize       | 当前翻转模式下屏幕的尺寸        |



####  数据（Data）



###### 应用数据层控制器（PbDataAppController）

        PbDataAppController使用了单例模式，并使用了配置文件的方式设置网络通信的相关信息。使用时先下载配置文件模板（[DataConfig.plist](./library/pb.swift.basic/DataConfig.plist)）并拖入到项目中，在AppDelegate中引入PbSwiftLibrary，并且在didFinishLaunchingWithOptions方法中添加如下内容：

```swift
//初始化数据应用控制器单实例对象
PbDataAppController.instance.initWithPlistName("DataConfig",initLocationManager:.inUse)
```

1、DataConfig.plist的配置

| 名称                 | 类型         | 说明                      |
| ------------------ | ---------- | ----------------------- |
| Root               | Dictionary | 根                       |
| — sever            | String     | 服务器地址【根据自己的服务地址修改】      |
| — communication    | Dictionary | 通讯协议配置【建议不要修改】          |
| —— protocol        | String     | 协议类型，目前仅支持HTTP          |
| —— method          | String     | 传递方法，建议使用POST           |
| —— responseType    | String     | 返回类型，目前仅支持JSON解析        |
| —— timeOut         | Number     | 超时时间，默认为10秒             |
| — localCache       | Dictionary | 本地文件缓存【建议不要修改】          |
| —— isActive        | Boolean    | 是否激活，建议开启               |
| —— cachePath       | String     | 文件缓存的文件夹名称              |
| —— subResourcePath | String     | 缓存资源文件（图片）的文件夹名称        |
| —— subDataPath     | String     | 缓存数据文件的文件夹名称            |
| —— expireTime      | Number     | 缓存超时时间                  |
| — interface        | Dictionary | 网络通信接口配置【这里可以根据自己的接口修改】 |
| —— key1            | Dictionary | 接口名称【自己设置】              |
| ——— url            | String     | 接口对应的URL相对地址            |
| ——— params         | Dictionary | 接口传递的参数配置【此处设置静态参数】     |
| ———— param1        | String     | 参数对应值【根据自己的接口设置】        |

2、调用示例

```swift
//载入数据
PbDataAppController.instance.requestWithKey(
	//接口的名称
	"key1", 
	//增加要传递的动态参数，值支持为NSArray格式，转换为请求参数为key1=value1&key1=value2
	params: NSMutableDictionary(), 
	//请求返回处理
	//data:返回数据
	//error:错误信息
	//property:请求时附带的属性，会在回调时传回
	callback: { (data, error, property) -> Void in
	
		let logPre="UIViewController:pbLoadData:"+key+":"
                
         //输出错误信息
         if(error != nil)
         {
              PbLog.error(logPre+(error?.description)!)
              return
         }
                
         //解析控制器返回结果
         var conRes=data?.object(forKey: PbDataAppController.KEY_RESPONSE) as! Dictionary<String,String>
         let netStatus=conRes[PbDataAppController.KEY_NETWORK]!
         let netSuccess=NSString(string:conRes[PbDataAppController.KEY_SUCCESS]!).boolValue
                
         //检查结果
         if(!netSuccess)
         {
         	if(PbDataAppController.instance.isNetworkConnected(netStatus))
         	{
         		PbLog.error(logPre+"未连接网络")
         	}
         	PbLog.error(logPre+"访问失败")
         	return
         }
         
         //处理数据
	}, 
	//数据获取模式
	//fromNet:网络获取\fromLocalOrNet:先从缓存读取，无缓存则从网络读取\fromLocal:本地缓存获取
	getMode: .fromNet)
```

3、func **initWithPlistName**(_ **plistName**:String)

```swift
/// 使用配置文件初始化应用数据控制器，读取相应的URL访问及数据存储相关配置
/// - parameter plistName:配置文件资源名称
```

4、func **initWithPlistName**(_ **plistName**:String,**initLocationManager**:PbDataLocationMode)

```swift
/// 使用配置文件初始化应用数据控制器，读取相应的URL访问及数据存储相关配置
/// - parameter plistName:配置文件资源名称
/// - parameter initLocationManager:初始化时开启定位
```

5、func **isNetworkConnected**() -> Bool

```swift
/// 是否连接网络
```

6、func **request**(_ **key**:String,**params**:NSDictionary,**callback**:@escaping (_ data:NSDictionary?,_ error:NSError?,_ property:NSDictionary?) -> Void,**getMode**:PbDataGetMode)

```swift
/// 通过指定接口标识，获取对应的数据信息
/// - parameter key       :接口标识
/// - parameter params    :传递参数
/// - parameter callback  :回调方法
/// - parameter getMode   :请求模式，包括网络、本地缓存或网络、本地
```

7、func **request**(_ **key**:String,**params**:NSDictionary,**callback**:@escaping (_ data:NSDictionary?,_ error:NSError?,_ property:NSDictionary?) -> Void,**getMode**:PbDataGetMode,**property**:NSDictionary?)

```swift
/// 通过指定接口标识，获取对应的数据信息
/// - parameter key       :接口标识
/// - parameter params    :传递参数
/// - parameter callback  :回调方法
/// - parameter getMode   :请求模式，包括网络、本地缓存或网络、本地
/// - parameter property  :回传属性
```

8、func **request**(_ **key**:String,**params**:NSDictionary,**callback**:@escaping (_ data:NSDictionary?,_ error:NSError?,_ property:NSDictionary?) -> Void,**getMode**:PbDataGetMode,**dataType**:Bool)

```swift
///  通过指定接口标识，获取对应的数据信息
/// - parameter key         :接口标识
/// - parameter params      :传递参数
/// - parameter callback    :回调方法
/// - parameter getMode     :请求模式，包括网络、本地缓存或网络、本地
/// - parameter sourceType  :是否数据上传类型
```

9、func **request**(_ **key**:String,**params**:NSDictionary,**callback**:@escaping (_ data:NSDictionary?,_ error:NSError?,_ property:NSDictionary?) -> Void,getMode:PbDataGetMode,**property**:NSDictionary?,**dataType**:Bool)

```swift
/// 通过指定接口标识，获取对应的数据信息
/// - parameter key         :接口标识
/// - parameter params      :传递参数
/// - parameter callback    :回调方法
/// - parameter getMode     :请求模式，包括网络、本地缓存或网络、本地
/// - parameter property    :回传属性
/// - parameter sourceType  :是否数据上传类型
```

10、func **sizeOfCacheDataInLocal**() -> String

```swift
/// 获取本地缓存数据大小
```

11、func **clearCacheDataInLocal**() -> String

```swift
/// 清理缓存数据
```

12、func **fullUrl**(_ url:String) -> String

```swift
/// 获取完整路径
/// - parameter url:链接地址
```



###### 用户数据控制器（PbDataUserController）

        PbDataUserController同样使用了单例模式，并使用了配置文件的方式来初始化内容，其实就是封装了一个UserDefaults的处理入口而已，如果不想使用不初始化创建就好了。

        如果想使用时，先下载配置文件模板（UserData.plist](./library/pb.swift.basic/UserData.plist)）并拖入到项目中，在AppDelegate中引入PbSwiftLibrary，并且在didFinishLaunchingWithOptions方法中添加如下内容：

```swift
//初始化数据用户控制器单实例对象
PbDataUserController.instance.initWithPlistName("UserData")
```

1、UserData.plist的配置

| 名称               | 类型         | 说明            |
| ---------------- | ---------- | ------------- |
| Root             | Dictionary | 根             |
| — userId         | String     | 用户ID，初始为空     |
| — userName       | String     | 用户姓名，初始为空     |
| — userPass       | String     | 用户密码，初始为空     |
| — userHead       | String     | 用户头像，初始为空     |
| — userFontSize   | Number     | 文本字体大小，初始为16  |
| — userLineHeight | Number     | 文本段落行距，初始为1.4 |

        之所以叫做初始化配置，只有应用第一次打开时设置了初始值，以后每次打开都会从UserDefaults中读取而已。

2、var **isFirstLaunch**:Bool

```swift
/// 返回用户是否第一次打开应用
```

3、func **saveUserData**()

```swift
/// 保存用户信息
```

4、func **isFavorite**(_ **id**:String) ->Bool

```swift
/// 增加收藏
/// - parameter data:收藏数据
/// - parameter id:收藏的主键标识
```

5、func **addFavorite**(_ **data**:AnyObject,**id**:String)

```swift
/// 移除收藏
/// - parameter id:收藏的主键标识
```

6、func **removeFavorite**(_ **id**:String)

```swift
/// 移除收藏
/// - parameter id:收藏的主键标识
```

7、func **removeFavoritesWithArray**(_ **idArray**:NSArray)

```swift
/// 移除收藏
/// - parameter idArray:收藏的主键数组
```

8、func **removeFavorites**(_ **ids**:[String])

```swift
/// 移除收藏
/// - parameter ids:收藏的主键数组
```

9、func **contains**(_ **forKey**:String) ->Bool

```swift
/// 检查用户数据中，指定的键是否存在
/// - parameter forKey:键值
```

10、func **setObject**(_ **value**: AnyObject?, **for** **key**: String)

```swift
/// 设置或者增加键值
/// - parameter value:内容
/// - parameter key:键
```

11、func **valueForKey**(**for** **key**: String) -> AnyObject?

```swift
/// 获取键对应的内容
/// - parameter key:键
```

12、func **removeValueForKey**(**for** **key**: String)

```swift
/// 删除键值
/// - parameter key:键
```

13、var **userId**:String?

```swift
/// 用户标识
```

14、var **userName**:String?

```swift
/// 用户名称
```

15、var **userPass**:String?

```swift
/// 用户密码
```

16、var **userHead**:String?

```swift
/// 用户头像
```

17、var **userFontSize**:Int?

```swift
/// 用户文本字体
```

18、var **userLineHeight**:Float?

```swift
/// 用户文本行高
```

19、var **userFavorite**:NSMutableDictionary?

```swift
/// 用户收藏
```



####  交互（UI）



###### 扩展UIImageView

        对UIImageView类进行了扩展，增加了载入网络图片、根据比例自动设置显示以及动画淡入显示等方法。

1、func **pbLoadWith**(_ **url**:String)

```swift
/// 异步载入网络图片，会自动先从缓存读取，如没有再从网络下载，并在下载完成后淡入效果显示
/// - parameter url:图片链接地址
```

2、func **pbLoadWith**(_ **url**:String,**scale**:Float?)

```swift
/// 异步载入网络图片(指定显示的比例)，会自动先从缓存读取，如没有再从网络下载，并在下载完成后淡入效果显示
/// - parameter url     :图片链接地址
/// - parameter scale   :显示比例宽比高，如4/3；默认小于这个比例用scaleAspectFill，大于比例用scaleAspectFit
```

3、func **pbLoadWith**(_ **url**:String,**scale**:Float?,**lowMode**:UIViewContentMode,**overMode**:UIViewContentMode)

```swift
/// 异步载入网络图片(指定显示的比例)，会自动先从缓存读取，如没有再从网络下载，并在下载完成后淡入效果显示
/// - parameter url     :图片链接地址
/// - parameter scale   :显示比例宽比高，如4/3
/// - parameter lowMode :小于比例时的显示模式
/// - parameter overMode:大于比例时的显示模式
```


4、func **pbAutoSetContentMode**(_ **scale**:Float?)

```swift
/// 根据指定的比例设置图片视图显示模式
/// - parameter scale   :显示比例宽比高，如4/3；默认小于这个比例用scaleAspectFill，大于比例用scaleAspectFit
```


5、func **pbAutoSetContentMode**(_ **scale**:Float?,**lowMode**:UIViewContentMode,**overMode**:UIViewContentMode)

```swift
/// 根据指定的比例设置图片视图显示模式
/// - parameter scale   :显示比例宽比高，如4/3
/// - parameter lowMode :小于比例时的显示模式
/// - parameter overMode:大于比例时的显示模式
```


6、func **pbSet**(_ **image**:UIImage,**scale**:Float?)

```swift
/// 指定设置比例并动画显示图片
/// - parameter image   :图片
/// - parameter scale   :显示比例宽比高，如4/3；默认小于这个比例用scaleAspectFill，大于比例用scaleAspectFit
```

7、func **pbSet**(_ **image**:UIImage,**scale**:Float?,**lowMode**:UIViewContentMode,**overMode**:UIViewContentMode)

```swift
/// 指定设置比例并动画显示图片
/// - parameter image   :图片
/// - parameter scale   :显示比例宽比高，如4/3
/// - parameter lowMode :小于比例时的显示模式
/// - parameter overMode:大于比例时的显示模式
```

8、func **pbAnimation**(_ **image**:UIImage?)

```swift
/// 动画（淡入）显示图片
/// - parameter image   :图片
```

9、func **pbAnimation**(_ **image**:UIImage?,**scale**:Float?,**lowMode**:UIViewContentMode,**overMode**:UIViewContentMode)

```swift
/// 动画（淡入）显示图片载入完成
/// - parameter image   :图片
/// - parameter scale   :显示比例宽比高，如4/3
/// - parameter lowMode :小于比例时的显示模式
/// - parameter overMode:大于比例时的显示模式
```

###### 

###### 扩展UITextField

        对UITextField类进行了扩展，增加了左右边距的设置方法

1、func **pbSetLeftPadding**(_ **width**:CGFloat)

```swift
/// 设置左侧边距
/// - parameter width:边距宽度
```

2、func **pbSetRightPadding**(_ **width**:CGFloat)

```swift
/// 设置右侧边距
/// - parameter width:边距宽度
```



###### 扩展UIViewController

       对UIViewController类进行了扩展，增加了数据获取和提示信息的方法

1、func **pbMsgTip**(_ **msg**:String,**dismissAfterSecond**:TimeInterval,**position**:PbMsyPosition)

```swift
/// 提示信息，注意有些表格或网格视图底部显示时会看不到
/// - parameter msg                 :提示信息
/// - parameter dismissAfterSecond  :消失时间，单位为秒
/// - parameter position            :显示位置
```

2、func **pbLoadData**(_ **updateMode**:PbDataUpdateMode,**controller**:PbUIViewControllerProtocol?)

```swift
/// 获取数据,这种扩展方式需要实现协议
/// - parameter updateMode:数据更新模式
/// - parameter controller:协议实现对象
```

       这种扩展方式的数据获取的好处是有已经编写好的处理流程，因此只要实现协议的几个方法就可以，专注在数据显示处理上；坏处同样是要实现协议，因为协议尽量涵盖了大量的流程介入方法而Swift的协议方法无法Optional，所以要把所有协议方法都复制到协议实现的类中，有些方法根本完全可以不实现。所以要是嫌麻烦还是直接使用PbDataAppController.instance直接请求好了。

       那为啥要用这种方式呢，是因为后面会提到的封装的表格和网格控制器都是用这种方法，并且实现了协议，继承了这两个父类只要覆盖需要覆盖的方法就好了。



###### 扩展UIAlertController

       iOS8以后已经建议使用UIAlertController了，但是每次使用都要设置类型和按钮处理有点麻烦，这里对UIAlertController类进行了扩展，增加了直接生成不同类型UIAlertController的方法。

1、class func **pbAlert**(_ **message**:String) ->UIAlertController

```swift
/// 生成提示式中间弹框（默认标题“系统提示”，关闭按钮为“关闭”）
/// - parameter message:消息内容
```

2、class func **pbAlert**(_ **title**:String,**message**:String) ->UIAlertController

```swift
/// 生成提示式中间弹框（默认关闭按钮为“关闭”）
/// - parameter title   :显示标题
/// - parameter message :消息内容
```

3、class func **pbAlert**(_ **title**:String,**message**:String,**handler**:((UIAlertAction) -> Void)?) ->UIAlertController

```swift
/// 生成提示式中间弹框（默认关闭按钮为“关闭”）
/// - parameter title   :显示标题
/// - parameter message :消息内容
/// - parameter handler :关闭时的执行方法
```

4、class func **pbAlert**(_ **title**:String,**message**:String,**handler**:((UIAlertAction) -> Void)?,**closeLabel**:String) ->UIAlertController

```swift
/// 生成提示式中间弹框
/// - parameter title       :显示标题
/// - parameter message     :消息内容
/// - parameter handler     :关闭时的执行方法
/// - parameter closeLabel  :关闭按钮显示
```

5、class func **pbConfirm**(_ **message**:String,**confirm**:((UIAlertAction) -> Void)?) ->UIAlertController

```swift
/// 生成确认式中间弹框
/// - parameter message     :消息内容
/// - parameter confirm     :确定时的执行方法
```

6、class func **pbConfirm**(_ **title**:String,**message**:String,**confirm**:((UIAlertAction) -> Void)?) ->UIAlertController

```swift
/// 生成确认式中间弹框
/// - parameter title       :显示标题
/// - parameter message     :消息内容
/// - parameter confirm     :确定时的执行方法
```

7、class func **pbSheet**(_ **title**:String,**actions**:[UIAlertAction]) ->UIAlertController

```swift
/// 生成底部弹框
/// - parameter title       :显示标题
/// - parameter actions     :按钮数组
```

8、class func **pbSheet**(_ **title**:String,**cancelLabel**:String,**actions**:[UIAlertAction]) ->UIAlertController

```swift
/// 生成底部弹框
/// - parameter title       :显示标题
/// - parameter cancelLabel :取消按钮标题
/// - parameter actions     :按钮数组
```

9、class func **pbSheet**(_ **title**:String,**message**:String?,**cancelLabel**:String,**actions**:[UIAlertAction]) ->UIAlertController

```swift
/// 生成底部弹框
/// - parameter title       :显示标题
/// - parameter message     :显示内容
/// - parameter cancelLabel :取消按钮标题
/// - parameter actions     :按钮数组
```



###### 网格视图控制器（PbUICollectionViewController）

       实现UIViewController中的扩展协议，创建网格视图父类，增加数据绑定载入方法、图片下载任务处理、下拉刷新以及翻页等相关处理流程。

1、使用示例

```swift
import Foundation
import UIKit
import PbSwiftLibrary

/// PbUICollectionViewController使用示例
class TestCollectionViewController:PbUICollectionViewController,UICollectionViewDelegateFlowLayout
{
  	//视图载入后载入数据
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //载入数据
        self.pbLoadData(.first)
    }
    
    //返回当前数据访问使用的链接标识
    override func pbKeyForDataLoad() -> String?
    {
        return "busiCmsArticle"
    }
    
    //返回当前数据访问使用的参数
    override func pbParamsForDataLoad(_ updateMode: PbDataUpdateMode) -> NSMutableDictionary?
    {
        return NSMutableDictionary(dictionary: ["sectionCode":"0000","limit":99])
    }
    
    //解析处理返回的数据
    override func pbResolveFromResponse(_ response: NSDictionary) -> AnyObject?
    {
        var dataList:NSArray?
        
        let successObj: AnyObject?=response.object(forKey: "success") as AnyObject?
        if(successObj != nil)
        {
            let success=successObj as! Bool
            if(success)
            {
                dataList=response.object(forKey: "list") as? NSArray
            }
            else
            {
                self.pbErrorForDataLoad(.serverError, error:(response.object(forKey:"infor") as! String))
            }
        }
        
        return response.object(forKey: "list") as? NSArray
    }
    
    //返回指定位置的单元格标识
    override func pbIdentifierForCollectionView(_ indexPath: IndexPath, data: AnyObject?) -> String
    {
        return "PaintingCollectionCell"
    }
    
    //设置表格数据显示
    override func pbSetDataForCollectionView(_ cell: AnyObject, data: AnyObject?, photoRecord: PbDataPhotoRecord?, indexPath: IndexPath) -> AnyObject
    {
    	//设置单元格显示
    	
    	//设置单元格中的图片显示
    	if(photoRecord != nil)
        {
            switch(photoRecord!.state)
            {
            //未下载的图片，设置默认图片
            case .new:
                break
            //下载完的图片，设置图片显示(photoRecord!.image!)
            case .downloaded:
                break
            //下载失败的图片，设置图片显示
            case .failed:
                break
            }
        }
    	
    	return cell
    }
    
    //pbPhotoUrlInIndexPath:返回单元格中的网络图片链接（不设置则无网络图片下载任务）
    override func pbPhotoUrlInIndexPath(_ indexPath: IndexPath) -> String?
    {
        return "articleImageTitle"
    }
}
```

2、常用设置之处理单元格显示的图片

```swift
/// 返回单元格中的网络图片标识（不设置则无网络图片下载任务）
/// - parameter indexPath:单元格位置索引
open func pbPhotoKeyInIndexPath(_ indexPath:IndexPath) -> String?
{
	return nil
}
    
/// 返回单元格中的网络图片链接（不设置则无网络图片下载任务）
/// - parameter indexPath   :单元格位置索引
/// - parameter data        :位置对应的数据
open func pbPhotoUrlInIndexPath(_ indexPath:IndexPath, data: AnyObject?) -> String?
{
    return nil
}
```

3、常用设置之刷新翻页

```swift
/// 是否支持表格顶部刷新
func pbSupportHeaderRefresh() -> Bool
    
/// 表格顶部刷新的主题颜色（tiniColor）
func pbSupportHeaderRefreshColor() -> UIColor?
    
/// 是否支持表格底部载入
func pbSupportFooterLoad() -> Bool
    
/// 返回表格底部载入类型
func pbSupportFooterLoadType() -> PbUIViewType
    
/// 表格底部载入主题颜色（tiniColor）
func pbSupportFooterLoadColor() -> UIColor?

/// 初次载入后是否立即更新
func pbAutoUpdateAfterFirstLoad() -> Bool
    
/// 支持载入显示器
func pbSupportActivityIndicator() -> PbUIActivityIndicator?
```

4、常用设置之数据处理

```swift
/// 返回当前数据访问使用的链接标识
func pbKeyForDataLoad() -> String?
    
/// 返回当前数据访问使用的参数
/// - parameter updateMode:数据更新模式，包括第一次、更新和翻页
func pbParamsForDataLoad(_ updateMode:PbDataUpdateMode) -> NSMutableDictionary?
    
/// 返回当前数据访问使用的页码参数名称
func pbPageKeyForDataLoad() -> String

/// 解析处理返回的数据(两个解析方法实现一个即可)
/// - parameter response:返回数据，已经解析为字典
func pbResolveFromResponse(_ response:NSDictionary) -> AnyObject?
    
/// 解析处理返回的数据(两个解析方法实现一个即可)
/// - parameter response:返回数据，已经解析为字典
/// - parameter updateMode:数据更新模式，包括第一次、更新和翻页
func pbResolveFromResponse(_ response:NSDictionary,updateMode:PbDataUpdateMode) -> AnyObject?
```

       其实很多设置父类中都有默认值，网络载入最简单只要覆盖pbKeyForDataLoad（请求）、pbResolveFromResponse（解析）、pbIdentifierForCollectionView（单元格复用标识）、pbSetDataForCollectionView（显示）四个方法就好了。



###### 表格视图控制器（PbUITableViewController）

       实现UIViewController中的扩展协议，创建表格视图父类，增加数据绑定载入方法、图片下载任务处理、下拉刷新以及翻页等相关处理流程。

1、使用示例

```swift
import Foundation
import UIKit
import PbSwiftLibrary

/// PbUICollectionViewController使用示例
class TestCollectionViewController:PbUICollectionViewController,UICollectionViewDelegateFlowLayout
{
  	//视图载入后载入数据
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //载入数据
        self.pbLoadData(.first)
    }
    
    //返回当前数据访问使用的链接标识
    override func pbKeyForDataLoad() -> String?
    {
        return "busiCmsArticle"
    }
    
    //返回当前数据访问使用的参数
    override func pbParamsForDataLoad(_ updateMode: PbDataUpdateMode) -> NSMutableDictionary?
    {
        return NSMutableDictionary(dictionary: ["sectionCode":"0000","limit":99])
    }
    
    //解析处理返回的数据
    override func pbResolveFromResponse(_ response: NSDictionary) -> AnyObject?
    {
        var dataList:NSArray?
        
        let successObj: AnyObject?=response.object(forKey: "success") as AnyObject?
        if(successObj != nil)
        {
            let success=successObj as! Bool
            if(success)
            {
                dataList=response.object(forKey: "list") as? NSArray
            }
            else
            {
                self.pbErrorForDataLoad(.serverError, error:(response.object(forKey:"infor") as! String))
            }
        }
        
        return response.object(forKey: "list") as? NSArray
    }
    
    //返回指定位置的单元格标识
    override func pbIdentifierForTableView(_ indexPath: IndexPath, data: AnyObject?) -> String
    {
        return "WriterNewsCellWithImage"
    }
    
    //设置表格数据显示
    override func pbSetDataForTableView(_ cell: AnyObject, data: AnyObject?, photoRecord: PbDataPhotoRecord?, indexPath: IndexPath) -> AnyObject
    {
    	//设置单元格显示
    	
    	//设置单元格中的图片显示
    	if(photoRecord != nil)
        {
            switch(photoRecord!.state)
            {
            //未下载的图片，设置默认图片
            case .new:
                break
            //下载完的图片，设置图片显示(photoRecord!.image!)
            case .downloaded:
                break
            //下载失败的图片，设置图片显示
            case .failed:
                break
            }
        }
    	
    	return cell
    }
    
    //pbPhotoUrlInIndexPath:返回单元格中的网络图片链接（不设置则无网络图片下载任务）
    override func pbPhotoUrlInIndexPath(_ indexPath: IndexPath) -> String?
    {
        return "articleImageTitle"
    }
}
```

常用设置之处理单元格显示的图片

```swift
/// 返回单元格中的网络图片标识（不设置则无网络图片下载任务）
/// - parameter indexPath:单元格位置索引
open func pbPhotoKeyInIndexPath(_ indexPath:IndexPath) -> String?
{
	return nil
}
    
/// 返回单元格中的网络图片链接（不设置则无网络图片下载任务）
/// - parameter indexPath   :单元格位置索引
/// - parameter data        :位置对应的数据
open func pbPhotoUrlInIndexPath(_ indexPath:IndexPath, data: AnyObject?) -> String?
{
    return nil
}
```

3、常用设置之刷新翻页

```swift
/// 是否支持表格顶部刷新
func pbSupportHeaderRefresh() -> Bool
    
/// 表格顶部刷新的主题颜色（tiniColor）
func pbSupportHeaderRefreshColor() -> UIColor?
    
/// 是否支持表格底部载入
func pbSupportFooterLoad() -> Bool
    
/// 返回表格底部载入类型
func pbSupportFooterLoadType() -> PbUIViewType
    
/// 表格底部载入主题颜色（tiniColor）
func pbSupportFooterLoadColor() -> UIColor?

/// 初次载入后是否立即更新
func pbAutoUpdateAfterFirstLoad() -> Bool
    
/// 支持载入显示器
func pbSupportActivityIndicator() -> PbUIActivityIndicator?
```

4、常用设置之数据处理

```swift
/// 返回当前数据访问使用的链接标识
func pbKeyForDataLoad() -> String?
    
/// 返回当前数据访问使用的参数
/// - parameter updateMode:数据更新模式，包括第一次、更新和翻页
func pbParamsForDataLoad(_ updateMode:PbDataUpdateMode) -> NSMutableDictionary?
    
/// 返回当前数据访问使用的页码参数名称
func pbPageKeyForDataLoad() -> String

/// 解析处理返回的数据(两个解析方法实现一个即可)
/// - parameter response:返回数据，已经解析为字典
func pbResolveFromResponse(_ response:NSDictionary) -> AnyObject?
    
/// 解析处理返回的数据(两个解析方法实现一个即可)
/// - parameter response:返回数据，已经解析为字典
/// - parameter updateMode:数据更新模式，包括第一次、更新和翻页
func pbResolveFromResponse(_ response:NSDictionary,updateMode:PbDataUpdateMode) -> AnyObject?
```

       其实很多设置父类中都有默认值，网络载入最简单只要覆盖pbKeyForDataLoad（请求）、pbResolveFromResponse（解析）、pbIdentifierForCollectionView（单元格复用标识）、pbSetDataForCollectionView（显示）四个方法就好了。



### 最强实例

       还不知道怎么用！！！算了直接上代码了，而且不是Demo，到【[这里](https://github.com/ProteanBear/PbSwiftPaintingYxy)】吧！
