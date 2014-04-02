//
//  SBWorkoutSummary.h
//  sporttracks
//
//  Created by Michael on 31/3/14.
//  Copyright (c) 2014 SixBe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBBaseModelObject.h"

@interface SBWorkoutSummary : SBBaseModelObject
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSNumber *userId;

- (NSString *)displayValueForKey:(NSString *)key;
@end
