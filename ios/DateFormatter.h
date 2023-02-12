//
//  DateFormatter.h
//  Formatter
//
//  Created by Sergei Golishnikov on 02/12/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateFormatter : NSObject
@property NSLocale *currentLocale;

-(NSString*)chatLikeFormat:(double)rawDate;
-(NSString*)hoursMinutes:(double)rawDate;
-(NSString*)format:(double)rawDate pattern:(NSString*)pattern;
-(bool)is24HourClock;
-(NSString*)timeAgo:(double)rawDate style:(NSString*)style;
-(NSString*)simpleFormat:(double)rawDate;
-(void)setLocale:(NSLocale*)locale;
@end

NS_ASSUME_NONNULL_END
