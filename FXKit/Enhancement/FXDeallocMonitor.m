//
//  FXDeallocMonitor.h
//  FXKit
//
//  Created by ShawnFoo on 9/16/15.
//  Copyright © 2015年 ShawnFoo. All rights reserved.
//

#import "FXDeallocMonitor.h"
#import <objc/runtime.h>

static NSString * (^sLogFormatBlock)(id object);

@interface FXDeallocMonitor ()

@property (copy, nonatomic) NSString *log;
@property (copy, nonatomic) dispatch_block_t deallocBlock;

@end

@implementation FXDeallocMonitor

#pragma mark - LifeCycle
+ (void)initialize {
	if (self == [FXDeallocMonitor class]) {
		sLogFormatBlock = ^(id object) {
			return @"%@: 已经释放了.";
		};
	}
}

- (void)dealloc {
	if (sLogFormatBlock) {
		if (_log.length) {
			NSLog(@"%@: %@", self, _log);
		}
		else {
			NSLog(@"%@", sLogFormatBlock(self));
		}
	}
	if (_deallocBlock) {
		_deallocBlock();
	}
}

#pragma mark - Public Class Methods
+ (void)setLogFormatBlock:(NSString * (^)(id))formatBlock {
	sLogFormatBlock = [formatBlock copy];
}

+ (void)addMonitorToObject:(id)object {
	[self addMonitorToObject:object withLog:nil block:nil];
}

+ (void)addMonitorToObject:(id)object withLog:(NSString *)log {
	[self addMonitorToObject:object withLog:log block:nil];
}

+ (void)addMonitorToObject:(id)object withBlock:(dispatch_block_t)block {
	[self addMonitorToObject:object withLog:nil block:block];
}

+ (void)addMonitorToObject:(id)object withLog:(NSString *)log block:(dispatch_block_t)block {
#if DEBUG
	if (!object) {
		return;
	}
	FXDeallocMonitor *monitor = [[FXDeallocMonitor alloc] init];
	monitor.log = log;
	monitor.deallocBlock = block;

	int randomKey;
	objc_setAssociatedObject(object,
							 &randomKey,
							 monitor,
							 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#endif
}

@end


@implementation NSObject (FXDellocMonitor)

- (void)fx_addDeallocMonitor {
	[FXDeallocMonitor addMonitorToObject:self];
}

- (void)fx_addDeallocMonitorWithLog:(NSString *)log {
	[FXDeallocMonitor addMonitorToObject:self withLog:log];
}

- (void)fx_addDeallocMonitorWithBlock:(dispatch_block_t)block {
	[FXDeallocMonitor addMonitorToObject:self withBlock:block];
}

- (void)fx_addDeallocMonitorWithLog:(NSString *)log block:(dispatch_block_t)block {
	[FXDeallocMonitor addMonitorToObject:self withLog:log block:block];
}

@end
