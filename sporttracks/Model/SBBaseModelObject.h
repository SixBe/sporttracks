//
//  SBBaseModelObject.h
//  sporttracks
//
//  Created by Michael on 31/3/14.
//  Copyright (c) 2014 SixBe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBBaseModelObject : NSObject

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSString *detailsURI;
@property (nonatomic, strong) NSString *uniqueId;

- (NSString *)mapJSONKeyToPropertyKey:(NSString *)JSONKey;
- (void)setupWithJSON:(NSDictionary *)JSONDictionary;

- (UIImage *)imageForActivityType:(NSString *)type;
@end
