//
//  NSDate+RFCAndISO.h
//  sporttracks
//
// The MIT License (MIT)
//
// Copyright (c) 2014 Michael Gachet
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


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
