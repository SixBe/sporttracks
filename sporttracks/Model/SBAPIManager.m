//
//  SBAPIManager.m
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

#import "SBAPIManager.h"

static NSString * const ks_APIClient = @"sixbe";
static NSString * const ks_APISecret = @"HJ4KGXZQCRRG3UZQ";
static NSString * const ks_APICallbackURI = @"sporttracks://sixbe.com/oauth_redirect/";
static NSString * const ks_APICallbackScheme = @"sporttracks";
static NSString * const ks_APICallbackHost = @"sixbe.com";
static NSString * const ks_APIBaseOAuthURLString = @"https://api.sporttracks.mobi/oauth2/";
static NSString * const ks_APIBaseURLString = @"https://api.sporttracks.mobi/api/v2/";


static NSString * const ks_UserDefaultsAPIStateKey = @"ks_UserDefaultsAPIStateKey";
static NSString * const ks_UserDefaultsAPICodeKey = @"ks_UserDefaultsAPICodeKey";
static NSString * const ks_UserDefaultsExpiryDateKey = @"ks_UserDefaultsExpiryDateKey";

@interface SBAPIManager ()
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@end


@implementation SBAPIManager
#pragma mark - Properties
- (NSOperationQueue *)operationQueue
{
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
        [_operationQueue setName:@"networking queue"];
    }
    return _operationQueue;
}

#pragma mark - Singleton management
+(instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{ instance = [[self alloc] init]; });
    return instance;
}

#pragma mark - Instance public methods
- (BOOL)userRequiresLogin
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"] == nil;
}

- (NSURLRequest *)OAuthAuthorizationCodeRequest
{
    NSString *stateString = [[NSUUID UUID] UUIDString];
    [[NSUserDefaults standardUserDefaults] setValue:stateString forKey:ks_UserDefaultsAPIStateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *urlString = [NSString stringWithFormat:@"%@authorize?client_id=%@&redirect_uri=%@&state=%@&response_type=code", ks_APIBaseOAuthURLString, ks_APIClient, ks_APICallbackURI,stateString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    return request;
}

- (BOOL)canProcessOAuthRedirectWithRequest:(NSURLRequest *)request
{
    return [[request.URL scheme] isEqualToString:ks_APICallbackScheme] && [[request.URL host] isEqualToString:ks_APICallbackHost];
}

- (void)processOAuthRedirectWithRequest:(NSURLRequest *)request completionBlock:(void(^)(BOOL succeeded))completionBlock
{
    NSString *query = [request.URL query];
    NSArray *params = [query componentsSeparatedByString:@"&"];
    NSString *code = nil;
    NSString *state = nil;
    for (NSString *param in params) {
        NSArray *keyValue = [param componentsSeparatedByString:@"="];
        NSString *key = [keyValue objectAtIndex:0];
        NSString *value = [keyValue objectAtIndex:1];
        
        if ([key isEqualToString:@"code"]) {
            code = value;
        } else if ([key isEqualToString:@"state"]) {
            state = value;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:code forKey:ks_UserDefaultsAPICodeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Check that everything is allright
    if (![state isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:ks_UserDefaultsAPIStateKey]]) {
        // Some tampering here... cancel with error message
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(NO);
        });
        return;
    }
    
    [self retrieveAccessTokenWithCompletionBlock:^(BOOL succedeed) {
        if (!succedeed) {
            completionBlock(NO);
            return;
        }
        completionBlock(YES);
    }];

}

- (void)retrieveAccessTokenWithCompletionBlock:(void(^)(BOOL succedeed))completionBlock
{
    NSString *code = [[NSUserDefaults standardUserDefaults] valueForKey:ks_UserDefaultsAPICodeKey];
    if (!code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(NO);
        });
        return;
    }
    
    NSURL *baseURL = [NSURL URLWithString:ks_APIBaseOAuthURLString];
    NSURL *url = [NSURL URLWithString:@"token" relativeToURL:baseURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *headerParameters = @{@"Accept" : @"application/json",
                                       @"Content-Type" : @"application/json"};
    [request setAllHTTPHeaderFields:headerParameters];
    
    NSDictionary *bodyParameters = @{@"client_id" : ks_APIClient,
                                     @"client_secret" : ks_APISecret,
                                     @"redirect_uri" : ks_APICallbackURI,
                                     @"grant_type" : @"authorization_code",
                                     @"code" : code};
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:bodyParameters options:0 error:&error];
    if (error) {
        NSLog(@"Error serializing body parameters: %@", error.localizedDescription);
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(NO);
        });
        return;
    }
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"Connection error: %@", connectionError.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO);
            });
            return;
        }
        NSError *error = nil;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            NSLog(@"Error reading JSONData: %@", error.localizedDescription);
        }
        
        NSLog(@"%s - Response Data: %@", __PRETTY_FUNCTION__, responseData);
        for (NSString *key in [responseData allKeys]) {
            NSString *value = [responseData valueForKey:key];
            [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSNumber *expires_in = [[NSUserDefaults standardUserDefaults] valueForKey:@"expires_in"];
        NSDate *expiryDate = [NSDate dateWithTimeIntervalSinceNow:[expires_in intValue]];
        
        [[NSUserDefaults standardUserDefaults] setValue:expiryDate forKey:ks_UserDefaultsExpiryDateKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(YES);
        });
    }];
}

