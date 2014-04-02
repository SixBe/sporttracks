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

@end
