//
//  NSDate+DateFromNow.m
//  TwitStream
//
//  Created by Devin Ozel on 9/8/13.
//  Copyright (c) 2013 Devin Ozel. All rights reserved.
//

#import "NSDate+DateFromNow.h"

@implementation NSDate (DateFromNow)

- (NSString *)timeFromThisDate {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:self
                                                  toDate:[NSDate date] options:0];
    NSInteger months = [components month];
    NSInteger days = [components day];
    NSInteger years = [components year];
    NSInteger minutes = [components minute];
    NSInteger seconds = [components second];
    
    NSInteger hours = [components hour];
    
    if (years > 0) {
        return [NSString stringWithFormat:@"%iy", years];
    }
    else if (months > 0) {
        return [NSString stringWithFormat:@"%iw", (months * 4) + (days % 7)];
    }
    else if (days > 0) {
        return [NSString stringWithFormat:@"%id", days];
    }
    else if (hours > 0) {
        return [NSString stringWithFormat:@"%ih", hours];
    }
    else if (minutes > 0) {
        return [NSString stringWithFormat:@"%im", minutes];
    }
    else {
        return [NSString stringWithFormat:@"%is", seconds];
    }
    
}

@end
