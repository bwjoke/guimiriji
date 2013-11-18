//
//  WMTopicDetailViewController.m
//  WEIMI
//
//  Created by steve on 13-6-9.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTopicDetailViewController.h"
#import "WMNotificationCenter.h"

@interface WMTopicDetailViewController ()
{
    UIWebView *currentWebView;
    NSString *pageurl;
    JSBridgeWebView *appView;
}
@end

@implementation WMTopicDetailViewController

-(void)dealloc
{
    [_URL release];
    [super dealloc];
}

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
    [self.headBar removeFromSuperview];
    self.headBar = nil;
    self.navigationController.navigationBarHidden = YES;
    
    CGRect frame = self.view.frame;
    appView = [[JSBridgeWebView alloc] initWithFrame:frame];
    appView.delegate = self;
    appView.backgroundColor = [UIColor colorWithHexString:@"#F5EEE3"];
    appView.opaque = NO;
    appView.dataDetectorTypes = UIDataDetectorTypeNone;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    
    [self.contentView addSubview:appView];
    [appView release];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
    [appView addGestureRecognizer:swipe];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *url = [NSString stringWithFormat:@"%@?device=iphone",_URL];
    [appView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    ProgressHide;
    currentWebView = webView;
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    ProgressLoading;
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
    } else if ([action isEqualToString:@"back"]) {
        [NKNC popViewControllerAnimated:YES];
    }
}

//-(void)goBack:(id)sender
//{
//    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"keywords\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", currentWebView.frame.size.width];
//    
//    NSLog(@"webview :%@",[currentWebView stringByEvaluatingJavaScriptFromString:meta]);
//    if (currentWebView.canGoBack) {
//        [currentWebView goBack];
//        [NKNC popViewControllerAnimated:YES];
//    }else {
//        [NKNC popViewControllerAnimated:YES];
//    }
//}
@end
