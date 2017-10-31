//
//  NSUserDefaults+FXSynchronizeSetter.h
//  FXKit
//
//  Created by ShawnFoo on 2017/10/24.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (FXSynchronizeSetter)

- (BOOL)fx_syncSetObject:(nullable id)object forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
