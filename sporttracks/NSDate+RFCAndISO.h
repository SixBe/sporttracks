//
//  NSDate+RFCAndISO.h
//  sporttracks
//
//  Created by Michael on 2/4/14.
//  Copyright (c) 2014 SixBe. All rights reserved.
//

#import <Foundation/Foundation.h>


// All informations for date formatting can be found at the following links:
// Reference on server date string: http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1
// Article on NSFormatter for such strings: http://blog.mro.name/2009/08/nsdateformatter-http-header/
// Apple reference on imposing format: Technical Q&A QA1480: https://developer.apple.com/library/ios/qa/qa1480/_index.html
//
// To specify custom fixed format for a date formatter you must use the patterns from the Unicode Technical Standard #35. Different version can be used with different OS
// for iOS7: http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
// for iOS6: http://www.unicode.org/reports/tr35/tr35-25.html#Date_Format_Patterns
// for iOS5: http://www.unicode.org/reports/tr35/tr35-19.html#Date_Format_Patterns

@interface NSDate (RFCAndISO)
+ (NSDate *)dateFromRFC1123String:(NSString *)string;
+ (NSDate *)dateFromISO8601String:(NSString *)string;

- (NSString *)rfc1123String;
- (NSString *)rfc3339String;
- (NSString *)iso8601String;
@end
