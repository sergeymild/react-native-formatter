//
//  DateFormatter.m
//  Formatter
//
//  Created by Sergei Golishnikov on 02/12/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import "DateFormatter.h"

@implementation DateFormatter

int is24Hours_ = -1;

-(id)init {
    if ( self = [super init] ) {
        NSString *identifier = [[[NSLocale preferredLanguages] firstObject] stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
        _currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:identifier];
    }
    return self;
}

-(NSDateFormatter*)getFormatter:(NSString*)pattern {
    auto formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:_currentLocale];
    [formatter setDateFormat:pattern];
    return formatter;
}

-(NSDateFormatter*) shortTimeFormatter {
    auto formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:_currentLocale];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    return formatter;
}

-(NSDateFormatter*) shortDateFormatter {
    auto formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:_currentLocale];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    return formatter;
}

-(NSDateFormatter*) shortWeekNameFormatter {
    return [self getFormatter:@"EEE"];
}


 
- (bool)is24HourClock {
    if (is24Hours_ != -1) return is24Hours_ == 1;
    NSDateFormatter* formatter = [NSDateFormatter new];
    
    NSLocale *locale = [NSLocale currentLocale];
    
    [formatter setLocale:locale];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:72000];
    is24Hours_ = [[formatter stringFromDate:date] containsString:@"20"] ? 1 : 0;
    return is24Hours_ == 1;
}

- (BOOL)isInCurrentWeek:(NSDate *)date
{
    NSDate *startDate = nil;
    NSTimeInterval interval = 0.0;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // calendar.firstWeekday = 1; set the index of the first weekday if necessary
    [calendar rangeOfUnit:NSCalendarUnitWeekOfYear startDate: &startDate interval: &interval forDate: [NSDate date]];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitSecond value: (NSInteger)interval toDate: startDate options:NSCalendarMatchNextTime];
    return [date compare:startDate] == NSOrderedDescending && [date compare:endDate] == NSOrderedAscending;
}

-(void)setLocale:(NSLocale*)locale {
    _currentLocale = locale;
}

-(NSString*)chatLikeFormat:(double)rawDate {
    auto date = [[NSDate alloc] initWithTimeIntervalSince1970:rawDate];
    NSDateFormatter* formatter;
    if ([[NSCalendar currentCalendar] isDateInToday:date]) {
        formatter = [self shortTimeFormatter];
    } else if ([self isInCurrentWeek:date]) {
        formatter = [self shortWeekNameFormatter];
    } else {
        formatter = [self shortDateFormatter];
    }
    
    return [formatter stringFromDate:date];
}

-(NSString*)hoursMinutes:(double)rawDate {
    auto date = [[NSDate alloc] initWithTimeIntervalSince1970:rawDate];
    return [[self shortTimeFormatter] stringFromDate:date];
}

-(NSString*)format:(double)rawDate pattern:(NSString*)pattern {
    auto date = [[NSDate alloc] initWithTimeIntervalSince1970:rawDate];
    auto formatter = [self getFormatter:pattern];
    return [formatter stringFromDate:date];
}

-(double)parseFormat:(NSString*)rawDate pattern:(NSString*)pattern {
    auto formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:pattern];
    auto timezone = [[NSTimeZone alloc] initWithName:@"UTC"];
    [formatter setTimeZone:timezone];
    NSDate *date = [formatter dateFromString:rawDate];
    if (date == NULL) return -1;
    return date.timeIntervalSince1970;
}

-(NSString*)simpleFormat:(double)rawDate {
    auto date = [[NSDate alloc] initWithTimeIntervalSince1970:rawDate];
    return [[self shortDateFormatter] stringFromDate:date];
}

-(NSString*)formatElapsedTime:(double)rawDate {
    auto elapsed = [NSNumber numberWithDouble:rawDate];
    NSUInteger h = elapsed.intValue / 3600;
    NSUInteger m = (elapsed.intValue / 60) % 60;
    NSUInteger s = elapsed.intValue % 60;
    return [NSString stringWithFormat:@"%lu:%02lu:%02lu", (unsigned long)h, (unsigned long)m, (unsigned long)s];
}

-(NSString*)timeAgo:(double)rawDate style:(NSString*)style {
    auto date = [[NSDate alloc] initWithTimeIntervalSince1970:rawDate];
    
    auto formatter = [[NSRelativeDateTimeFormatter alloc] init];
    [formatter setLocale:_currentLocale];

    if ([style isEqualToString: @"full"]) {
        [formatter setUnitsStyle:NSRelativeDateTimeFormatterUnitsStyleFull];
    } else if ([style isEqualToString: @"spellOut"]) {
        [formatter setUnitsStyle:NSRelativeDateTimeFormatterUnitsStyleSpellOut];
    }

    return [formatter localizedStringFromTimeInterval:[date timeIntervalSinceNow]];
}

@end
