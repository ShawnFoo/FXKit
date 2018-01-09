//
//  FXDeallocMonitor.h
//  FXKit
//
//  Created by ShawnFoo on 9/16/15.
//  Copyright © 2015年 ShawnFoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 该类可用于监控对象的释放, 检测内存泄露问题. 主要监控对象的dealloc方法是否执行.
 
 idea来源于我毕业后第一份工作导师, 达文哥
 */
@interface FXDeallocMonitor : NSObject

/**
 设置全局日志格式. 默认为 [NSString stringWithFormat:"%@: 已经释放了.", object]

 @param formatBlock 全局日志生成Block
 */
+ (void)setLogFormatBlock:(nullable NSString * (^)(id object))formatBlock;

/**
 `Debug模式下` 给对象添加监控者, 会在其dealloc方法中简单打印其释放log.

 @param object 要监控的对象
 */
+ (void)addMonitorToObject:(id)object;

/**
 `Debug模式下` 给对象添加监控者, 会在其dealloc方法中打印传入的log消息.

 @param object 要监控的对象
 @param log 被监控对象delloc方法执行时打印的log消息
 */
+ (void)addMonitorToObject:(id)object withLog:(nullable NSString *)log;

/**
 `Debug模式下` 给对象添加监控者, 会在其dealloc方法中执行特定block.

 @param object 要监控的对象
 @param block 被监控对象delloc方法执行时 跑的block. 请遵循dealloc方法中不要执行耗时的操作规范!
 */
+ (void)addMonitorToObject:(id)object withBlock:(nullable dispatch_block_t)block;

/**
 `Debug模式下` 给对象添加监控者, 会在其dealloc方法中执行特定block, 并打印传入log消息

 @param object 要监控的对象
 @param log 被监控对象delloc方法执行时打印的log消息
 @param block 被监控对象delloc方法执行时 跑的block. 请遵循dealloc方法中不要执行耗时的操作规范!
 */
+ (void)addMonitorToObject:(id)object withLog:(nullable NSString *)log block:(nullable dispatch_block_t)block;

@end


@interface NSObject (FXDellocMonitor)

/**
 `Debug模式下` 给对象添加监控者, 会在其dealloc方法中简单打印其释放log.
 */
- (void)fx_addDeallocMonitor;

/**
 `Debug模式下` 给对象添加监控者, 会在其dealloc方法中打印传入的log消息.

 @param log 被监控对象delloc方法执行时打印的log消息
 */
- (void)fx_addDeallocMonitorWithLog:(nullable NSString *)log;

/**
 `Debug模式下` 给对象添加监控者, 会在其dealloc方法中执行特定block.

 @param block 被监控对象delloc方法执行时 跑的block. 请遵循dealloc方法中不要执行耗时的操作规范!
 */
- (void)fx_addDeallocMonitorWithBlock:(nullable dispatch_block_t)block;

/**
 `Debug模式下` 给对象添加监控者, 会在其dealloc方法中执行特定block, 并打印传入log消息
 
 @param log 被监控对象delloc方法执行时打印的log消息
 @param block 被监控对象delloc方法执行时 跑的block. 请遵循dealloc方法中不要执行耗时的操作规范!
 */
- (void)fx_addDeallocMonitorWithLog:(nullable NSString *)log block:(nullable dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
