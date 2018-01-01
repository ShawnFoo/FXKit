//
//  NSTimer+FXWeakTargetTest.m
//  FXKitDemoTests
//
//  Created by ShawnFoo on 2017/10/23.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSTimer+FXWeakTarget.h"

static BOOL sTargetDeallocated;

@interface FXTimerTarget : NSObject

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL deallocLogging;

@end

@implementation FXTimerTarget

- (void)dealloc {
	if (_deallocLogging) {
		sTargetDeallocated = YES;
	}
}

@end


@interface NSTimer_FXWeakTargetTest : XCTestCase

@property (nonatomic, strong) FXTimerTarget *timerTarget;

@end

@implementation NSTimer_FXWeakTargetTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testScheduledTimer {
	const NSTimeInterval kInterval = 1.0;
	const NSTimeInterval kTimeOffset = 0.1;// 时间偏差
	const int kTriggetTimes = 1;
	__block int bTimes = 0;
	__block NSTimeInterval bEndTime;
	NSTimeInterval startTime;
	
	FXTimerTarget *target = [[FXTimerTarget alloc] init];
	target.timer = [NSTimer fx_scheduledTimerWithInterval:kInterval
												   target:target
													block:^(NSTimer * _Nonnull timer)
					{
						bTimes++;
						bEndTime = [[NSDate date] timeIntervalSince1970];
					}];
	startTime = [[NSDate date] timeIntervalSince1970];
	self.timerTarget = target;
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		XCTAssertTrue(!self.timerTarget.timer.valid, @"NSTimer invalidate 失败!");
		XCTAssertTrue(bTimes == kTriggetTimes, @"NSTimer触发次数不对!");
		XCTAssertTrue(bEndTime - startTime <= (kInterval + kTimeOffset), @"NSTimer的触发偏差大于%f", kTimeOffset);
	});
}

- (void)testScheduledRepeatedTimer {
	const NSTimeInterval kInterval = 1.0;
	const int kTriggetTimes = 4;
	__block int bTimes = 0;
	
	FXTimerTarget *target = [[FXTimerTarget alloc] init];
	target.timer = [NSTimer fx_scheduledTimerWithInterval:kInterval
												   target:target
													block:^(NSTimer * _Nonnull timer)
					{
						bTimes++;
						if (bTimes >= kTriggetTimes) {
							[timer invalidate];
						}
					}];
	self.timerTarget = target;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kInterval * kTriggetTimes * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		XCTAssertTrue(!self.timerTarget.timer.valid, @"NSTimer invalidate 失败!");
		XCTAssertTrue(bTimes == kTriggetTimes, @"NSTimer触发次数不对!");
	});
}

- (void)testUnfireTimer {
	const NSTimeInterval kInterval = 1.0;
	const int kTriggetTimes = 0;
	__block int bTimes = 0;
	
	FXTimerTarget *target = [[FXTimerTarget alloc] init];
	target.timer = [NSTimer fx_timerWithInterval:1.0
										  target:target
										   block:^(NSTimer * _Nonnull timer) {
											   bTimes++;
										   }];
	self.timerTarget = target;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		XCTAssertTrue(self.timerTarget.timer.valid, @"未激活的NSTimer状态不对!");
		XCTAssertTrue(bTimes == kTriggetTimes, @"未激活的NSTimer触发了!");
	});
}

- (void)testTimerFire {
	const NSTimeInterval kInterval = 1.0;
	const int kTriggetTimes = 1;
	__block int bTimes = 0;
	
	FXTimerTarget *target = [[FXTimerTarget alloc] init];
	target.timer = [NSTimer fx_timerWithInterval:1.0
										  target:target
										   block:^(NSTimer * _Nonnull timer) {
											   bTimes++;
										   }];
	self.timerTarget = target;
	[target.timer fire];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		XCTAssertTrue(!self.timerTarget.timer.valid, @"NSTimer invalidate 失败!");
		XCTAssertTrue(bTimes == kTriggetTimes, @"NSTimer触发次数不对!");
	});
}

- (void)testTimerRepeat {
	const NSTimeInterval kInterval = 1.0;
	const int kTriggetTimes = 3;
	__block int bTimes = 0;
	
	FXTimerTarget *target = [[FXTimerTarget alloc] init];
	target.timer = [NSTimer fx_scheduledTimerWithInterval:kInterval
												   target:target
													block:^(NSTimer * _Nonnull timer)
					{
						bTimes++;
						if (bTimes >= kTriggetTimes) {
							[timer invalidate];
						}
					}];
	self.timerTarget = target;
	[target.timer fire];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kInterval * kTriggetTimes * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		XCTAssertTrue(!self.timerTarget.timer.valid, @"NSTimer invalidate 失败!");
		XCTAssertTrue(bTimes == kTriggetTimes, @"NSTimer触发次数不对!");
	});
}

- (void)testAutoReleaseTimer {
	sTargetDeallocated = NO;
	
	const NSTimeInterval kInterval = 1.0;
	const int kTriggetTimes = 4;
	__block int bTimes = 0;
	
	FXTimerTarget *target = [[FXTimerTarget alloc] init];
	target.deallocLogging = YES;
	target.timer = [NSTimer fx_scheduledTimerWithInterval:kInterval
												   target:target
													block:^(NSTimer * _Nonnull timer)
					{
						bTimes++;
					}];
	self.timerTarget = target;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTriggetTimes * kInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		self.timerTarget = nil;
		XCTAssertTrue(sTargetDeallocated, @"NSTimer强持有Target!");
	});
}

@end
