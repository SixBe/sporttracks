//
//  SBWorkoutSummary.m
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

#import "SBWorkoutSummary.h"
#import "SBWorkout.h"
#import "NSDate+RFCAndISO.h"

@implementation SBWorkoutSummary

- (NSString *)mapJSONKeyToPropertyKey:(NSString *)JSONKey
{
    static NSDictionary *__mapping = nil;
    if (__mapping == nil) {
        __mapping = @{
                      @"start_time" : @"startTime",
                      @"type" : @"type",
                      @"name" : @"name",
                      @"total_distance" : @"distance",
                      @"duration" : @"duration",
                      @"user_id" : @"userId",
                      @"uri" : @"detailsURI"};
                      
    }
    return [__mapping objectForKey:JSONKey];
}

- (NSDictionary *)JSONDataToPost
{
    NSMutableDictionary *JSONData = [[NSMutableDictionary alloc] init];
    NSArray *postKeys = @[@"start_time", @"type", @"name", @"notes", @"total_distance", @"duration"];
    for (NSString *JSONkey in postKeys) {
        NSString *propertyKey = [self mapJSONKeyToPropertyKey:JSONkey];
        id value = [self valueForKey:propertyKey];
        
        if (value && [value isKindOfClass:[NSDate class]]) {
            [JSONData setObject:[value iso8601String] forKey:JSONkey];
        } else if (value) {
            [JSONData setObject:value forKey:JSONkey];
        }
    }
    return JSONData;
}

@end
