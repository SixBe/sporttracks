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

- (NSString *)displayValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"startTime"]) {
        // Format using time formatter
        static NSDateFormatter *__formatter = nil;
        if (__formatter == nil) {
            __formatter = [[NSDateFormatter alloc] init];
            [__formatter setTimeStyle:NSDateFormatterShortStyle];
            [__formatter setDateStyle:NSDateFormatterMediumStyle];
        }
        return [__formatter stringFromDate:(NSDate *)[self valueForKey:key]];
    }
    else if ([key isEqualToString:@"duration"] || [key isEqualToString:@"clockDuration"]) {
        float seconds = [(NSNumber *)[self valueForKey:key] floatValue];
        float hours = floorf(seconds / 3600.f);
        float minutes = floorf((seconds - hours * 3600) / 60.f);
        seconds = seconds - 60.f * minutes - hours * 3600.f;
        return [NSString stringWithFormat:@"%.0f:%02.0f:%02.0f", hours, minutes, seconds];
    } else if ([key isEqualToString:@"distance"]) {
        // Format m to km
        return [NSString stringWithFormat:@"%3.2fkm", [(NSNumber *)[self valueForKey:key] floatValue] / 1000];
    } else if ([key isEqualToString:@"elevationGain"] || [key isEqualToString:@"elevationLoss"]) {
        // Add meters
        return [NSString stringWithFormat:@"%3.0fm", [(NSNumber *)[self valueForKey:key] floatValue]];
    } else if ([key isEqualToString:@"avgHeartRate"] || [key isEqualToString:@"maxHeartRate"]) {
        // Add meters
        return [NSString stringWithFormat:@"%3.0fbpm", [(NSNumber *)[self valueForKey:key] floatValue]];
    } else if ([key isEqualToString:@"avgCadence"] || [key isEqualToString:@"maxCadence"]) {
        // Add meters
        return [NSString stringWithFormat:@"%3.0fspm", [(NSNumber *)[self valueForKey:key] floatValue]];
    } else if ([key isEqualToString:@"calories"]) {
        // Add meters
        return [NSString stringWithFormat:@"%3.0fkJ", [(NSNumber *)[self valueForKey:key] floatValue]];
    }
    return [NSString stringWithFormat:@"%@", [self valueForKey:key]];
}

@end
