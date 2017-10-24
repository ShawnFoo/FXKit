//
//  NSArray+Rearrange.m
//  FXKit
//
//  Created by ShawnFoo on 2017/10/24.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import "NSArray+Rearrange.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSArray (Rearrange)

- (NSArray *)fx_reverse {
    return [[self reverseObjectEnumerator] allObjects];
}

- (NSArray *)fx_removeDuplicatedElements {
    NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:self];
    return set.array;
}

@end

NS_ASSUME_NONNULL_END
