Pod::Spec.new do |s|

  # ―――  Spec Metadata

  s.name         = "PbSwiftLibrary"
  s.version      = "0.9.0"
  s.summary      = "由ProteanBear创作使用Swift语言开发的用于开发iOS应用的轻量级框架库，包含了通用方法、数据绑定和一些常用的UI组件以及视图控制器。"

  s.description  = <<-DESC

                   DESC

  s.homepage     = "https://github.com/ProteanBear/ProteanBear_Swift"


  # ―――  Spec License

  s.license      = { :type => "Apache", :file => "LICENSE" }


  # ――― Author Metadata

  s.author             = { "ProteanBear" => "moru_1982@hotmail.com" }

  # ――― Platform Specifics

  s.platform     = :ios, "8.0"

  # ――― Source Location

  s.source       = { :git => "https://github.com/ProteanBear/ProteanBear_Swift.git", :tag => "V#{s.version}" }


  # ――― Source Code

  s.source_files  = "library/**/*.{swift,h,m}"
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
  s.dependency "ReachabilitySwift"

end