- (void)refreshAccessTokenWithCompletionBlock:(void(^)(BOOL succedeed))completionBlock
{
    NSString *refreshToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"refresh_token"];
    if (!refreshToken) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(NO);
        });
        return;
    }
    
    NSURL *baseURL = [NSURL URLWithString:ks_APIBaseOAuthURLString];
    NSURL *url = [NSURL URLWithString:@"token" relativeToURL:baseURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *headerParameters = @{@"Accept" : @"application/json",
                                       @"Content-Type" : @"application/json"};
    [request setAllHTTPHeaderFields:headerParameters];
    
    NSDictionary *bodyParameters = @{@"client_id" : ks_APIClient,
                                     @"client_secret" : ks_APISecret,
                                     @"redirect_uri" : ks_APICallbackURI,
                                     @"grant_type" : @"refresh_token",
                                     @"code" : refreshToken};
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:bodyParameters options:0 error:&error];
    if (error) {
        NSLog(@"Error serializing body parameters: %@", error.localizedDescription);
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(NO);
        });
        return;
    }
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"Connection error: %@", connectionError.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO);
            });
            return;
        }
        NSError *error = nil;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            NSLog(@"Error reading JSONData: %@", error.localizedDescription);
        }
        
        NSLog(@"%s - Response Data: %@", __PRETTY_FUNCTION__, responseData);
        for (NSString *key in [responseData allKeys]) {
            NSString *value = [responseData valueForKey:key];
            [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSNumber *expires_in = [[NSUserDefaults standardUserDefaults] valueForKey:@"expires_in"];
        NSDate *expiryDate = [NSDate dateWithTimeIntervalSinceNow:[expires_in intValue]];
        
        [[NSUserDefaults standardUserDefaults] setValue:expiryDate forKey:ks_UserDefaultsExpiryDateKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(YES);
        });
    }];
}


- (void)retrieveWorkoutHistoryWithCompletionBlock:(void(^)(BOOL succeded, NSDictionary *responseData))completionBlock
{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"];
    if (!accessToken) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(NO, nil);
        });
        return;
    }
    
    NSURL *baseURL = [NSURL URLWithString:ks_APIBaseURLString];
    NSURL *url = [NSURL URLWithString:@"fitnessActivities" relativeToURL:baseURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSDictionary *headerParameters = @{@"Accept" : @"application/json",
                                       @"Authorization" : [NSString stringWithFormat:@"Bearer %@", accessToken]};
    [request setAllHTTPHeaderFields:headerParameters];
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"Connection error: %@", connectionError.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, nil);
            });
            return;
        }
        NSError *error = nil;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            NSLog(@"Error reading JSONData: %@", error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, nil);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(YES, responseData);
            });
        }
    }];
    
}

- (void)retrieveWorkoutWithId:(NSString *)workoutId completionBlock:(void(^)(BOOL succeded, NSDictionary *responseData))completionBlock
{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"];
    if (!accessToken || !workoutId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(NO, nil);
        });
        return;
    }
    
    NSURL *baseURL = [NSURL URLWithString:ks_APIBaseURLString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"fitnessActivities/%@", workoutId] relativeToURL:baseURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSDictionary *headerParameters = @{@"Accept" : @"application/json",
                                       @"Authorization" : [NSString stringWithFormat:@"Bearer %@", accessToken]};
    [request setAllHTTPHeaderFields:headerParameters];
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"Connection error: %@", connectionError.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, nil);
            });
            return;
        }
        NSError *error = nil;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            NSLog(@"Error reading JSONData: %@", error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, nil);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(YES, responseData);
            });
        }
    }];

}

@end
