#import "Formatter.h"

#import <React/RCTBridgeModule.h>
#import <React/RCTBridge.h>
#import "Macros.h"
#import "json.h"

#import <React/RCTBlobManager.h>
#import <React/RCTUIManager.h>
#import <React/RCTBridge+Private.h>
#import <ReactCommon/RCTTurboModule.h>
#import "DateFormatter.h"
#import "CurrencyFormatter.h"

@interface Formatter()
{
    DateFormatter* dateFormatter;
    CurrencyFormatter* currencyFormatter;
    jsi::Runtime* _runtime;
}

@end

@implementation Formatter
RCT_EXPORT_MODULE()

-(id)init {
    if ( self = [super init] ) {
        dateFormatter = [[DateFormatter alloc] init];
        currencyFormatter = [[CurrencyFormatter alloc] init];
    }
    return self;
}

+ (BOOL)requiresMainQueueSetup {
    return FALSE;
}

RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(install) {
    NSLog(@"Installing DateFormatter polyfill Bindings...");
    auto _bridge = [RCTBridge currentBridge];
    auto _cxxBridge = (RCTCxxBridge*)_bridge;
    if (_cxxBridge == nil) return @false;
    _runtime = (jsi::Runtime*) _cxxBridge.runtime;
    if (_runtime == nil) return @false;
    [self installJSIBindings];
    return @true;
}

-(jsi::String) toJSIString:(NSString*)value {
  return jsi::String::createFromUtf8(*_runtime, [value UTF8String] ?: "");
}

-(void)installJSIBindings {
    auto chatLikeFormat = JSI_HOST_FUNCTION("chatLikeFormat", 1) {
        auto rawDate = args[0].asNumber() / 1000.0;
        auto formatted = [dateFormatter chatLikeFormat:rawDate];
        return jsi::String::createFromUtf8(runtime, [formatted cStringUsingEncoding:NSUTF8StringEncoding]);
    });
    
    auto setLocale = JSI_HOST_FUNCTION("setLocale", 1) {
        auto rawLocale = args[0].asString(runtime).utf8(runtime);
        auto locale = [[NSString alloc] initWithCString:rawLocale.c_str() encoding:NSUTF8StringEncoding];
        auto newLocale = [[NSLocale alloc] initWithLocaleIdentifier:locale];
        if ([newLocale countryCode] != nil) {
            [dateFormatter setLocale:newLocale];
            [currencyFormatter setLocale:newLocale];
            return jsi::Value(true);
        }
        return jsi::Value(false);
    });
    
    auto getLocale = JSI_HOST_FUNCTION("getLocale", 0) {
        auto obj = jsi::Object(runtime);
        auto currentLocale = dateFormatter.currentLocale;
        auto str = [[NSString alloc] initWithFormat:@"%@_%@", [currentLocale languageCode], [currentLocale countryCode]];
        auto code = [currentLocale languageCode];
        auto locale = [[NSLocale alloc] initWithLocaleIdentifier:str];
        obj.setProperty(runtime, "displayName", [self toJSIString:[locale localizedStringForLanguageCode: code]]);
        obj.setProperty(runtime, "name", [self toJSIString:[currentLocale localizedStringForLanguageCode: code]]);
        obj.setProperty(runtime, "code", [self toJSIString:[locale languageCode]]);
        obj.setProperty(runtime, "changeCode", [self toJSIString:str]);
        
        return obj;
    });
    
    auto availableLocales = JSI_HOST_FUNCTION("availableLocales", 0) {
        NSArray* languages = [NSLocale availableLocaleIdentifiers];
        auto array = jsi::Array(runtime, [languages count]);
        auto currentLocale = dateFormatter.currentLocale;

        for (int i = 0; i < [languages count]; i++) {
            auto obj = jsi::Object(runtime);
            auto code = (NSString*)[languages objectAtIndex:i];
            auto locale = [[NSLocale alloc] initWithLocaleIdentifier:code];
            obj.setProperty(runtime, "displayName", [self toJSIString:[locale localizedStringForLanguageCode: code]]);
            
            obj.setProperty(runtime, "name", [self toJSIString:[currentLocale localizedStringForLanguageCode: code]]);
            obj.setProperty(runtime, "code", [self toJSIString:[locale languageCode]]);
            auto str = [[NSString alloc] initWithFormat:@"%@_%@", [locale languageCode], [locale countryCode]];
            obj.setProperty(runtime, "changeCode", [self toJSIString:str]);
            array.setValueAtIndex(runtime, i, obj);
        }
        return array;
    });
    
    auto hoursMinutes = JSI_HOST_FUNCTION("hoursMinutes", 1) {
        auto rawDate = args[0].asNumber() / 1000.0;
        auto formatted = [dateFormatter hoursMinutes:rawDate];
        return [self toJSIString:formatted];
    });
    
    auto format = JSI_HOST_FUNCTION("format", 2) {
        auto rawDate = args[0].asNumber() / 1000.0;
        auto rawFormat = args[1].asString(runtime).utf8(runtime);
        auto format = [[NSString alloc] initWithUTF8String:rawFormat.c_str()];
        auto formatted = [dateFormatter format:rawDate pattern:format];
        return [self toJSIString:formatted];
    });
    
    auto timeAgo = JSI_HOST_FUNCTION("timeAgo", 2) {
        auto rawDate = args[0].asNumber() / 1000.0;
        auto rawStyle = args[1].asString(runtime).utf8(runtime);
        auto style = [[NSString alloc] initWithUTF8String:rawStyle.c_str()];
        auto formatted = [dateFormatter timeAgo:rawDate style:style];
        return [self toJSIString:formatted];
    });
    
    auto formatCurrency = JSI_HOST_FUNCTION("formatCurrency", 2) {
        auto rawValue = args[0].asNumber();
        
        auto formatted = [currencyFormatter format:rawValue];
        return [self toJSIString:formatted];
    });
    
    auto exportModule = jsi::Object(*_runtime);
    exportModule.setProperty(*_runtime, "chatLikeFormat", std::move(chatLikeFormat));
    exportModule.setProperty(*_runtime, "hoursMinutes", std::move(hoursMinutes));
    exportModule.setProperty(*_runtime, "format", std::move(format));
    exportModule.setProperty(*_runtime, "timeAgo", std::move(timeAgo));
    exportModule.setProperty(*_runtime, "fromNow", std::move(timeAgo));
    exportModule.setProperty(*_runtime, "setLocale", std::move(setLocale));
    exportModule.setProperty(*_runtime, "getLocale", std::move(getLocale));
    exportModule.setProperty(*_runtime, "availableLocales", std::move(availableLocales));
    exportModule.setProperty(*_runtime, "formatCurrency", std::move(formatCurrency));
    _runtime->global().setProperty(*_runtime, "__formatter", exportModule);
}

@end
