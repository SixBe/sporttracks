//
//  SBUser.h
//  sporttracks
//
//  Created by Michael on 31/3/14.
//  Copyright (c) 2014 SixBe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBUser : NSObject
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) NSDate *tokenExpiresAt;

+ (instancetype)sharedInstance;
- (BOOL)isLoggedIn;
@end
