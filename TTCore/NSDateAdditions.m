//
//  NSDateAdditions.m
//  TTCore
//
//  Created by shaohua on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDateAdditions.h"

@implementation NSDate (TTCoreAdditions)

- (BOOL)isSameDayAsDate:(NSDate *)date {
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comps1 = [[NSCalendar currentCalendar] components:unitFlags fromDate:self];
    NSDateComponents *comps2 = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    return ([comps1 year] == [comps2 year]) && ([comps1 month] == [comps2 month]) && ([comps1 day] == [comps2 day]);
}

- (BOOL)isSameYearAsDate:(NSDate *)date {
    NSUInteger unitFlags = NSYearCalendarUnit;
    NSDateComponents *comps1 = [[NSCalendar currentCalendar] components:unitFlags fromDate:self];
    NSDateComponents *comps2 = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
    return [comps1 year] == [comps2 year];
}

- (BOOL)isToday {
    return [self isSameDayAsDate:[NSDate date]];
}

- (BOOL)isYesterday {
    return [self isSameDayAsDate:[NSDate dateWithTimeIntervalSinceNow:-86400]];
}

- (BOOL)isThisYear {
    return [self isSameYearAsDate:[NSDate date]];
}

@end
