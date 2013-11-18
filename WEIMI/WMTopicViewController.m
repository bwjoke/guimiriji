//
//  WMTopicViewController.m
//  WEIMI
//
//  Created by steve on 13-6-8.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTopicViewController.h"
#import "WMTopicDetailViewController.h"
#import "WMMUser.h"

#import "NSString+MD5.h"
#import "WMNotificationCenter.h"

@interface WMTopicViewController ()

@end

@implementation WMTopicViewController {
    JSBridgeWebView *_webView;
}

#define test_url @"http://yangqi.weimi.dev.xq.lab/gossip/"
#define server_url @"http://www.weimi.com/gossip/"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect frame = self.view.frame;
    frame.size.height = frame.size.height-46;
    
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5EEE3"];
    
    JSBridgeWebView *appView = [[JSBridgeWebView alloc] initWithFrame:frame];
    appView.delegate = self;
    appView.backgroundColor = [UIColor colorWithHexString:@"#F5EEE3"];
    appView.opaque = NO;
    appView.dataDetectorTypes = UIDataDetectorTypeNone;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    NSString *uid = [[[WMMUser me] mid] description];
    NSString *verify = [[uid stringByAppendingString:@"weimitopic"] MD5Hash];
    
    NSString *url = [NSString stringWithFormat:@"%@?uid=%@&verify=%@&device=iphone&v=8",server_url, uid, verify];
    [appView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    appView.opaque = NO;
    [self.contentView addSubview:appView];
    [appView release];
    
    _webView = appView;
    
    // Remove the head bar
    [self.headBar removeFromSuperview];
    self.headBar = nil;
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    ProgressHide;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //ProgressLoading;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    ProgressNetWorkError;
}

-(void)webView:(UIWebView *)webview didReceiveJSNotificationWithDictionary:(NSDictionary *)dictionary
{
    NSString *action = [dictionary valueForKey:@"action"];
    
    if ([action isEqualToString:@"newpage"] || [action isEqualToString:@"pic"] || [action isEqualToString:@"notify"]) {
        NSString *url = [dictionary valueForKey:@"url"];
        WMTopicDetailViewController *vc = [[[WMTopicDetailViewController alloc] init] autorelease];
        vc.URL = url;
        [NKNC pushViewController:vc animated:YES];
        if ([action isEqualToString:@"notify"]) {
            [[WMNotificationCenter sharedNKNotificationCenter] setHasNotification:[NSNumber numberWithBool:NO]];
        }
    } else if ([action isEqualToString:@"back"]) {
        [NKNC popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [_webView reload];
}

@end
