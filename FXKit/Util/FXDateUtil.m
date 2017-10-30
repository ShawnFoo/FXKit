
//
//  FXDateUtil.m
//  FXKit
//
//  Created by ShawnFoo on 2017/10/30.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import "FXDateUtil.h"

NS_ASSUME_NONNULL_BEGIN

const NSTimeInterval FXDate_OneMinuteSeconds = 60;
const NSTimeInterval FXDate_OneHourSeconds = FXDate_OneMinuteSeconds * 60;
const NSTimeInterval FXDate_OneDaySeconds = FXDate_OneHourSeconds * 24;

@implementation FXDateUtil

+ (NSDate *)localDate {
	return [[NSDate date] dateByAddingTimeInterval:[self secondsFromGMTForSystemTimeZone]];
}

+ (NSTimeInterval)secondsFromGMTForSystemTimeZone {
	NSDate *date = [NSDate date];
	NSTimeZone *zone = [NSTimeZone systemTimeZone];
	return [zone secondsFromGMTForDate:date];
}

+ (NSUInteger)daysOfMonth {
	return [self daysOfCurrentCalendarInUnit:NSCalendarUnitMonth];
}

+ (NSUInteger)daysOfYear {
	return [self daysOfCurrentCalendarInUnit:NSCalendarUnitYear];
}

+ (NSUInteger)daysOfCurrentCalendarInUnit:(NSCalendarUnit)unit {
	NSDate *date = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	return [calendar rangeOfUnit:NSCalendarUnitDay inUnit:unit forDate:date].length;
}

+ (NSUInteger)daysOfMonth:(NSUInteger)month atYear:(NSUInteger)year {
	switch (month) {
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12: {
			return 31;
		}
			
		case 4:
		case 6:
		case 9:
		case 11: {
			return 30;
		}
			
		case 2:
		default: {
			if (year%4 == 1 || year%4 == 2 || year%4 == 3) {
				return 28;
			}
			else if (year % 400 == 0) {
				return 29;
			}
			else if (year % 100 == 0) {
				return 28;
			}
			else {
				return 29;
			}
		}
	}
}

+ (NSString *)dayInWeekOfDate:(NSDate *)date {
	static NSCalendar *sWeekCalendar = nil;
	static NSArray<NSString *> *sWeekdays = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sWeekCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
		sWeekCalendar.timeZone = [NSTimeZone systemTimeZone];
		sWeekdays = @[@"Unknown", @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
	});
	NSInteger weekday = [sWeekCalendar component:NSCalendarUnitWeekday fromDate:date];
	return sWeekdays[weekday];
}

@end


#pragma mark - FXDateUtil + Format
@implementation FXDateUtil (Format)

+ (NSString *)timeGapFormatWithGMTIntervalSince1970:(NSTimeInterval)interval {
	NSDate *earlyDate = [NSDate dateWithTimeIntervalSince1970:interval];
	NSDate *now = [NSDate date];
	if (NSOrderedDescending != [earlyDate compare:now]) {
		NSUInteger gap = [now timeIntervalSinceDate:earlyDate];
		if (gap > FXDate_OneMinuteSeconds) {
			if (gap < FXDate_OneHourSeconds) {
				return [NSString stringWithFormat:@"%@分钟前", @(gap/FXDate_OneMinuteSeconds)];
			}
			else if (gap < FXDate_OneDaySeconds) {
				return [NSString stringWithFormat:@"%@小时前", @(gap/FXDate_OneHourSeconds)];
			}
			else {
				return [NSString stringWithFormat:@"%@天前", @(gap/FXDate_OneDaySeconds)];
			}
		}
	}
	return @"1分钟前";
}

+ (NSString *)wechatTimeGapFormatWithGMTIntervalSince1970:(NSTimeInterval)interval {
	NSString *timeFormat = nil;
	
	NSTimeInterval nowSeconds = [[self localDate] timeIntervalSince1970];
	NSTimeInterval inSeconds = interval + [self secondsFromGMTForSystemTimeZone];
	NSInteger nowDay = nowSeconds / FXDate_OneDaySeconds;
	NSInteger inDay = inSeconds / FXDate_OneDaySeconds;
	
	if (nowDay == inDay) {// 当天仅显示 时间 hh:mm
		timeFormat = [NSDate dateWithTimeIntervalSince1970:inSeconds].description;
		timeFormat = [timeFormat substringWithRange:NSMakeRange(11, 5)];
	}
	else {
		NSInteger daysDiff = nowDay - inDay;
		if (1 == daysDiff) {// 只差1天, 就显示昨天
			timeFormat = @"昨天";
		}
		else if (daysDiff > 1 && daysDiff <= 6) {// 差2~6天显示星期几
			timeFormat = [self dayInWeekOfDate:[NSDate dateWithTimeIntervalSince1970:inDay]];
		}
		else {// 差7天以上或非法数据 显示日期
			NSArray<NSNumber *> *yearMonthDay = [self yearMonthDayForGMTIntervalSince1970:interval];
			timeFormat = [NSString stringWithFormat:@"%@/%@/%@", yearMonthDay[0], yearMonthDay[1], yearMonthDay[2]];
		}
	}
	
	return timeFormat;
}

+ (NSString *)systemDateFormatWithGMTIntervalSince1970:(NSTimeInterval)interval {
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
	return [date.description substringWithRange:NSMakeRange(0, 19)];
}

+ (NSString *)monthDayFormatWithGMTIntervalSince1970:(NSTimeInterval)interval {
	return [self monthDayWithGMTIntervalSince1970:interval
								   andFormatBlock:^NSString * (NSInteger month, NSInteger day) {
									   return [NSString stringWithFormat:@"%02ld-%02ld", month, day];
								   }];
}

+ (NSString *)monthDayWithGMTIntervalSince1970:(NSTimeInterval)interval andFormatBlock:(NSString * (^)(NSInteger, NSInteger))formatBlock {
	NSArray<NSNumber *> *yearMonthDay = [self yearMonthDayForGMTIntervalSince1970:interval];
	return formatBlock(yearMonthDay[1].integerValue, yearMonthDay[2].integerValue);
}

+ (NSString *)yearMonthDayFormatWithGMTIntervalSince1970:(NSTimeInterval)interval {
	return [self yearMonthDayWithGMTIntervalSince1970:interval
									   andFormatBlock:^NSString * (NSInteger year, NSInteger month, NSInteger day) {
										   return [NSString stringWithFormat:@"%ld-%02ld-%02ld", year, month, day];
									   }];
}

+ (NSString *)yearMonthDayWithGMTIntervalSince1970:(NSTimeInterval)interval
									andFormatBlock:(NSString * (^)(NSInteger, NSInteger, NSInteger))formatBlock {
	NSArray<NSNumber *> *yearMonthDay = [self yearMonthDayForGMTIntervalSince1970:interval];
	return formatBlock(yearMonthDay[0].integerValue,
					   yearMonthDay[1].integerValue,
					   yearMonthDay[2].integerValue);

}

+ (NSArray<NSNumber *> *)yearMonthDayForGMTIntervalSince1970:(NSTimeInterval)interval {
	NSString *dateDesc = [NSDate dateWithTimeIntervalSince1970:interval].description;
	NSInteger year = [[dateDesc substringWithRange:NSMakeRange(2, 2)] integerValue];
	NSInteger month = [[dateDesc substringWithRange:NSMakeRange(5, 2)] integerValue];
	NSInteger day = [[dateDesc substringWithRange:NSMakeRange(8, 2)] integerValue];
	return @[
			 @(year),
			 @(month),
			 @(day)
			 ];
}

@end

NS_ASSUME_NONNULL_END
