//
//  WMDiscussWebViewController.m
//  WEIMI
//
//  Created by steve on 13-7-10.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMDiscussWebViewController.h"

@interface WMDiscussWebViewController ()

@end

@implementation WMDiscussWebViewController

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
	// Do any additional setup after loading the view.
    [self.headBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-shit"]] atIndex:0];
    [self addHeadShadow];
    

    [self addBackButton];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    self.titleLabel.text = @"话题";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cd6050"];
    
    CGRect frame = self.view.frame;
    frame.origin.y += 43;
    frame.size.height -= 43;
    
    UIWebView *appView = [[UIWebView alloc] initWithFrame:frame];
    appView.delegate = self;
    [appView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    [self.contentView addSubview:appView];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    ProgressHide;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    ProgressLoading;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    ProgressNetWorkError;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
