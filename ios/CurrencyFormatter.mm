//
//  CurrencyFormatter.m
//  Formatter
//
//  Created by Sergei Golishnikov on 02/12/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import "CurrencyFormatter.h"

@interface CurrencyFormatter()
{
    NSNumberFormatter* formatter;
}

@end

@implementation CurrencyFormatter


-(id)init {
    if ( self = [super init] ) {
        _currentLocale = [NSLocale currentLocale];
        [self initFormatter];
    }
    return self;
}

-(void) initFormatter {
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setRoundingMode:NSNumberFormatterRoundDown];
    [formatter setLocale:_currentLocale];
}

-(void)setLocale:(NSLocale*)locale {
    _currentLocale = locale;
    [self initFormatter];
}

-(NSString*)format:(double)value {
    return [formatter stringFromNumber:[[NSNumber alloc] initWithDouble:value]];
}
@end