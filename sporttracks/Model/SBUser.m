//
//  SBUser.m
//  sporttracks
//
//  Created by Michael on 31/3/14.
//  Copyright (c) 2014 SixBe. All rights reserved.
//

#import "SBUser.h"

@implementation SBUser

+(instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{ instance = [[self alloc] init]; });
    return instance;
}

- (BOOL)isLoggedIn
{
    if (self.accessToken && [self.tokenExpiresAt timeIntervalSinceNow] > 0) {
        return YES;
    }
    return NO;
}
@end
