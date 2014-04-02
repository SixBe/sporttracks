//
//  NSDate+RFCAndISO.m
//  sporttracks
//
//  Created by Michael on 2/4/14.
//  Copyright (c) 2014 SixBe. All rights reserved.
//

#import "NSDate+RFCAndISO.h"
static NSDateFormatter *__rfc1123DateFormatter = nil;

@implementation NSDate (RFCAndISO)
+ (NSDate *)dateFromRFC1123String:(NSString *)string
{
    if (string == nil) {
        return nil;
    }
    
    static NSArray *__rfc1123Formats = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __rfc1123DateFormatter = [[NSDateFormatter alloc] init];
        __rfc1123DateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        __rfc1123DateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        
        __rfc1123Formats = @[
                             @"EEE',' dd MMM yyyy HH':'mm':'ss z", // Most modern format
                             @"EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z", // RFC850
                             @"EEE MMM d HH':'mm':'ss yyyy" // Ansi
                             ];
        
    });
    
    NSDate *result = nil;
    for (NSString *format in __rfc1123Formats) {
        __rfc1123DateFormatter.dateFormat = format;
        result = [__rfc1123DateFormatter dateFromString:string];
        if (result) {
            break;
        }
    }
    return result;
}

+ (NSDate *)dateFromISO8601String:(NSString *)string
{
    if (!string) {
        return nil;
    }
    
    static NSDateFormatter *__iso8601DateFormatter = nil;
    static NSArray *__iso8601Formats = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __iso8601DateFormatter = [[NSDateFormatter alloc] init];
        __iso8601DateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        __iso8601DateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        
        __iso8601Formats = @[
                             @"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ", // 2014-04-02T13:12:43Z or 2014-04-02T13:12:43+02:00 or 2014-04-02T13:12:43+0200 or 2014-04-02T13:12:43+02
                             @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ" // 2014-04-02T13:12:43.123Z or 2014-04-02T13:12:43.123+02:00 or 2014-04-02T13:12:43.123+0200 or 2014-04-02T13:12:43.123+02
                            ];

    });
    
    NSDate *result = nil;
    for (NSString *format in __iso8601Formats) {
        __iso8601DateFormatter.dateFormat = format;
        result = [__iso8601DateFormatter dateFromString:string];
        if (result) {
            break;
        }
    }
    return result;
}

- (NSString*)rfc1123String
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __rfc1123DateFormatter = [[NSDateFormatter alloc] init];
        __rfc1123DateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        __rfc1123DateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        __rfc1123DateFormatter.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss GMT";
    });

    return [__rfc1123DateFormatter stringFromDate:self];
}

- (NSString*)rfc3339String
{
    return [self rfc1123String];
}

- (NSString*)iso8601String
{
    return [self rfc1123String];
}
@end
