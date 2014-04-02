//
//  SBWorkout.h
//  sporttracks
//
//  Created by Michael on 1/4/14.
//  Copyright (c) 2014 SixBe. All rights reserved.
//

#import "SBBaseModelObject.h"

@interface SBWorkout : SBBaseModelObject
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSNumber *clockDuration;
@property (nonatomic, strong) NSNumber *calories;
@property (nonatomic, strong) NSNumber *elevationGain;
@property (nonatomic, strong) NSNumber *elevationLoss;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSNumber *maxSpeed;
@property (nonatomic, strong) NSNumber *maxHeartRate;
@property (nonatomic, strong) NSNumber *avgHeartRate;
@property (nonatomic, strong) NSNumber *maxCadence;
@property (nonatomic, strong) NSNumber *avgCadence;

@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) NSArray *distances;
@property (nonatomic, strong) NSArray *heartRates;

- (NSArray *)displayProperties;
- (NSString *)displayNameForKey:(NSString *)key;
- (NSString *)displayValueForKey:(NSString *)key;
@end
