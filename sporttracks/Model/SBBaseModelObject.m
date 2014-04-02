//
//  SBBaseModelObject.m
//  sporttracks
//
//  Created by Michael on 31/3/14.
//  Copyright (c) 2014 SixBe. All rights reserved.
//

#import "SBBaseModelObject.h"
#import "NSDate+RFCAndISO.h"

@implementation SBBaseModelObject
#pragma mark - KVO implementation
+ (NSSet *)keyPathsForValuesAffectingUniqueId
{
    return [NSSet setWithObject:@"detailsURI"];
}

- (NSString *)uniqueId
{
    return [self.detailsURI lastPathComponent];
}

#pragma mark - Public methods
- (NSString *)mapJSONKeyToPropertyKey:(NSString *)JSONKey
{
    return nil;
}

- (void)setupWithJSON:(NSDictionary *)JSONDictionary
{
    for (NSString *key in [JSONDictionary allKeys]) {
        id value = [JSONDictionary objectForKey:key];
        NSString *propertyKey = [self mapJSONKeyToPropertyKey:key];
        
        if ([propertyKey isEqualToString:@"startTime"]) {
            value = [NSDate dateFromISO8601String:value];
        }
        
        if (propertyKey) { // Need to do something for dates...
            [self setValue:value forKey:propertyKey];
        }
    }
}

- (UIImage *)imageForActivityType:(NSString *)type
{
    NSString *typeImageName = nil;
    NSArray *stringComponents = [type componentsSeparatedByString:@":"];
    typeImageName = [stringComponents firstObject];
    return [UIImage imageNamed:typeImageName];
}

@end
