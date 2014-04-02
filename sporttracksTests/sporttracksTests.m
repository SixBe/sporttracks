//
//  sporttracksTests.m
//  sporttracksTests
//
//  Created by Michael on 28/3/14.
//  Copyright (c) 2014 SixBe. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDate+RFCAndISO.h"
@interface sporttracksTests : XCTestCase

@end

@implementation sporttracksTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDateFromRFC1123String
{
    NSString *test = @"Sun, 06 Nov 1994 08:49:37 GMT"; // RFC 822, updated by RFC 1123
    NSDate *date = [NSDate dateFromRFC1123String:test];
    XCTAssert(date != nil, @"String %@ should get properly transformed into a date", test);
}

- (void)testDateFromRFC850String
{
    NSString *test = @"Sunday, 06-Nov-94 08:49:37 GMT"; // RFC 850, obsoleted by RFC 1036
    NSDate *date = [NSDate dateFromRFC1123String:test];
    XCTAssert(date != nil, @"String %@ should get properly transformed into a date", test);
}

- (void)testDateFromAnsiString
{
    NSString *test = @"Sun Nov  6 08:49:37 1994"; // ANSI C's asctime() format
    NSDate *date = [NSDate dateFromRFC1123String:test];
    XCTAssert(date != nil, @"String %@ should get properly transformed into a date", test);
}

- (void)testDateFromISO8601StringWithoutMilliseconds
{
    NSString *test = @"2012-04-23T13:12:34-05:00";
    NSDate *date = [NSDate dateFromISO8601String:test];
    XCTAssert(date != nil, @"String %@ should get properly transformed into a date", test);
    
    test = @"2012-04-23T13:12:34+05:00";
    date = [NSDate dateFromISO8601String:test];
    XCTAssert(date != nil, @"String %@ should get properly transformed into a date", test);
    
    test = @"2012-04-23T13:12:34-0500";
    date = [NSDate dateFromISO8601String:test];
    XCTAssert(date != nil, @"String %@ should get properly transformed into a date", test);
    
    test = @"2012-04-23T13:12:34+0500";
    date = [NSDate dateFromISO8601String:test];
    XCTAssert(date != nil, @"String %@ should get properly transformed into a date", test);
    
    test = @"2012-04-23T13:12:34-05";
    date = [NSDate dateFromISO8601String:test];
    XCTAssert(date != nil, @"String %@ should get properly transformed into a date", test);
    
    test = @"2012-04-23T13:12:34+05";
    date = [NSDate dateFromISO8601String:test];
    XCTAssert(date != nil, @"String %@ should get properly transformed into a date", test);
    
    test = @"2012-04-23T13:12:34Z";
    date = [NSDate dateFromISO8601String:test];
    XCTAssert(date != nil, @"String %@ should get properly transformed into a date", test);
}

- (void)testDateFromISO8601StringWithMilliseconds
{
    NSString *test = @"2012-04-23T13:12:34.456-05:00";
    NSDate *date = [NSDate dateFromISO8601String:test];
    XCTAssert(date != nil, @"String %@ should get properly transformed into a date", test);
    
    test = @"2012-04-23T13:12:34.456+05:00";
    date = [NSDate dateFromISO8601String:test];
    XCTAssert(date != nil, @"String %@ should get properly transformed into a date", test);
    
    test = @"2012-04-23T13:12:34.456-0500";
    date = [NSDate dateFromISO8601String:test];
    XCTAssert(date != nil, @"String %@ should get properly transformed into a date", test);
    
    test = @"2012-04-23T13:12:34.456+0500";
    date = [NSDate dateFromISO8601String:test];
    XCTAssert(date != nil, @"String %@ should get properly transformed into a date", test);
    
    test = @"2012-04-23T13:12:34.456-05";
    date = [NSDate dateFromISO8601String:test];
    XCTAssert(date != nil, @"String %@ should get properly transformed into a date", test);
    
    test = @"2012-04-23T13:12:34.456+05";
    date = [NSDate dateFromISO8601String:test];
    XCTAssert(date != nil, @"String %@ should get properly transformed into a date", test);
    
    test = @"2012-04-23T13:12:34.456Z";
    date = [NSDate dateFromISO8601String:test];
    XCTAssert(date != nil, @"String %@ should get properly transformed into a date", test);
}

@end
