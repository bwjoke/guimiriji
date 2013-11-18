//
//  WMMojingDetailViewViewController.m
//  WEIMI
//
//  Created by SteveMa on 13-11-4.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMMojingDetailViewViewController.h"

@interface WMMojingDetailViewViewController ()
{
    UIWebView *webView;
}
@end

@implementation WMMojingDetailViewViewController

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
    self.titleLabel.text = _titleName;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#cd6050"];
    [self.showTableView removeFromSuperview];
    self.showTableView = nil;
    [self.headBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-shit"]] atIndex:0];
    [self addBackButton];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, SCREEN_HEIGHT-64)];
    webView.delegate = self;
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_url]]];
    [self.contentView addSubview:webView];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    ProgressLoading;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    ProgressHide;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    ProgressFailed;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
