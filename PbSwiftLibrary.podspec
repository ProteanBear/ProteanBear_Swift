Pod::Spec.new do |s|

  # ―――  Spec Metadata

  s.name         = "PbSwiftLibrary"
  s.version      = "1.0.3"
  s.summary      = "使用Swift语言开发的用于开发iOS应用的轻量级框架库，包含了通用类方法扩展、网络数据访问以及扩展视图控制器等，方便应用快速开发。"

  s.description  = <<-DESC

                    说明：使用Swift语言开发的用于开发iOS应用的轻量级框架库，包含了通用类方法扩展、网络数据访问以及扩展视图控制器等，方便应用快速开发。

                   DESC

  s.homepage     = "https://github.com/ProteanBear/ProteanBear_Swift"


  # ―――  Spec License

  s.license      = { :type => "Apache", :file => "LICENSE" }


  # ――― Author Metadata

  s.author       = { "ProteanBear" => "moru_1982@hotmail.com" }

  # ――― Platform Specifics

  s.platform     = :ios, "9.0"

  # ――― Source Location

  s.source       = { :git => "https://github.com/ProteanBear/ProteanBear_Swift.git", :tag => "V#{s.version}" }


  # ――― Source Code

  s.source_files  = "library/**/*.{swift}"
  # s.public_header_files = "Classes/**/*.h"

  # ――― Resources

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking

  s.frameworks = "UIKit", "CoreLocation"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings

  s.requires_arc = true
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  s.dependency 'ReachabilitySwift'

  s.dependency 'CryptoSwift'

end
