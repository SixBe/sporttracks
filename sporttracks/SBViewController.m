//
//  SBViewController.m
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


#import "SBViewController.h"
#import "SBUser.h"
#import "SBAPIManager.h"


@interface SBViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation SBViewController
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    BOOL requiresLogin = [[SBAPIManager sharedInstance] userRequiresLogin];
    [self.webView setHidden:!requiresLogin];
    [self.progressView setHidden:requiresLogin];
    
    if (requiresLogin) {
        [self.webView loadRequest:[[SBAPIManager sharedInstance] OAuthAuthorizationCodeRequest]];
    } else {
        [self performSegueWithIdentifier:@"showHistory" sender:self];
    }

}

- (void)showProgressView:(BOOL)show text:(NSString *)text
{
    if (show) {
        [self.progressView setHidden:NO];
        [self.progressView setAlpha:0.0];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:0
                         animations:^{
                             [self.progressView setAlpha:1.0];
                         } completion:^(BOOL finished) {
                             
                         }];
    } else {
        [self.progressView setAlpha:1.0];
        [UIView animateWithDuration:0.5
                              delay:1.0
                            options:0
                         animations:^{
                             [self.progressView setAlpha:0.0];
                         } completion:^(BOOL finished) {
                             [self.progressView setHidden:YES];
                             [self.progressView setAlpha:1.0];
                         }];

    }
}

#pragma mark - UIWebViewDelegate protocol implementation
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Request url: %@", request.URL);
    
    if ([[SBAPIManager sharedInstance] canProcessOAuthRedirectWithRequest:request]  ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showProgressView:YES text:@"Authorizing application to access your data..."];
        });
        
        [[SBAPIManager sharedInstance] processOAuthRedirectWithRequest:request completionBlock:^(BOOL succeeded){
            if (!succeeded) {
                [self showProgressView:NO text:@"Authorization failed. Please try again."];
                return;
            }
            
            [self performSegueWithIdentifier:@"showHistory" sender:self];
        }];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showProgressView:YES text:@"Loading data..."];
    });
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showProgressView:NO text:@"Loading data..."];
    });

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
@end
