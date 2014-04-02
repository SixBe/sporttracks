//
//  SBBaseModelObject.m
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
