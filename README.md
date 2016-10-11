# PbSwiftLibrary



        使用Swift语言开发的用于开发iOS应用的轻量级框架库，包含了通用类方法扩展、网络数据访问以及扩展视图控制器等，方便应用快速开发。现在已经修改为Swift3.0语法。



### 引用方法

        使用CocoaPods安装即可快速使用PbSwiftLibrary，如果还没有安装CocoaPods请参见本人博文【[部署：Mac环境部署之iOS](https://github.com/ProteanBear/PbBlog/blob/master/deploy/deploy_mac_6_iOS.md)】。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;目前CocoaPods上的PbSwiftLibrary的最新版本是0.9.5，Swift2.3语法编写（其实本人想提交Swift3.0语法的但是老是报错……，将错就错还能有个区分吧╮(╯_╰)╭）。

        Master分支上为最新版本1.0.0，Swift3.0语法。

###### Swift2.3 Podfile：

	pod 'PbSwiftLibrary'

###### Swift3.0 Podfile:

	pod 'PbSwiftLibrary',:git => "https://github.com/ProteanBear/ProteanBear_Swift", :branch => "master"


### 框架库说明

        这个库的开发目的就是提高开发效率。所以没有什么MVC、MVP、MVVM的架构模式，没有什么高深的底层技术，只是总结了日常的开发经验积累，将常用的开发方式融合封装到库中，走的就是简洁轻量的路线。需要的就是**快速上手**使用，让开发流程**更快**进行，**更快**的实现业务功能！

        当然还是结合了本人编程的风格特点，应该说比较适合小型、比较偏重展示类的应用。总结起来还是有几个特点的：

1. **网络通讯外部文件配置**

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;使用.plist作为网络通讯器的配置文件，通过修改配置文件即可快速修改后台服务地址而重新运行时无需重新编译，不必像一些项目中使用头文件储存相关地址变量导致一次修改漫长的重编译等待。另外，配置文件中使用Dictionary的方式配置可访问的接口信息（url和静态参数等），请求访问调用方法时只需指定Key和动态的参数即可，请求时方法内部会自动组合**动态参数+配置文件中的静态参数+当前的系统信息**一起发送到服务端。

2. **网络通讯可配置修改请求协议和返回格式**

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;网络通讯器使用了单例模式，AppDelegate中调用创建方法时载入配置文件便可在整个应用中随地调用。通讯器中使用协议（Protocol）实现的方式来处理请求、解析处理时的不同格式，在.plist配置文件修改即可切换不同的请求器和解析器。（这只是初始的设计思想，其实现在只实现了**HTTP协议**的请求和**JSON格式**返回的解析处理，现在基本够用了，其他协议和格式支持估计要后面版本再来逐步添加。）

3. **网络数据读取流程傻瓜化**

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Swift版本的网络通讯器直接使用的URLSession进行请求，全部异步访问。自定义了文件缓存请求返回数据，使用时只需指定访问类型即可区分从缓存中读取、从网络中读取或者先从缓存读取如果不存在再到网络读取，中间流程已经封装使用者无需考虑。另外，重新封装的表格视图控制器（UITableViewController）、网格视图控制器（UICollectionViewController）绑定了网络通讯器，只需覆盖实现几个方法配置访问的Key、请求参数、单元格显示设置以及使用哪些功能等，就可以完成一个实现了第一次载入显示载入指示器、下拉顶部刷新、上拉到底部自动加载、先从缓存载入显示列表再网络更新、后台任务异步载入单元格中的图片的列表。这些功能都已经在封装中实现了，使用者只需继承覆盖方法配置要用哪些功能，不用哪些功能，然后将注意力集中在界面展示上就好了。

4. **丰富的扩展方法**

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;根据开发者使用的经验累积，使用extension方式增加了很多实用的扩展方法，方便开发时即刻使用，如String中获取文字高度、UIImage中图片缩放和裁剪等。后面版本还会逐渐增加扩展。



### 使用手册



#### 基本（Basic）

        本来这里我放了几个需要的配置文件模板，不过CocoaPods引入后肯定是看不到的，这三个源代码里是有的：

* DataConfig.plist ：网络通讯使用的配置文件。（详细说明参见【这里】）
* UserData.plist ：用户数据的初始化文件。（详细说明参见【这里】）
* Common-Bridging-Header.h ：Swift和ObjC混编时的头文件，历史性产物而已，框架库里没啥作用。




###### 基本：扩展String

        对String类进行扩展，增加了尺寸获取方法。方法内部是使用了NSString类的boundingRect方法获取的文字尺寸，扩展方法避免了每次使用时麻烦的构建方式。

1. public func pbTextHeight(_ width:CGFloat,font:UIFont) -> CGFloat

```
/// 计算当前文字的高度
/// - parameter width   :限制文字的宽度
/// - parameter font    :字体
```

2. public func pbTextSize(_ size:CGSize,font:UIFont) -> CGSize

```
/// 计算当前文字的尺寸
/// - parameter size:尺寸（宽度为0获取高度；高度为0获取宽度）
/// - parameter font:字体
```



###### 基本：扩展UIColor

        对UIColor类进行了扩展，增加了Material Design的标准颜色和一些iOS常用的颜色值，另外主要是实现了给定16进制值（如0x000000）直接获取颜色的方法，避免每次创建自定义的颜色值的纠结了。调用方法如下：

```
//Material Design 的标准色，如红色
UIColor.pbRed(.level500)

//iOS 常用色，如天蓝色(0xf0ffff)
UIColor.pbSkyBlue

//自定义颜色，如0x121212
UIColor.pbUIColor(0x121212)
```

| MaterialDesign | 方法名   | 级别       | 颜色                                       |
| -------------- | ----- | -------- | ---------------------------------------- |
| 红色             | pbRed | .level50 | <span style="width:60px;backgroud-color:#fde0dc;"> </span> |
|                |       |          |                                          |
|                |       |          |                                          |

###### 扩展UIImage

###### 日志打印（PbLog）

###### 系统信息（PbSystem）



####  数据（Data）

###### 应用数据层控制器（PbDataAppController）

###### 用户数据控制器（PbDataUserController）



####  交互（UI）

###### 扩展UIImageView

###### 扩展UIScrollView

###### 扩展UITextField

###### 扩展UIViewController

###### 扩展UIAlertController

###### 网格视图控制器（PbUICollectionViewController）

###### 表格视图控制器（PbUITableViewController）