//
//  SBWorkoutSummary.m
//  sporttracks
//
//  Created by Michael on 31/3/14.
//  Copyright (c) 2014 SixBe. All rights reserved.
//

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
