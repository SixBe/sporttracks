//
//  SBWorkout.h
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

#import "SBBaseModelObject.h"

@class SBWorkoutSummary;
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

@property (nonatomic, weak) SBWorkoutSummary *summary;

- (NSArray *)displayProperties;
@end
