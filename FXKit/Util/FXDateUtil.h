//
//  FXDateUtil.h
//  FXKit
//
//  Created by ShawnFoo on 2017/10/30.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern const NSTimeInterval FXDate_OneMinuteSeconds;
extern const NSTimeInterval FXDate_OneHourSeconds;
extern const NSTimeInterval FXDate_OneDaySeconds;

/**
 FXDateUtil: 提供当前时区时间获取、当前月份、某一年天数等方法
 FXDateUtil + Format: 提供日期格式化方法
 */
@interface FXDateUtil : NSObject

/** 当前时区时间. */
+ (NSDate *)localDate;

/** 系统时区与GMT时区相差的秒数. */
+ (NSTimeInterval)secondsFromGMTForSystemTimeZone;

/** 当前系统月份的天数. */
+ (NSUInteger)daysOfMonth;

/** 当前系统年份的天数 */
+ (NSUInteger)daysOfYear;

/** 某一年某月的天数. */
+ (NSUInteger)daysOfMonth:(NSUInteger)month atYear:(NSUInteger)year;

/** 星期几. */
+ (NSString *)dayInWeekOfDate:(NSDate *)date;

@end


@interface FXDateUtil (Format)

/** 返回简单的时间差格式. 比如"n分钟前、n小时前、n天前". */
+ (NSString *)timeGapFormatWithGMTIntervalSince1970:(NSTimeInterval)interval;

/** 微信时间差格式. 规则: 当天显示hh:mm, 只差1天显示昨天, 差2~6天显示星期几, 其余显示日期。 */
+ (NSString *)wechatTimeGapFormatWithGMTIntervalSince1970:(NSTimeInterval)time;

/** 返回日历日期(如"1991.01.22 12:21")。 */
+ (NSString *)systemDateFormatWithGMTIntervalSince1970:(NSTimeInterval)interval;

/** 返回MM-dd(月-日)格式的日期.  */
+ (NSString *)monthDayFormatWithGMTIntervalSince1970:(NSTimeInterval)interval;

/** 返回自定义月日格式的日期 */
+ (NSString *)monthDayWithGMTIntervalSince1970:(NSTimeInterval)interval
								andFormatBlock:(NSString * (^)(NSInteger month, NSInteger day))formatBlock;

/** 返回yyyy-MM-dd(年-月-日格式的日期). */
+ (NSString *)yearMonthDayFormatWithGMTIntervalSince1970:(NSTimeInterval)interval;

/** 返回自定义年月日格式的日期 */
+ (NSString *)yearMonthDayWithGMTIntervalSince1970:(NSTimeInterval)interval
									andFormatBlock:(NSString * (^)(NSInteger year, NSInteger month, NSInteger day))formatBlock;

@end

NS_ASSUME_NONNULL_END
