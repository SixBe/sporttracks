//
//  SBAPIManager.h
//  sporttracks
//
//  Created by Michael on 31/3/14.
//  Copyright (c) 2014 SixBe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBAPIManager : NSObject
+ (instancetype)sharedInstance;

- (BOOL)userRequiresLogin;
- (NSURLRequest *)OAuthAuthorizationCodeRequest;
- (BOOL)canProcessOAuthRedirectWithRequest:(NSURLRequest *)request;
- (void)processOAuthRedirectWithRequest:(NSURLRequest *)request completionBlock:(void(^)(BOOL succedeed))completionBlock;

- (void)retrieveAccessTokenWithCompletionBlock:(void(^)(BOOL succedeed))completionBlock;
- (void)refreshAccessTokenWithCompletionBlock:(void(^)(BOOL succedeed))completionBlock;
- (void)retrieveWorkoutHistoryWithCompletionBlock:(void(^)(BOOL succeded, NSDictionary *responseData))completionBlock;
- (void)retrieveWorkoutWithId:(NSString *)workoutId completionBlock:(void(^)(BOOL succeded, NSDictionary *responseData))completionBlock;

@end
