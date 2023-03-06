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
    NSNumberFormatter* numbersFormatter;
    NSString* currencySymbol;
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
    currencySymbol = [formatter currencySymbol];
    
    numbersFormatter = [[NSNumberFormatter alloc] init];
    [numbersFormatter setNumberStyle:NSNumberFormatterNoStyle];
    [numbersFormatter setRoundingMode:NSNumberFormatterRoundDown];
    [numbersFormatter setLocale:_currentLocale];
}

-(void)setLocale:(NSLocale*)locale {
    _currentLocale = locale;
    [self initFormatter];
}

-(NSString*)format:(double)value symbol:(NSString*)symbol {
    [formatter setCurrencySymbol:[symbol isEqualToString:@"current"] ? currencySymbol : symbol];
    return [formatter stringFromNumber:[[NSNumber alloc] initWithDouble:value]];
}

-(NSString*)localizeNumbers:(double)value isFloat:(bool)isFloat {
    [numbersFormatter setNumberStyle: isFloat ? NSNumberFormatterDecimalStyle : NSNumberFormatterNoStyle];
    return [numbersFormatter stringFromNumber:[[NSNumber alloc] initWithDouble:value]];
}
@end
