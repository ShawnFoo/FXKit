//
//  FXKit.h
//  FXKit
//
//  Created by ShawnFoo on 2018/1/2.
//  Copyright © 2018年 ShawnFoo. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<FXKit/FXKit.h>)

//! Project version number for FXKit.
FOUNDATION_EXPORT double FXKitVersionNumber;

//! Project version string for FXKit.
FOUNDATION_EXPORT const unsigned char FXKitVersionString[];

#import <FXKit/CADisplayLink+FXWeakTarget.h>

#import <FXKit/NSArray+FXRearrange.h>
#import <FXKit/NSTimer+FXWeakTarget.h>
#import <FXKit/NSUserDefaults+FXSynchronizeSetter.h>

#import <FXKit/UIView+FXOverlayCornerRadius.h>

#import <FXKit/FXReuseObjectQueue.h>
#import <FXKit/FXDeallocMonitor.h>

#import <FXKit/FXDateUtil.h>
#import <FXKit/FXFileUtil.h>
#import <FXKit/FXPageUtil.h>

#else

#import "CADisplayLink+FXWeakTarget.h"

#import "NSArray+FXRearrange.h"
#import "NSTimer+FXWeakTarget.h"
#import "NSUserDefaults+FXSynchronizeSetter.h"

#import "UIView+FXOverlayCornerRadius.h"

#import "FXReuseObjectQueue.h"
#import "FXDeallocMonitor.h"

#import "FXDateUtil.h"
#import "FXFileUtil.h"
#import "FXPageUtil.h"

#endif
