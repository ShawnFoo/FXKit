//
//  NSArray+Rearrange.h
//  FXKit
//
//  Created by ShawnFoo on 2017/10/24.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Rearrange)

- (NSArray *)fx_reverse;
- (NSArray *)fx_removeDuplicatedElements;

@end

NS_ASSUME_NONNULL_END
