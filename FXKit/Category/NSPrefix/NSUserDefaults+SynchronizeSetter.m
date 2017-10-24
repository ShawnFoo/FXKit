//
//  NSUserDefaults+SynchronizeSetter.m
//  FXKit
//
//  Created by ShawnFoo on 2017/10/24.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import "NSUserDefaults+SynchronizeSetter.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSUserDefaults (SynchronizeSetter)

- (BOOL)fx_syncSetObject:(nullable id)object forKey:(NSString *)key {
    [self setObject:object forKey:key];
    return [self synchronize];
}

@end

NS_ASSUME_NONNULL_END
