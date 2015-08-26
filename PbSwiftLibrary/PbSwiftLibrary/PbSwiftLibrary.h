//
//  PbSwiftLibrary.h
//  PbSwiftLibrary
//
//  Created by Maqiang on 15/8/26.
//  Copyright (c) 2015年 ProteanBear. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for PbSwiftLibrary.
FOUNDATION_EXPORT double PbSwiftLibraryVersionNumber;

//! Project version string for PbSwiftLibrary.
FOUNDATION_EXPORT const unsigned char PbSwiftLibraryVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <PbSwiftLibrary/PublicHeader.h>
class PbLog
{
    static let isDebug
    class func debug(infor:String)
    class func error(error:String)
}

