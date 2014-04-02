//
//  SBWorkout.m
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
#import "SBWorkout.h"
#import "SBWorkoutSummary.h"
#import "NSDate+RFCAndISO.h"

@implementation SBWorkout

- (void)dealloc
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - KVC implementation
- (NSUInteger)countOfDistances
{
    return [self.distances count];
}

- (id)objectInDistancesAtIndex:(NSUInteger)index
{
    return [self.distances objectAtIndex:index];
}

- (NSUInteger)countOfLocations
{
    return [self.locations count];
}

- (id)objectInLocationsAtIndex:(NSUInteger)index
{
    return [self.locations objectAtIndex:index];
}

- (NSUInteger)countOfHeartRates
{
    return [self.heartRates count];
}

- (id)objectInHeartRatesAtIndex:(NSUInteger)index
{
    return [self.heartRates objectAtIndex:index];
}

#pragma mark - Public methods
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
                      @"clock_duration" : @"clockDuration",
                      @"calories" : @"calories",
                      @"elevation_gain" : @"elevationGain",
                      @"elevation_loss" : @"elevationLoss",
                      @"notes" : @"notes",
                      @"max_speed" : @"maxSpeed",
                      @"avg_heartrate" : @"avgHeartRate",
                      @"max_heartrate" : @"maxHeartRate",
                      @"avg_cadence" : @"avgCadence",
                      @"max_cadence" : @"maxCadence",
                      @"location" : @"locations",
                      @"distance" : @"distances",
                      @"heartrate" : @"heartRates",
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
            [JSONData setValue:[value iso8601String] forKey:JSONkey];
        } else if (value) {
            [JSONData setValue:value forKey:JSONkey];
        }
    }
    return JSONData;
}

- (NSArray *)displayProperties
{
    return @[
             @"name",
             @"startTime",
             @"distance",
             @"duration",
             @"calories",
             @"elevationGain",
             @"elevationLoss",
             @"avgHeartRate",
             @"maxHeartRate",
             @"avgCadence",
             @"maxCadence",
             @"notes"
             ];
}
@end
