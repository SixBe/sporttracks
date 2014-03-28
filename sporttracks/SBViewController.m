//
//  SBViewController.m
//  sporttracks
//
//  Created by Michael on 28/3/14.
//  Copyright (c) 2014 SixBe. All rights reserved.
//

#import "SBViewController.h"

static NSString * const ks_APIClient = @"sixbe";
static NSString * const ks_APISecret = @"HJ4KGXZQCRRG3UZQ";
static NSString * const ks_APICallbackURI = @"sporttracks://sixbe.com/oauth_redirect/";
static NSString * const ks_APICallbackScheme = @"sporttracks";
static NSString * const ks_APICallbackHost = @"sixbe.com";
static NSString * const ks_APIBaseURLString = @"https://api.sporttracks.mobi/oauth2/";


static NSString * const ks_UserDefaultsAPICodeKey = @"ks_UserDefaultsAPICodeKey";
static NSString * const ks_UserDefaultsExpiryDateKey = @"ks_UserDefaultsExpiryDateKey";

@interface SBViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@end

@implementation SBViewController
#pragma mark - Properties
- (NSOperationQueue *)operationQueue
{
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
        [_operationQueue setName:@"networking queue"];
    }
    return _operationQueue;
}

#pragma mark - Memory management
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View life cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BOOL requiresLogin = YES;
    [self.webView setHidden:!requiresLogin];
    
    if (requiresLogin) {
        NSString *stateString = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setValue:stateString forKey:ks_UserDefaultsAPICodeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *urlString = [NSString stringWithFormat:@"%@authorize?client_id=%@&redirect_uri=%@&state=%@&response_type=code", ks_APIBaseURLString, ks_APIClient, ks_APICallbackURI,stateString];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [self.webView loadRequest:request];
    }
}

#pragma mark - UIWebViewDelegate protocol implementation
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Request url: %@", request.URL);
    
    if ([[request.URL scheme] isEqualToString:ks_APICallbackScheme] && [[request.URL host] isEqualToString:ks_APICallbackHost]) {
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
        
        // Check that everything is allright
        if (![state isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:ks_UserDefaultsAPICodeKey]]) {
            // Some tampering here... cancel with error message
            return NO;
        }
        
        // Send a request to get the auth token
        NSURL *baseURL = [NSURL URLWithString:ks_APIBaseURLString];
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
            return NO;
        }
        [request setHTTPBody:postData];
        
        [NSURLConnection sendAsynchronousRequest:request queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError) {
                NSLog(@"Connection error: %@", connectionError.localizedDescription);
                return;
            }
            NSError *error = nil;
            NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error) {
                NSLog(@"Error reading JSONData: %@", error.localizedDescription);
            }
            
            for (NSString *key in [responseData allKeys]) {
                NSString *value = [responseData valueForKey:key];
                [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSNumber *expires_in = [[NSUserDefaults standardUserDefaults] valueForKey:@"expires_in"];
            NSDate *expiryDate = [NSDate dateWithTimeIntervalSinceNow:[expires_in intValue]];
            
            [[NSUserDefaults standardUserDefaults] setValue:expiryDate forKey:ks_UserDefaultsExpiryDateKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
        
        return NO;
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
@end
